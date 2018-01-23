function [pos, val] = hasvar(h, varname, selection)
%HASVAR Returns index if varname is one of the independent variable names
% of the selection.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

pos = false;
val = '';
if nargin < 2
    return
end
if nargin < 3
    selection = h.Selection;
end

temp = strcmpi(varname, h.IndependentVars{selection}(:,1));
if ~any(temp)
    return
end
pos = find(temp);
pos = pos(1);
val = h.IndependentVars{selection}{pos,2};