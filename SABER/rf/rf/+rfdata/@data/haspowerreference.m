function y = haspowerreference(h)
%HASPOWERREFERENCE check if data has pin-pout reference.
%   Y = HASIP3REFERENCE(H) returns true if data has pin-pout reference and
%   false otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

if ~hasreference(h) % check if any reference exists at all
    y = false;
    return
end

refobj = getreference(h);
if isa(refobj.PowerData, 'rfdata.power')
    y = true;
else
    y = false;
end