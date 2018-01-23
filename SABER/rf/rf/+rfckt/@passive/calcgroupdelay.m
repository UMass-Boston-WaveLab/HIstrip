function gd = calcgroupdelay(h, freq, z0, aperture)
%CALCGROUPDELAY Calculate the group delay.
%   GD = CALCGROUPDELAY(H, FREQ, Z0, APERTURE) calculates the group delay
%   for two port.
%
%   See also RFCKT.PASSIVE

%   Copyright 2007 The MathWorks, Inc.

% Get the RFDATA.DATA object 
data = get(h, 'AnalyzedResult');

% Calculate the group delay
gd = calcgroupdelay(data, freq, z0, aperture);