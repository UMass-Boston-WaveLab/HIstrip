function result = gammams(s_params)
%GAMMAMS Calculate GammaMS from 2-port S-parameters
%   RESULT = GAMMAMS(S_PARAMS) calculates the source reflection coefficient
%   of a 2-port network required for a simultaneous conjugate match by
%
%       GAMMAMS = (B1 +/- SQRT(B1^2 - 4 * |C1|^2)) / (2 * C1)
% 
%   where
% 
%       B1 = 1 + |S11|^2 - |S22|^2 - |DELTA|^2
%       C1 = S11 - DELTA * CONJ(S22)
%       DELTA = S11*S22 - S12*S21
%
%   S_PARAMS is either a complex 2x2xK array of K 2-port S-parameters, or a
%   2-port sparameters object.
%
%   See also GAMMAML, STABILITYK, GAMMAIN, GAMMAOUT, sparameters

%   Copyright 2007-2015 The MathWorks, Inc.

narginchk(1,1)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'gammams','S-Parameters',1)
end
nfreq = CheckNetworkData(s_params, 2, 'S_PARAMS');

% Calculate K, B1, Delta and C1
[~,B1,~,Delta] = stabilityk(s_params);
C1 = squeeze(s_params(1,1,:)) - Delta.*conj(squeeze(s_params(2,2,:)));

% Set the default
result = NaN(nfreq,1);

% Calculate GammaMS by using minus sign
idx = (abs(B1./C1/2) > 1) & (B1 > 0);
result(idx)=(B1(idx)-sqrt(B1(idx).^2-4*abs(C1(idx)).^2))./C1(idx)./ 2; 
% Calculate GammaMS by using plus sign
idx = (abs(B1./C1/2) > 1) & (B1 < 0);
result(idx)=(B1(idx)+sqrt(B1(idx).^2-4*abs(C1(idx)).^2))./C1(idx)./ 2; 