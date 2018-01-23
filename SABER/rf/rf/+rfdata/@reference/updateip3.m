function h = updateip3(h, type, freq, data)
%UPDATEIP3 Update the IP3Data with the inputs.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

% Get the properties
ip3data = get(h, 'IP3Data');

% Update the properties
if ~isempty(data)
    if isa(ip3data, 'rfdata.ip3')
        set(ip3data, 'Type', type, 'Freq', freq, 'Data', data);
    else
        ip3data = rfdata.ip3('Type', type, 'Freq', freq, 'Data', data);
        set(h, 'IP3Data', ip3data);
    end
else
    set(h, 'IP3Data', []);
end