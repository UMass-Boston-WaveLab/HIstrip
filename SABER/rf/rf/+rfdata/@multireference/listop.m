function varargout = listop(h, varargin)
%LISTOP List operating conditions.
%   LISTOP(H) lists all recorded combinations of operating conditions.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

narginchk(1, 2)
error(nargoutchk(0, 1, nargout))
myvars = h.IndependentVars;
if numel(varargin) == 1
    if strcmpi(varargin{1}, 'Current')
        sel = h.Selection;
    else
        sel = varargin{1};
    end
else
    sel = 1:numel(myvars);
end

if ~(isnumeric(sel) && all(sel>0) && all(sel<=numel(myvars)))
    error(message('rf:rfdata:multireference:listop:SelOutofRange'))
end

if nargout==0
    nsel = numel(sel);
    for ii = 1:nsel
        disp(['Operating conditions set ', num2str(sel(ii)), ':'])
        disp(myvars{sel(ii)})
    end
else
    varargout{1} = myvars(sel);
end
