function phasenoiselevel = phasenoise(h, freqoffset)
%PHASENOISE Calculate the phase noise.
%   PHASENOISELEVEL = PHASENOISE(H, FREQOFFSET) calculates the phase noise
%   of the mixer's data object at the specified frequencies offset
%   FREQOFFSET. The first input is the handle to the RFDATA.DATA object,
%   the second input is a vector for the specified frequency offset.
%
%   See also RFDATA.DATA

%   Copyright 2004-2009 The MathWorks, Inc.

phasenoiselevel = [];
% Get the data
original_freqoffset = h.FreqOffset;
original_phasenoiselevel = h.PhaseNoiseLevel;

% Calculate the phase noise level
if ~isempty(original_phasenoiselevel) && ~isempty(original_freqoffset)
    method = get(h, 'IntpType');
    set(h, 'IntpType', 'linear');
    phasenoiselevel = interpolate(h,                                    ...
        log10(original_freqoffset(2:end-1)),                            ...
        original_phasenoiselevel(2:end-1), log10(freqoffset));
    set(h, 'IntpType', method);
end