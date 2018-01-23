function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.CPW

%   Copyright 2003-2007 The MathWorks, Inc.

% Check the properties
conductorwidth = get(h, 'ConductorWidth');
slotwidth = get(h, 'SlotWidth');
height = get(h, 'Height');
thickness = get(h, 'Thickness');
% To ensure accuracy, check dimension limit of the cpw

rferrhole = '';
if isempty(h.Block)
    rferrhole = [h.Name, ': '];
end

if (slotwidth/height > 20) || (slotwidth/height < 0.05)
    error(message('rf:rfckt:cpw:checkproperty:SlotWidthHeightLimit',    ...
        rferrhole));
end

if (conductorwidth/slotwidth > 100) || (conductorwidth/slotwidth < 0.01)
    error(message(['rf:rfckt:cpw:checkproperty:'                        ...
        'ConductorwidthSlotwidthLimit'], rferrhole));
end

if (thickness/slotwidth > 0.1)
    error(message('rf:rfckt:cpw:checkproperty:ThicknessSlotwidthLimit', ...
        rferrhole));
end

if (thickness/conductorwidth > 0.1)
    error(message(['rf:rfckt:cpw:checkproperty:'                        ...
        'ThicknessConductorwidthLimit'], rferrhole));
end

checkstubmode(h);