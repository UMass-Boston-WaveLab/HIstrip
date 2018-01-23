function h = restore(h)
%RESTORE Restore the data to the original frequencies for plot.
%   H = RESTORE(H) restores the data to the original frequencies of
%   NetworkData for plot. 
%
%   See also RFCKT, RFCKT.RFCKT/ANALYZE, RFCKT.RFCKT/READ

%   Copyright 2003-2009 The MathWorks, Inc.

error(message('rf:rfckt:rfckt:restore:NotForThisObject', upper(class(h))));