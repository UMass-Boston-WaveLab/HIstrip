function [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,   ...
    deltafreq_left, deltafreq_right, userspecified)
%REFINEDELTAFREQ Refine the delta frequencies.
%   [DELTAFREQ_LEFT, DELTAFREQ_RIGHT] = REFINEDELTAFREQ(H, FREQ,
%   DELTAFREQ_LEFT, DELTAFREQ_RIGHT, USERSPECIFIED) refines the delta
%   frequencies for group delay analysis.
%
%   See also RFDATA.DATA

%   Copyright 2007 The MathWorks, Inc.

if userspecified
    return;
end

% Get the original frequencies
original_freq = [];
refobj = getreference(h);
if hasreference(h)
    netobj = get(refobj, 'NetworkData');
    if isa(netobj, 'rfdata.network')
        original_freq = get(netobj, 'Freq');
    end
end
if isempty(original_freq)
    original_freq = get(h, 'Freq');
end

% Refine the delta frequencies
noriginal_freq = length(original_freq);
if noriginal_freq > 1
    diff_original_freq = diff(original_freq);
    original_deltafreq = zeros(noriginal_freq,1);
    original_deltafreq(1) = diff_original_freq(1);
    original_deltafreq(noriginal_freq) =                                ...
        diff_original_freq(noriginal_freq-1);
    for k=2:noriginal_freq-1
        original_deltafreq(k,1) = min(diff_original_freq(k-1),          ...
            diff_original_freq(k)); 
    end    
    delta1 = interpolate(h, original_freq, original_deltafreq, freq);   
    idx = abs(deltafreq_right) > abs(delta1);
    deltafreq_right(idx) = delta1(idx);
    idx = (deltafreq_left == 0);
    deltafreq_left = deltafreq_right;  
    deltafreq_left(idx) = 0;  
end