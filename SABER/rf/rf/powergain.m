function g = powergain(varargin)
%POWERGAIN Calculate power gain from 2-port S-parameters
%   G = POWERGAIN(S_PARAMS, Z0, ZS, ZL) or 
%   G = POWERGAIN(S_PARAMS, Z0, ZS, ZL, 'Gt') or 
%   G = POWERGAIN(S_OBJ, ZS, ZL) or 
%   G = POWERGAIN(S_OBJ, ZS, ZL, 'Gt') calculates the transducer
%   power gain of a 2-port network by
%
%     Gt = Pl/PavS = (1 - |GAMMAS|^2) * (|S21|^2) * (1 - |GAMMAL|^2) /
%         (|(1 - S11 * GAMMAS) * (1 - S22 * GAMMAL) - S12 * S21 GAMMAS * GAMMAL|^2)
%   
%   where Pl is the output power and PavS is the maximum input power.
%
%   The reflection coefficients are defined as:
%
%     GAMMAS  = (ZS - Z0)/(ZS + Z0)
%     GAMMAL  = (ZL - Z0)/(ZL + Z0) 
%
%   The function arguments are:
%   S_PARAMS is a complex 2x2xK array of K 2-port S-parameters. 
%   Z0 is the reference impedance of the S-parameters. The default is 50 ohms.
%   S_OBJ is a 2-port sparameters object
%   ZS is the source impedance. The default is 50 ohms.
%   ZL is the load impedance. The default is 50 ohms.
% 
%   G = POWERGAIN(S_PARAMS, Z0, ZS, 'Ga') or
%   G = POWERGAIN(S_OBJ, ZS, 'Ga') calculates the available power
%   gain of a 2-port network by
% 
%     Ga = PavN/PavS = (1 - |GAMMAS|^2) * (|S21|^2) /
%         ((|1 - S11 * GAMMAS|^2) * (1 - |GAMMAOUT|^2))
%
%   where PavN is the maximum output power and:
%     GAMMAOUT = S22 + (S12 * S21 * GAMMAS)/(1 - S11 * GAMMAS)
%
%   The remaining function arguments and equation variables are as defined
%   above.
%
%   G = POWERGAIN(S_PARAMS, Z0, ZL, 'Gp') or
%   G = POWERGAIN(S_OBJ, ZL, 'Gp') calculates the operating power
%   gain of a 2-port network by
% 
%     Gp = Pl/Pin = (|S21|^2) * (1 - |GAMMAL|^2) /
%         ((1 - |GAMMAIN|^2) * (|1 - S22 * GAMMAL|^2))
%
%   where Pin is the input power and:
%     GAMMAIN = S11 + (S12 * S21 * GAMMAL)/(1 - S22 * GAMMAL)
%
%   The remaining function arguments and equation variables are as defined
%   above.
%
%   G = POWERGAIN(S_PARAMS, 'Gmag') or  G = POWERGAIN(S_OBJ, 'Gmag')
%   calculates the maximum available power gain of a 2-port network by
% 
%     Gmag = (|S21| / |S12|) * (K - SQRT(K^2 - 1))
%
%   where K is the stability factor. S_PARAMS and S_OBJ is as defined
%   above.
%
%   G = POWERGAIN(S_PARAMS, 'Gmsg') or G = POWERGAIN(S_OBJ, 'Gmsg')
%   calculates the maximum stable power gain of a 2-port network by
% 
%     Gmsg = |S21| / |S12|
%
%   S_PARAMS and S_OBJ is as defined above.
%
%   G is unitless. To obtain power gain in decibels, use 10*log10(G).
%
%   The specified type of power gain may be undefined for one or more of
%   the specified S-parameter values in S_PARAMS or S_OBJ. The POWERGAIN
%   function returns NaN for all such values. As a result, G may be NaN or
%   it may be a vector that contains one or more NaN entries.
%
%   Reference: Guillermo Gonzalez, Microwave Transistor Amplifiers:
%   Analysis and Design, 2nd edition, Prentice Hall, 1996 
%
%   See also S2TF, SNP2SMP, Z2GAMMA, GAMMAIN, GAMMAOUT, sparameters

%   Copyright 2007-2015 The MathWorks, Inc.

narginchk(1,5)

g = [];
alltypes = {'Gt', 'Ga', 'Gp', 'Gmag', 'Gmsg'};

% Validate s_parameters
if ~isnumeric(varargin{1})
    validateattributes(varargin{1},{'numeric','sparameters'},{}, ...
        'powergain','',1)
end
[nfreq,s_params] = CheckNetworkData(varargin{1},2,'S_PARAMS');

% Determine gaintype
gaintype = varargin{end};
temp_idx = strcmpi(gaintype, alltypes);

if all(temp_idx == 0) % No gaintype found
    gaintype = 'Gt';
    varargin = varargin(2:end);
else
    varargin = varargin(2:end-1);
end
% Check if multiple types of power gain are specified.
ninputs = numel(varargin);
for ii = 1:ninputs
    if any(strcmpi(varargin{ii}, alltypes))
        error(message('rf:powergain:MultiFlagsFound'));
    end
end

z0 = 50*ones(1,1,nfreq); % Default z0
zs = 50*ones(1,1,nfreq); % Default zs
zl = 50*ones(1,1,nfreq); % Default zl
% For gains that need z0, zs, zl
all3ztypes = {'Gt'};
if any(strcmpi(gaintype, all3ztypes))
    if numel(varargin) > 0
        z0 = CheckZ(varargin{1}, nfreq, 'Z0');
    end
    if numel(varargin) > 1
        zs = CheckZ(varargin{2}, nfreq, 'ZS');
    end
    if numel(varargin) > 2
        zl = CheckZ(varargin{3}, nfreq, 'ZL');
    end
end

if any(strcmpi(gaintype, 'Ga'))
    % For gains that need only z0, zs
    if numel(varargin) > 0
        z0 = CheckZ(varargin{1}, nfreq, 'Z0');
    end
    if numel(varargin) > 1
        zs = CheckZ(varargin{2}, nfreq, 'ZS');
    end
    if numel(varargin) > 2
        if isscalar(z0) && isscalar(zs)
            warning(message('rf:powergain:TooManyInputForGaScalar', num2str( z0 ), num2str( zs )));
        else
            warning(message('rf:powergain:TooManyInputForGa'));
        end
    end
elseif any(strcmpi(gaintype, 'Gp'))
    % For gains that need only z0, zl
    if numel(varargin) > 0
        z0 = CheckZ(varargin{1}, nfreq, 'Z0');
    end
    if numel(varargin) > 1
        zl = CheckZ(varargin{2}, nfreq, 'ZL');
    end
    if numel(varargin) > 2
        if isscalar(z0) && isscalar(zl)
            warning(message('rf:powergain:TooManyInputForGpScalar', num2str( z0 ), num2str( zl )));
        else
            warning(message('rf:powergain:TooManyInputForGp'));
        end
    end
elseif any(strcmpi(gaintype, 'GMAG'))  || any(strcmpi(gaintype, 'GMSG'))
    % For gains that only need s_parameters   
    if nargin > 2
        warning(message('rf:powergain:TooManyInputForGMAG'));
    end
end

switch upper(gaintype)
    case 'GT'
        gammaL = z2gamma(zl, z0);
        gammaS = z2gamma(zs, z0);
        g = (1 - abs(gammaS).^2) .* (abs(s_params(2,1,:)).^2) .* (1 - abs(gammaL).^2) ./ ...
            (abs((1 - s_params(1,1,:).* gammaS).*(1-s_params(2,2,:).*gammaL)-s_params(1,2,:).*s_params(2,1,:).*gammaS.*gammaL).^2);

    case 'GA'
        gammaS = z2gamma(zs, z0);
        gammaOut = reshape(gammaout(s_params, z0(:), zs(:)), [1,1,nfreq]);
        g = (1 - abs(gammaS).^2) .* (abs(s_params(2,1,:)).^2) ./ ...
            ((abs(1 - s_params(1,1,:).*gammaS).^2).* (1 - abs(gammaOut).^2));

    case 'GP'
        gammaL = z2gamma(zl, z0);
        gammaIn = reshape(gammain(s_params, z0(:), zl(:)), [1,1,nfreq]);
        g = (abs(s_params(2,1,:)).^2) .* (1 - abs(gammaL).^2) ./ ...
            ((1 - abs(gammaIn).^2) .* (abs(1 - s_params(2,2,:).*gammaL).^2));

    case 'GMAG'
        k = reshape(stabilityk(s_params), [1,1,nfreq]);
        g = ((abs(s_params(2,1,:)) ./ abs(s_params(1,2,:)))) .* (k - sqrt(k.^2 - 1));
        g(abs(k) < 1) = NaN; % MSG does not exist when |k| < 1
        
    case 'GMSG'
        g = abs(s_params(2,1,:)) ./ abs(s_params(1,2,:));
end
g(g < 0) = NaN;
g =  g(:);