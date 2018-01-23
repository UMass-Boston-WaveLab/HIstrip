function out = getop(h)
%GETOP Get operating conditions.
%   GETOP(H) displays the selected operating conditions for the data
%   object, h.
%
%   See also RFCKT, RFCKT.RFCKT/SETOP

%   Copyright 2006-2009 The MathWorks, Inc.

narginchk(1, 1)

out = {};
if isa(h.AnalyzedResult, 'rfdata.data')
    out = getop(h.AnalyzedResult);  
end