function tf = s2tf(s_params,varargin)
%S2TF Calculate transfer function from 2-port S-parameters
%   TF = S2TF(S_PARAMS, Z0, ZS, ZL, OPTION) or TF = S2TF(S_OBJ, ZS, ZL,
%   OPTION) calculates a voltage or power wave transfer function from
%   2-port scattering parameters defined by a 2x2xK complex numeric array
%   S_PARAMS or by an 2-port sparameters object S_OBJ. S2TF uses one of 3
%   definitions, determined by the value of the OPTION argument.
%
%     OPTION = 1: the voltage transfer function from incident voltage to
%     load voltage
%     TF1 = VL/Va = ((ZS+conj(ZS))/conj(ZS)) * 
%          S21 * (1 + GAMMAL) * (1 - GAMMAS) /
%          (2*(1 - S22 * GAMMAL) * (1 - GAMMAIN * GAMMAS))
%
%   Va is the incident voltage which is the output voltage of the source
%   when the input port is conjugately matched,
%     Va = (conj(ZS)/(ZS+conj(ZS))) * VS
% 
%     OPTION = 2: the voltage transfer function from source voltage to load
%     voltage
%     TF2 = VL/VS = S21 * (1 + GAMMAL) * (1 - GAMMAS) /
%          (2*(1 - S22 * GAMMAL) * (1 - GAMMAIN * GAMMAS))
%
%   Here, VS is the source voltage, ZS is the source impedance, and VL is
%   the output voltage over load impedance ZL. 
%
%     OPTION = 3: the power wave transfer function 
%     TF3 = BP2/AP1 = SQRT(RS*RL) * S21 * (1 + GAMMAL) * (1 - GAMMAS) /
%          ((1 - S22 * GAMMAL) * (1 - GAMMAIN * GAMMAS) * ZL)
%
%   BP2 is the transmitted power wave at the 2nd port and AP1 is the
%   incident power wave to the 1st port, defined by
%
%     BP2 = SQRT(RL)/ZL * VL; AP1 = VS/(2*SQRT(RS))
%
%   and RL = real(ZL), RS = real(ZS).
%
%   The reflection coefficients are defined as:
%
%     GAMMAIN = S11 + (S12 * S21 * GAMMAL)/(1 - S22 * GAMMAL)
%     GAMMAL  = (ZL - Z0)/(ZL + Z0) 
%     GAMMAS  = (ZS - Z0)/(ZS + Z0)
%
%   Z0 is the reference impedance of S-parameters. The default is 50 ohms.
%   The default values of ZS and ZL are also 50 ohms. The default value of
%   OPTION is 1.
%
%   Reference: Guillermo Gonzalez, Microwave Transistor Amplifiers:
%   Analysis and Design, 2nd edition, Prentice Hall, 1996 
%
%   See also POWERGAIN, RATIONALFIT, SNP2SMP, GAMMAIN, GAMMAOUT, sparameters

%   Copyright 2005-2015 The MathWorks, Inc.

narginchk(1,5)

% Check the input S-parameters
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{},'s2tf','',1)
end
nfreq = CheckNetworkData(s_params,2,'S_PARAMS');

% Get and check the reference impedance
if nargin < 2
    z0 = 50;
else
    z0 = varargin{1};
end
z0 = CheckZ(z0,nfreq,'Z0');

% Get and check the source impedance
if nargin < 3
    zs = 50*ones(1,1,nfreq);
else
    zs = CheckZ(varargin{2},nfreq,'ZS');
end

% Get and check the load impedance
if nargin < 4
    zl = 50*ones(1,1,nfreq);
else
    zl = CheckZ(varargin{3},nfreq,'ZL');
end

% Get and check the option
if nargin < 5
    option = 1;
else
    option = varargin{4};
    validateattributes(option,{'numeric'},{'real','integer'}, ...
        's2tf','option')
    if (option ~= 1) && (option ~= 2) && (option ~= 3)
        error(message('rf:s2tf:WrongOption'))
    end
end

% Calculate the transfer function
gammaL = z2gamma(zl,z0);
gammaS = z2gamma(zs,z0);
gammaIn = s_params(1,1,:) + s_params(1,2,:) .* s_params(2,1,:) .* ...
    gammaL ./ (1 - s_params(2,2,:) .* gammaL);
tf = s_params(2,1,:) .* (1 + gammaL) .* (1 - gammaS) ./ ...
    (1 - s_params(2,2,:) .* gammaL) ./ (1 - gammaIn .* gammaS) / 2;

% Handle the different definition
if option == 1 
    factor = (zs+conj(zs)) ./ conj(zs);
    factor(isnan(factor)) = 2;
    tf =  tf .* factor;
elseif option == 3 
    factor = 2*sqrt(real(zs) .* real(zl)) ./ zl;
    factor(isnan(factor)) = 2;
    tf =  tf .* factor;
end
tf =  tf(:);