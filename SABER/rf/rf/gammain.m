function result = gammain(s_params,varargin)
%GAMMAIN Calculates the input reflection coefficient of a 2-port network 
%   RESULT = GAMMAIN(S_PARAMS, Z0, ZL) calculates the input reflection
%   coefficient of a 2-port network, where S_PARAMS is a complex 2x2xK
%   array of K 2-port S-parameters. Z0 is the reference impedance, the
%   default is 50 ohms. ZL is the load impedance, the default is 50 ohms.
%
%   RESULT = GAMMAIN(S_OBJ, ZL) calculates the input reflection coefficient
%   of a 2-port network, where S_OBJ is an sparameters object.  ZL is the
%   load impedance, the default is 50 ohms.
%
%   GAMMAIN uses the formula:
%
%       GammaIn = S11 + (S12 * S21) * GammaL / (1 - S22 * GammaL);
%       where GammaL = (ZL - Z0)/(ZL + Z0)
% 
%   See also GAMMAOUT, Z2GAMMA, GAMMAMS, GAMMAML, sparameters

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(1,3)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'gammain','S-Parameters',1)
end
nfreq = CheckNetworkData(s_params,2,'S_PARAMS');

if nargin < 2
    z0 = 50*ones(1,1,nfreq);
else
    z0 = CheckZ(varargin{1},nfreq,'Z0');
end

if nargin < 3
    zl = 50*ones(1,1,nfreq);
else
    zl = CheckZ(varargin{2},nfreq,'ZL');
end
 
% Get the S-parameters
[s11,s12,s21,s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the GAMMAIN
gammaL = z2gamma(zl,z0);
result = s11 + ((s12 .* s21) .* gammaL) ./ (1 - s22 .* gammaL);
result = result(:);