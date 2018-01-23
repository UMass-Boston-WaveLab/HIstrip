function [z0_1, z0_2] = findimpedance(h, z0_1, z0_2)
%FINDIMPEDANCE Find reference impedance.
%   [Z0_1, Z0_2] = FINDIMPEDANCE (H, Z0_1, Z0_2) find reference impedance.
%
%   See also RFDATA.REFERENCE

%   Copyright 2009 The MathWorks, Inc.

if isa(h.NetworkData, 'rfdata.network') && strncmpi(h.NetworkData.Type, 'S', 1)
    if ~isempty(h.File)
        n = length(z0_1);
        z0_1(n+1) = h.NetworkData.Z0;
    else
        n = length(z0_2);
        z0_2(n+1) = h.NetworkData.Z0;
    end
end
