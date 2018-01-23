function y = hasreference(h)
%HASREFERENCE check if data has reference.
%   Y = HASREFERENCE(H) returns true if data has reference and false
%   otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

refobj = h.Reference;
if isa(refobj, 'rfdata.reference') || isa(refobj, 'rfdata.multireference')
    y = true;
else
    y = false;
end