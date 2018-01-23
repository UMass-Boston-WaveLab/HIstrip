function list = listxformat(h, parameter)
%XLISTFORMAT List the valid formats for the specified PARAMETER.
%   LIST = LISTFORMAT(H, PARAMETER) lists the valid formats for the
%   specified PARAMETER.
%    
%   Type LISTPARAM(H) to get the valid parameters of the RFDATA.DATA object.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Set the default
list = {};

if nargin == 1
    list =  {'Auto' 'Hz' 'KHz' 'MHz' 'GHz' 'THz' 'dBm' 'dBW' 'W' 'mW' ...
        'dB' 'Magnitude (decibels)' 'Mag' 'Magnitude (linear)' 'None'};
else    
    dcategory = xcategory(h, parameter);
    % Check the data to find its category
    switch upper(dcategory)
        case {'FREQUENCY'}
            list = {'Auto' 'Hz' 'KHz' 'MHz' 'GHz' 'THz'};
        case {'INPUT POWER'}
            list = {'dBm' 'dBW' 'W' 'mW'};
        case {'OPERATING CONDITION'}
            list = {'None'};
        case {'AM'}
            list = {'dB' 'Magnitude (decibels)' 'Mag' 'Magnitude (linear)' 'None'};
    end
end

list = list';