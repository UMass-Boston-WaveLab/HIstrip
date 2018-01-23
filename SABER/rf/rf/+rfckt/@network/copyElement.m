function copyObj = copyElement(h)
%COPYELEMENT Override copyElement method:
%   Detailed explanation goes here for rfdata.data

%   Copyright 2011 The MathWorks, Inc.

    % Make a shallow copy of all properties
    copyObj = copyElement@matlab.mixin.Copyable(h);

    % Make a deep copy of all properties that reference a handle object.
    hmetainfo = metaclass(h);
    metaprops = {hmetainfo.PropertyList.Name};
    handleProps = metaprops(cellfun(@(x) isa(h.(x),'handle'), metaprops));
    for idx=1:length(handleProps)
        propName = handleProps{idx};
        copyObj.(propName) = copy(h.(propName));
    end
    if any(strcmp('Ckts',metaprops))
        set(copyObj,'Ckts',h.Ckts)
    end
end