function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

% Check the properties
if numel(h.References) ~= numel(h.IndependentVars)
    error(message(['rf:rfdata:multireference:checkproperty:'            ...
        'RefVarNotMatch']));
end
nReferences = numel(h.References);
for ii = 1:nReferences
    checkproperty(h.References{ii});
end