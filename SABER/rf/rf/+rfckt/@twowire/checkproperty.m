function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.TWOWIRE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the property values that need to be checked
radius = get(h, 'Radius');
separation = get(h, 'Separation');

% 2*Radius must be smaller than Separation
if (2*radius) >= separation
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:twowire:checkproperty:RadiusSeparation',    ...
        rferrhole));
end
checkstubmode(h);