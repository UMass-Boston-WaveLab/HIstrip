% Function ensures thru, line, and DUT matrices are all the same size.
% Ensures all matrices have the same depth.

function [depth] = validateSizes(thruT, lineT, dutT, reflectS)

% Get the depth of each matrix.
[~, ~, thruDepth] = size(thruT);
[~, ~, lineDepth] = size(lineT);
[~, ~, dutDepth] = size(dutT);
[~, ~, reflectDepth] = size(reflectS);

% Throw an error if depth (number of frequency points) is not equal.
if thruDepth == lineDepth & thruDepth == dutDepth ...
        & thruDepth == reflectDepth
    depth = thruDepth;
else
    error('Matrices do not have same number of frequency data points.');
end

% Check that thru, line, and DUT all have the exact same size.
if size(thruT) ~= size(lineT) | size(thruT) ~= size(dutT)
    error('Thru, line, or DUT data not the same size.');
end
