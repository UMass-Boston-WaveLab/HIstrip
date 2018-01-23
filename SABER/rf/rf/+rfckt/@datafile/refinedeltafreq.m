function [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,   ...
    deltafreq_left, deltafreq_right, userspecified)
%REFINEDELTAFREQ Refine the delta frequencies.
%   [DELTAFREQ_LEFT, DELTAFREQ_RIGHT] = REFINEDELTAFREQ(H, FREQ,
%   DELTAFREQ_LEFT, DELTAFREQ_RIGHT, USERSPECIFIED) refines the delta
%   frequencies for group delay analysis.
%
%   See also RFCKT.DATAFILE

%   Copyright 2007 The MathWorks, Inc.

% Get the data object
data = get(h, 'AnalyzedResult');
if ~isa(data, 'rfdata.data')
    setrfdata(h, rfdata.data);
    data = get(h, 'AnalyzedResult');
end
% Refine the delta frequencies
[deltafreq_left, deltafreq_right] = refinedeltafreq(data, freq,         ...
    deltafreq_left, deltafreq_right, userspecified);