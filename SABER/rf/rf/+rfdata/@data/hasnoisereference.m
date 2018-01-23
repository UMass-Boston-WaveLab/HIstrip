function y = hasnoisereference(h)
%HASNOISEREFERENCE check if noise data has reference.
%   Y = HASNOISEREFERENCE(H) returns true if noise data has reference and
%   false otherwise.
%
%   See also RFDATA.DATA

%   Copyright 2006-2007 The MathWorks, Inc.

if ~hasreference(h) % check if any reference exists at all
    y = false;
    return
end

refobj = getreference(h);
if isa(refobj.NoiseData, 'rfdata.noise')
    y = true;
else
    y = false;
end