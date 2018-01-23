function [z0_1, z0_2] = findimpedance(h, z0_1, z0_2)
%FINDIMPEDANCE Find reference impedance.
%   [Z0_1, Z0_2] = FINDIMPEDANCE (H, Z0_1, Z0_2) find reference impedance.
%
%   See also RFCKT.PASSIVE

%   Copyright 2009 The MathWorks, Inc.

data = h.AnalyzedResult;
if isa(data, 'rfdata.data')
    [z0_1, z0_2] = findimpedance(data, z0_1, z0_2);
end