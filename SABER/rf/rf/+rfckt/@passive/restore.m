function h = restore(h)
%RESTORE Restore the data to the original frequencies for plot.
%   H = RESTORE(H) restores the data to the original frequencies of
%   NetworkData for plot. 
%
%   See also RFCKT.PASSIVE, RFCKT.PASSIVE/ANALYZE, RFCKT.PASSIVE/READ

%   Copyright 2003-2009 The MathWorks, Inc.

data = h.AnalyzedResult;
if isa(data, 'rfdata.data')
    restore(data);
    if all(data.NF == 0) && ~isempty(data.Freq)
        analyze(h, data.Freq, data.Z0, data.Z0, data.Z0);
    end
end