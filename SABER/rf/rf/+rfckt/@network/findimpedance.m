function [z0_1, z0_2] = findimpedance(h, z0_1, z0_2)
%FINDIMPEDANCE Find reference impedance.
%   [Z0_1, Z0_2] = FINDIMPEDANCE (H, Z0_1, Z0_2) find reference impedance.
%
%   See also RFCKT.NETWORK

%   Copyright 2009 The MathWorks, Inc.

for k = 1:length(h.Ckts)
    [z0_1, z0_2] = findimpedance(h.Ckts{k}, z0_1, z0_2);
end