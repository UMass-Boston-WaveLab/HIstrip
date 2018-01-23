function checkproperty(h, for_constructor)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.MIXER

%   Copyright 2003-2009 The MathWorks, Inc.

if nargin < 2
    for_constructor = false;
end

% Check the properties
data = h.AnalyzedResult;
if isempty(data) && for_constructor
    return
end

refobj = getreference(data);
if hasreference(data)
    set(refobj, 'Block', 'h.Block')
    checkproperty(refobj);
end
setnport(h, getnport(data));
if h.nPort ~= 2
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:mixer:checkproperty:TwoPortDataOnly',       ...
        rferrhole));
end

setflagindexes(h);
% Set the flag for nonlinear
if isa(h.PowerData, 'rfdata.power') || (h.IIP3 ~= inf) ||               ...
        (h.OIP3 ~= inf) ||                                              ...
        (isa(h.IP3Data, 'rfdata.ip3') && any(h.IP3Data.Data ~= inf)) || ...
        (isa(data, 'rfdata.data') && hasp2dreference(data))
    updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
elseif isa(refobj, 'rfdata.reference') && ~isempty(refobj.OIP3) &&      ...
        any(isfinite(refobj.OIP3))
    updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
elseif isa(refobj, 'rfdata.reference') && ~isempty(refobj.IIP3) &&      ...
        any(isfinite(refobj.IIP3))
    updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
elseif isa(refobj, 'rfdata.reference') && ~isempty(refobj.OneDBC) &&    ...
        any(isfinite(refobj.OneDBC))
    updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
elseif isa(refobj, 'rfdata.reference') && ~isempty(refobj.PS) &&        ...
        any(isfinite(refobj.PS))
    updateflag(h, indexOfNonLinear, 1, MaxNumberOfFlags);
else
    updateflag(h, indexOfNonLinear, 0, MaxNumberOfFlags);
end

freqoffset = h.FreqOffset;
phasenoiselevel = h.PhaseNoiseLevel;
data = get(h, 'AnalyzedResult');
if ~isempty(freqoffset) && ~isempty(phasenoiselevel)
    if (length(phasenoiselevel) ~= length(freqoffset))
        rferrhole = '';
        if isempty(h.Block)
            rferrhole = [h.Name, ': '];
        end
        error(message('rf:rfckt:mixer:checkproperty:WrongPhaseNoise',   ...
            rferrhole));
    end
    [freqoffset, findex] = sort(freqoffset);
    phasenoiselevel(:) = phasenoiselevel(findex);
    n = length(freqoffset);
    set(data, 'FreqOffset', [0.5 * freqoffset(1) freqoffset(1:n)' 1.5 * ...
        freqoffset(n)], 'PhaseNoiseLevel',                              ...
        [phasenoiselevel(1) phasenoiselevel(1:n)' phasenoiselevel(n)]);
else
    set(data, 'FreqOffset', [], 'PhaseNoiseLevel', []);
end