function h = updatemixerspur(h, ploref, pinref, data)
%UPDATEMIXERSPUR Update the MixerSpurData with the inputs.
%
%   See also RFDATA.REFERENCE

%   Copyright 2006-2007 The MathWorks, Inc.

% Get the properties
mixerspurdata = get(h, 'MixerSpurData');

% Update the properties
if ~isempty(ploref) && ~isempty(pinref) && ~isempty(data)
    if isa(mixerspurdata, 'rfdata.mixerspur')
        set(mixerspurdata, 'PLORef', ploref, 'PinRef', pinref, 'Data', data);
    else
        mixerspurdata = rfdata.mixerspur('PLORef', ploref, 'PinRef', ...
            pinref, 'Data', data);
        set(h, 'MixerSpurData', mixerspurdata);
    end
else
    set(h, 'MixerSpurData', []);
end