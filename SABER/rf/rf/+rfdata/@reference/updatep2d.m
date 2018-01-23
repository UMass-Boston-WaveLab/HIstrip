function h = updatep2d(h, freq, p1, p2, data)
%UPDATEP2D Update the P2DData with the inputs.
%
%   See also RFDATA.REFERENCE

%   Copyright 2005-2007 The MathWorks, Inc.

% Get the properties
p2ddata = get(h, 'P2DData');

% Update the properties
if ~isempty(p1) && ~isempty(p2) && ~isempty(data)
    if isa(p2ddata, 'rfdata.p2d')
        set(p2ddata, 'Freq', freq, 'P1', p1, 'P2', p2, 'Data', data);
    else
        p2ddata = rfdata.p2d('Freq', freq, 'P1', p1, 'P2', p2,          ...
            'Data', data);
        set(h, 'P2DData', p2ddata);
    end
else
    set(h, 'P2DData', []);
end