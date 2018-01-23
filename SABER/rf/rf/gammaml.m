function result = gammaml(s_params)
%GAMMAML Calculate GammaML from 2-port S-parameters
%   RESULT = GAMMAML(S_PARAMS) calculates the load reflection coefficient
%   of a 2-port network required for a simultaneous conjugate match by
%
%       GAMMAML = (B2 +/- SQRT(B2^2 - 4 * |C2|^2)) / (2 * C2)
% 
%   where
% 
%       B2 = 1 - |S11|^2 + |S22|^2 - |DELTA|^2
%       C2 = S22 - DELTA * CONJ(S11)
%       DELTA = S11*S22 - S12*S21
% 
%   S_PARAMS is either a complex 2x2xK array of K 2-port S-parameters, or a
%   2-port sparameters object.
%
%   See also GAMMAMS, STABILITYK, GAMMAIN, GAMMAOUT, sparameters

%   Copyright 2007-2015 The MathWorks, Inc.

narginchk(1,1)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'gammaml','S-Parameters',1)
end
nfreq = CheckNetworkData(s_params, 2, 'S_PARAMS');

% Calculate K, B2, Delta and C2
[~,~,B2,Delta] = stabilityk(s_params);
C2 = squeeze(s_params(2,2,:)) - Delta.*conj(squeeze(s_params(1,1,:)));

% Set the default
result = NaN(nfreq,1);

% Calculate GammaML by using minus sign
idx = (abs(B2./C2/2) > 1) & (B2 > 0);
result(idx)=(B2(idx)-sqrt(B2(idx).^2-4*abs(C2(idx)).^2))./C2(idx)./ 2; 
% Calculate GammaML by using plus sign
idx = (abs(B2./C2/2) > 1) & (B2 < 0);
result(idx)=(B2(idx)+sqrt(B2(idx).^2-4*abs(C2(idx)).^2))./C2(idx)./ 2; 