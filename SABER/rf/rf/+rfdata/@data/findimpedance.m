function [z0_1, z0_2] = findimpedance(h, z0_1, z0_2)
%FINDIMPEDANCE Find reference impedance.
%   [Z0_1, Z0_2] = FINDIMPEDANCE (H, Z0_1, Z0_2) find reference impedance.
%
%   See also RFDATA.DATA

%   Copyright 2009 The MathWorks, Inc.

rfobj = getreference(h);
if isa(rfobj, 'rfdata.reference')
    [z0_1, z0_2] = findimpedance(rfobj, z0_1, z0_2);
end