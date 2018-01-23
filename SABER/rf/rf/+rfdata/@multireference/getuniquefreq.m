function freq = getuniquefreq(h, datatype)
% Return unique frequency points.
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

freq = [];
nReferences = numel(h.References);
switch upper(datatype)
    case 'P2D'
        for ii = 1:nReferences
            tempref = h.References{ii};
            if isa(tempref.P2DData, 'rfdata.p2d')
                tempfreq = tempref.P2DData.Freq;
                freq = unique(cat(1, tempfreq(:), freq));
            end
        end

    case 'POWER'
        for ii = 1:nReferences
            tempref = h.References{ii};
            if isa(tempref.PowerData, 'rfdata.power')
                tempfreq = tempref.PowerData.Freq;
                freq = unique(cat(1, tempfreq(:), freq));
            end
        end

end