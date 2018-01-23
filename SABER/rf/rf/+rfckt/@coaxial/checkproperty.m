function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.COAXIAL

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the property values that need to be checked
a = get(h, 'InnerRadius');
b = get(h, 'OuterRadius');
 
% OuterRadius must be greater than the InnerRadius
if a >= b
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:coaxial:checkproperty:OuterInner', rferrhole));
end
checkstubmode(h);