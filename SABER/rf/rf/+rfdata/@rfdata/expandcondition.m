function conditions = expandcondition(h, conditions)
%EXPANDCONDITION Expand vector condition values into multiple conditions.
%
%   See also RFDATA

%   Copyright 2006-2009 The MathWorks, Inc.

% Make sure numeric conditions have numeric value
if isempty(conditions) || ~hasmultireference(h)
    return
end

idx = [];
value = {};
tempops = getnumericvars(h.Reference);
nconditions = numel(conditions);
for ii = 1:2:nconditions-1
    if any(strcmpi(conditions{ii}, tempops)) %Numeric conditions
        if isnumeric(conditions{ii+1}) && isvector(conditions{ii+1})    ...
                && numel(conditions{ii+1}) > 1
            idx = [idx, ii+1];
            temp = conditions{ii+1};
            value{end+1} = temp(:);
        end
    end
end

if isempty(idx)
    return
end

% Expand vector
mymat = value{end};
nvalue = numel(value);
for ii = nvalue-1:-1:1
    mymat = myexpand(value{ii}, mymat);
end

numExpansions = size(mymat, 1);
conditions = repmat(conditions, numExpansions, 1);
nidx = numel(idx);
for ii = 1:nidx
    conditions(:, idx(ii)) = mat2cell(mymat(:, ii),                     ...
        ones(1, numExpansions), 1);
end

%---------------------------
function c = myexpand(a, b)
% Expand vector a and matrix b into a bigger matrix c.
num_a = numel(a);
num_b = size(b, 1);
if isvector(b)
    b = b(:);
end
new_b = repmat(b, num_a, 1);
a = a(:).';
new_a = repmat(a, num_b, 1);
new_a = new_a(:);
c = [new_a, new_b];