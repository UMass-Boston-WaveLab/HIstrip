function result = gammaout(s_params,varargin)
%GAMMAOUT Calculates the output reflection coefficient of a two port network
%   RESULT = GAMMAOUT(S_PARAMS, Z0, ZS) calculates the output reflection
%   coefficient of a two port network, where S_PARAMS is a complex 2x2xK
%   array of K 2-port S-parameters. Z0 is the reference impedance, the
%   default is 50 ohms. ZS is the source impedance, the default is 50 ohms.
%
%   RESULT = GAMMAOUT(S_OBJ, ZS) calculates the output reflection
%   coefficient of a two port network, where S_OBJ is an sparameters
%   object.  ZS is the source impedance, the default is 50 ohms.
%
%   GAMMAOUT uses the equation:
%
%       GammaOut = s22 + (S12 * S21) * GammaS / (1 - S11 * GammaS)
%       where GammaS =  (ZS - Z0)/(ZS + Z0)
% 
%   See also GAMMAIN, S2TF, POWERGAIN, Z2GAMMA, VSWR, GAMMAMS, GAMMAML, sparameters

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(1,3)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'gammaout','S-Parameters',1)
end
nfreq = CheckNetworkData(s_params,2,'S_PARAMS');

if nargin < 2
    z0 = 50*ones(1,1,nfreq);
else
    z0 = CheckZ(varargin{1},nfreq,'Z0');
end

if nargin < 3
    zs = 50*ones(1,1,nfreq);
else
    zs = CheckZ(varargin{2},nfreq,'ZL');
end
 
% Get the S-parameters
[s11,s12,s21,s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the GAMMAOUT
gammaS = z2gamma(zs,z0);
result = s22 + ((s12 .* s21) .* gammaS) ./ (1 - s11 .* gammaS);
result = result(:);