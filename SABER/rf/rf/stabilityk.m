function [k,b1,b2,delta] = stabilityk(s_params)
%STABILITYK Calculates the stability factor K of a 2-port network
%   [K, B1, B2, DELTA] = STABILITYK(S_PARAMS) the stability factor K, as
%   well as the conditions B1, B2, and DELTA of a 2-port network by
%
%       K = (1 - |S11|^2 - |S22|^2 + |DELTA|^2) / (2*|S12*S21|)
%       B1 = 1 + |S11|^2 - |S22|^2 - |DELTA|^2
%       B2 = 1 - |S11|^2 + |S22|^2 - |DELTA|^2
%       DELTA = S11*S22 - S12*S21
%
%   Necessary and sufficient conditions for stability are K>1 and |DELTA|<1.
%
%   S_PARAMS is either a complex 2x2xM array of M 2-port S-parameters, or
%   a 2-port sparameters object.
%
%   Reference: Guillermo Gonzalez, Microwave Transistor Amplifiers:
%   Analysis and Design, 2nd ed., Prentice Hall, 1997, pp. 217-228.
%
%   See also STABILITYMU, GAMMAMS, GAMMAML, sparameters

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(1,1)

% Check input s_params
if ~isnumeric(s_params)
    validateattributes(s_params,{'numeric','sparameters'},{}, ...
        'stabilityk','S-Parameters',1)
end
CheckNetworkData(s_params,2,'S_PARAMS');

% Get the S-parameters
[s11,s12,s21,s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate delta, B1, B2 and K
abss11s11 = abs(s11 .* s11);
abss12s21 = abs(s12 .* s21);
abss22s22 = abs(s22 .* s22);
delta = s11 .* s22 - s12 .* s21;
absdeltadelta = abs(delta .* delta);
k = (1 - abss11s11 - abss22s22 + absdeltadelta) ./ abss12s21 /2;
b1 = 1 + abss11s11 - abss22s22 - absdeltadelta;
b2 = 1 - abss11s11 + abss22s22 - absdeltadelta;
k = k(:);
b1 = b1(:);
b2 = b2(:);
delta = delta(:);