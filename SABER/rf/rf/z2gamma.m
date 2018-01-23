function gamma = z2gamma(z,z0)
%Z2GAMMA Convert impedance to reflection coefficient
%   GAMMA = Z2GAMMA(Z,Z0) converts the impedance Z to the reflection
%   coefficient GAMMA by 
%
%       GAMMA = (Z - Z0)/(Z + Z0)
%
%   Z is the specified impedance. Z0 is the reference impedance. The
%   default is 50 ohms.
% 
%   See also GAMMA2Z, GAMMAIN, GAMMAOUT

%   Copyright 2007-2015 The MathWorks, Inc.

narginchk(1,2)

% Check Z
m = numel(z);
CheckZ(z,m,'Z',0);

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,m);
else
    z0 = CheckZ(z0,m,'Z0',4);
end
z0 = reshape(z0,size(z));

% Calculate GAMMA
gamma = (z - z0) ./ (z + z0);

% Check for infinite values of z
gamma(z == inf) = 1; 