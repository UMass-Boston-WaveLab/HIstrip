function [zl, zs, z0] = sortimpedance(h, freq, zlin, zsin, z0in)
%SORTIMPEDANCE Sort the impedance.
%
%   See also RFDATA.DATA

%   Copyright 2007 The MathWorks, Inc.

if isscalar(zlin)  
    zl = zlin;
else
    zl = sortwithfreq(zlin, freq(:));
end
if isscalar(zsin)
    zs = zsin;
else
    zs = sortwithfreq(zsin, freq(:));
end
if isscalar(z0in)
    z0 = z0in;
else
    z0 = sortwithfreq(z0in, freq(:));
end


function result = sortwithfreq(z, freq)
[freq, freqindex] = sort(freq);
result = z(freqindex);
result = result(:);