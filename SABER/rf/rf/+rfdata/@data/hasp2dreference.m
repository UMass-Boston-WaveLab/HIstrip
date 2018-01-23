function y = hasp2dreference(h)
%HASPOWERREFERENCE check if data has power-dependent sparameter reference.
%   Y = HASIP3REFERENCE(H) returns true if data has power-dependent
%   sparameter reference and false otherwis.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

if ~hasreference(h) % check if any reference exists at all
    y = false;
    return
end

refobj = getreference(h);
if isa(refobj.P2DData, 'rfdata.p2d')
    y = true;
else
    y = false;
end