function [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,   ...
    deltafreq_left, deltafreq_right, userspecified)
%REFINEDELTAFREQ Refine the delta frequencies.
%   [DELTAFREQ_LEFT, DELTAFREQ_RIGHT] = REFINEDELTAFREQ(H, FREQ,
%   DELTAFREQ_LEFT, DELTAFREQ_RIGHT, USERSPECIFIED) refines the delta
%   frequencies for group delay analysis.
%
%   See also RFCKT

%   Copyright 2007-2009 The MathWorks, Inc.
