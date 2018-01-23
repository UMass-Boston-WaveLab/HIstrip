function [mu,muprime] = stabilitymu(s_params)
%STABILITYMU Calculates the stability factor MU of a 2-port network 
%   [MU,MUPRIME] = STABILITYMU(S_PARAMS) the stability factor MU and MU
%   prime, of a two port network by 
%
%       MU = (1 - |S11|^2) / (|S22 - CONJ(S11) * DELTA| + |S21*S12|)
%       MUPRIME = (1 - |S22|^2) / (|S11 - CONJ(S22) * DELTA| + |S21*S12|)
%       where DELTA = S11*S22 - S12*S21
%
%   S_PARAMS must be either a 2x2xK numeric array of K 2-port S-parameters,
%   or a 2-port sparameters objects.
%
%   MU defines the minimum distance between the center of the unit Smith
%   chart and the unstable region in the load plane (the load is considered
%   port 2). 
%
%   MUPRIME defines the minimum distance between the center of the unit
%   Smith chart and the unstable region in the source plane (the source is
%   considered port 1).
%
%   Having MU>1 (or MUPRIME>1) is necessary and sufficient for the 2-port
%   linear network, described by the S-parameters, to be unconditionally
%   stable.
%
%   Reference: Marion Lee Edwards and Jeffrey H. Sinsky, A New Criterion
%   for Linear 2-Port Stability Using a Single Geometrically Derived
%   Parameter, IEEE Trans. Microwave Theory Tech., Vol. MTT-40, no. 12, pp.
%   2303-2311, December 1992.
%
%   See also STABILITYK, GAMMAMS, GAMMAML, sparameters

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(1,1)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'stabilitymu','S-Parameters',1)
end
CheckNetworkData(s_params,2,'S_PARAMS');

% Get the S-parameters
[s11,s12,s21,s22] = deal(s_params(1,1,:),s_params(1,2,:), ...
    s_params(2,1,:),s_params(2,2,:));

% Calculate stability MU and MUPRIME
abss11s11 = abs(s11 .* s11);
abss21s12 = abs(s21 .* s12);
abss22s22 = abs(s22 .* s22);
delta = s11 .* s22 - s12 .* s21;
mu = (1 - abss11s11) ./ (abs(s22 - conj(s11) .* delta) + abss21s12);
muprime = (1 - abss22s22) ./ (abs(s11 - conj(s22) .* delta) + abss21s12);
mu = mu(:);
muprime = muprime(:);