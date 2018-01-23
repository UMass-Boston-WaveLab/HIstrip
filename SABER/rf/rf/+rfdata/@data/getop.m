function out = getop(h)
%GETOP Get operating conditions.
%   GETOP(H) displays the selected operating conditions for the data
%   object, h.
%
%   See also RFDATA.DATA, RFDATA.DATA/SETOP

%   Copyright 2006-2007 The MathWorks, Inc.

narginchk(1, 1)

out = {};
if hasmultireference(h)
    temp = listop(h.Reference, 'Current');
    out = temp{1};
end