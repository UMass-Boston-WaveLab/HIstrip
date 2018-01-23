function h = restore(h)
%RESTORE Restore the data to the original frequencies for plot.
%   H = RESTORE(H) restores the data to the original frequencies of
%   NetworkData for plot. 
%
%   See also RFCKT.DATAFILE, RFCKT.DATAFILE/ANALYZE, RFCKT.DATAFILE/READ

%   Copyright 2003-2007 The MathWorks, Inc.

data = h.AnalyzedResult;
if isa(data, 'rfdata.data')
    restore(data);
end