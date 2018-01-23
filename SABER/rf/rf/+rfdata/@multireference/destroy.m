function h = destroy(h, destroyData)
%DESTROY Destroy this object
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

% Delete objects associated with this object
nReferences = numel(h.References);
for ii = 1:nReferences
    if isa(h.References{ii},'rfdata.reference')
        delete(h.References{ii});
    end
end