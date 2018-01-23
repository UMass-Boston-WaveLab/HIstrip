function [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,   ...
    deltafreq_left, deltafreq_right, userspecified)
%REFINEDELTAFREQ Refine the delta frequencies.
%   [DELTAFREQ_LEFT, DELTAFREQ_RIGHT] = REFINEDELTAFREQ(H, FREQ,
%   DELTAFREQ_LEFT, DELTAFREQ_RIGHT, USERSPECIFIED) refines the delta
%   frequencies for group delay analysis.
%
%   See also RFCKT.NETWORK

%   Copyright 2007 The MathWorks, Inc.

ckts = get(h, 'Ckts');
nckts = length(ckts);

% Refine the delta frequencies
for ii=1:nckts
    ckt = ckts{ii};
    [deltafreq_left, deltafreq_right] = refinedeltafreq(ckt, freq,      ...
        deltafreq_left, deltafreq_right, userspecified);
    freq = convertfreq(ckt, freq);
end