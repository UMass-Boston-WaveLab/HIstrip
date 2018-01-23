function z = gamma2z(gamma,z0)
%GAMMA2Z Convert reflection coefficient to impedance
%   Z = GAMMA2Z(GAMMA,Z0) converts the reflection coefficient GAMMA to the
%   impedance Z by 
%
%       Z = Z0 * (1+GAMMA)/(1-GAMMA)
%
%   GAMMA is the specified reflection coefficient gamma. Z0 is the
%   reference impedance, the default is 50 ohms.
% 
%   See also Z2GAMMA, GAMMAIN, GAMMAOUT

%   Copyright 2003-2015 The MathWorks, Inc.
%   $Revision.1 $  

narginchk(1,2)

% Must be numeric
if ~isnumeric(gamma)   
    error(message('rf:gamma2z:GAMMANotNumeric'))
end
% NaN is not allowed
if ~isnumeric(gamma)   
    error(message('rf:gamma2z:GAMMAIsNaN'))
end
[d1,d2,d3,d4] = size(gamma);

% Must be a scalar or vector, i.e., if more than one dimension is not equal
% to one, or more than three dimensions, then throw an error
if ~((d1==1)&&(d2==1) || (d1==1)&&(d3==1) || (d2==1)&&(d3==1)) || (d4~=1)
    error(message('rf:gamma2z:GAMMAWrongInput'))
end
m = numel(gamma);

% Check the reference impedance
if nargin < 2
    z0 = 50*ones(1,1,m);
else
    z0 = CheckZ(z0,m,'Z0',3);
end
z0 = reshape(z0,d1,d2,d3); % We know d4 = 1

% Calculate Z
z = z0.*(1+gamma)./(1-gamma);