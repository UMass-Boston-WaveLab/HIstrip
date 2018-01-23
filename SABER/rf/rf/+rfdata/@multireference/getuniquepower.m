function power = getuniquepower(h, datatype, ptype)
% Return unique power points.
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

power = [];
if nargin < 3
    ptype = 'PIN';
end
nReferences = numel(h.References);
switch upper(datatype)
    case 'P2D'
        for ii = 1:nReferences
            tempref = h.References{ii};
            if isa(tempref.P2DData, 'rfdata.p2d')
                switch ptype
                    case 'PIN'
                        temppower = tempref.P2DData.P1;
                    otherwise % POUT
                        temppower = tempref.P2DData.P2;
                end
                power = unique(cat(1, temppower{:}, power));
            end
        end

    case 'POWER'
        for ii = 1:nReferences
            tempref = h.References{ii};
            if isa(tempref.PowerData, 'rfdata.power')
                switch ptype
                    case 'PIN'
                        temppower = tempref.PowerData.Pin;
                    otherwise % POUT
                        temppower = tempref.PowerData.Pout;
                end
                power = unique(cat(1, temppower{:}, power));
            end
        end

end