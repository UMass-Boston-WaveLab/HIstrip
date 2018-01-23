function values = getallvalues(h, condition)
%GETALLVALUES Return all recorded values for a given operating condition. 
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

narginchk(2, 2)

values = {};
numConditions = numel(h.IndependentVars);
for ii = 1:numConditions
    [loc, tempvalue] = hasvar(h, condition, ii);
    if loc
        values = {values{:}, tempvalue};
    end
end
values = values';
[values, m] = unique(values);
[dummy, idx] = sort(m);
values = values(idx);