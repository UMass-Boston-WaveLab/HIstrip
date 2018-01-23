function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.MICROSTRIP

%   Copyright 2003-2007 The MathWorks, Inc.

% Check the properties
width = get(h, 'Width');
height = get(h, 'Height');
thickness = get(h, 'Thickness');

% To ensure accuracy, check dimension limit of the microstrip
if (width/height > 20) || (width/height < 0.05)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:microstrip:checkproperty:WidthHeightLimit', ...
        rferrhole));
end

if (thickness/height > 0.1)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message(['rf:rfckt:microstrip:checkproperty:'                 ...
        'ThicknessHeightLimit'], rferrhole));
end

checkstubmode(h);