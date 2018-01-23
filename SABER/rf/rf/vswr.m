function result = vswr(gamma)
%VSWR Calculates the VSWR at the given reflection coefficient gamma
%   RESULT = VSWR(GAMMA) calculates the VSWR at the given reflection
%   coefficient gamma by
%
%       VSWR = (1+abs(GAMMA))./(1-abs(GAMMA))
%
%   GAMMA is the given reflection coefficient gamma. 
% 
%   See also GAMMAIN, GAMMAOUT, GAMMAMS, GAMMAML

%   Copyright 2003-2015 The MathWorks, Inc.
%   $Revision.1 $  

narginchk(1,1)

% Validate gamma
switch ndims(gamma) % Note that ndims is always >= 2
    case 2
        validateattributes(gamma,{'numeric'}, ...
            {'nonempty','vector','nonnan'},'vswr','GAMMA')
    case 3
        validateattributes(gamma,{'numeric'}, ...
            {'nonempty','size',[1 1 NaN],'nonnan'},'vswr','GAMMA')
    otherwise
        validateattributes(gamma,{'numeric'}, ...
            {'nonempty','size',[NaN NaN NaN 1]},'vswr','GAMMA')
end

% Calculate the VSWR
result = (1+abs(gamma))./(1-abs(gamma));
