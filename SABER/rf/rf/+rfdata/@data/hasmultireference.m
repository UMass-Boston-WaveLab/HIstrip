function y = hasmultireference(h)
%HASMULTIREFERENCE check if data has multiple references.
%   Y = HASREFERENCE(H) returns true if data has multiple references and
%   false otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

refobj = h.Reference;
if isa(refobj, 'rfdata.multireference')
    y = true;
else
    y = false;
end