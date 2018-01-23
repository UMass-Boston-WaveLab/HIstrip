function y = hasip3reference(h)
%HASIP3REFERENCE check if ip3 has reference.
%   Y = HASIP3REFERENCE(H) returns true if ip3 has reference and false
%   otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

if ~hasreference(h) % check if any reference exists at all
    y = false;
    return
end

refobj = getreference(h);
if isa(refobj.IP3Data, 'rfdata.ip3')
    y = true;
else
    y = false;
end