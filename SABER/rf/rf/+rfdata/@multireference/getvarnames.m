function [names, values] = getvarnames(h)
%GETVARNAMES Return unique independent variable names and values.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

myvars = listop(h);
numvars = numel(myvars);
sel = h.Selection;

% Put all variable names in one cell and extract the unique ones.
tempvec = zeros(1, numvars);
for ii=1:numvars
    tempvec(ii) = size(myvars{ii}, 1);
end
num_names = sum(tempvec);
name_cell = cell(num_names, 1);
idx = 1;
for ii=1:numvars
    name_cell(idx:idx+tempvec(ii)-1, 1) = myvars{ii}(:,1);
    idx = idx+tempvec(ii);
end
name_cell = unique(name_cell);

% Order the unique variable names based on the order, in which they appear
% in the first set of variables.
[tempvars, m] = unique(myvars{sel}(:,1));
tempvalues = myvars{sel}(m,2);
[dummy, idx] = sort(m);
tempvars = tempvars(idx);
tempvalues = tempvalues(idx);
ntempvars = numel(tempvars);
for ii = 1:ntempvars
    name_cell = name_cell(~strcmp(tempvars{ii,1}, name_cell));
end

if isempty(name_cell)
    names = tempvars(:);
    values = tempvalues(:);
else
    names = {tempvars{:},name_cell{:}};
    names = names(:);
    tempcell = cell(numel(name_cell), 1);
    nname_cell = numel(name_cell);
    for ii = 1:nname_cell
        tempcell{ii} = '0';
    end
    values = {tempvalues{:},tempcell{:}};
    values = values(:);
end