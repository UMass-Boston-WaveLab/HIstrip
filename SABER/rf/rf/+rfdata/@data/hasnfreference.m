function y = hasnfreference(h)
%HASNFREFERENCE check if nf data has reference.
%   Y = HASNOISEREFERENCE(H) returns true if nf data has reference and
%   false otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

if ~hasreference(h) % check if any reference exists at all
    y = false;
    return
end

refobj = getreference(h);
if isa(refobj.NFData, 'rfdata.nf')
    y = true;
else
    y = false;
end