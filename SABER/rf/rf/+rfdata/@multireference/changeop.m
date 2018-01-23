function changeop(h, varargin)
%CHANGEOP Change operating conditions to match the input.
%   CHANGEOP(H,CONDITION1,VALUE1,CONDITION2,VALUE2,...) Changes operating
%   conditions to match the input condition and value pairs.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

if numel(varargin) == 1 && isnumeric(varargin{1}) &&                    ...
        ~isempty(varargin{1}) && varargin{1} <= numel(h.References) &&  ...
        varargin{1} > 0
    h.Selection = varargin{1};
    return
elseif numel(varargin) == 1
    error(message('rf:rfdata:multireference:changeop:SelOutofRange'));
end

currentop = listop(h, 'Current');
currentop = currentop{1};
allnames = currentop(:, 1);
idx = true(size(allnames));
ninputs = numel(varargin);
for ii = 1:2:ninputs
    idx(strcmpi(varargin{ii}, allnames)) = false;
end
addedops = currentop(idx, :).';
    
idx_left = select(h, varargin{:}, addedops{:});
allvars = h.IndependentVars;

if ~isempty(idx_left) && ~isequal(sort(idx_left), 1:numel(allvars))
    h.Selection = idx_left(1);
end