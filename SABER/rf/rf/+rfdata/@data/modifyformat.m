function out = modifyformat(h, in, option)
%MODIFYFORMAT Modify the format
%
%   See also RFDATA.DATA

%   Copyright 2007-2008 The MathWorks, Inc.

if nargin < 3; option = 1; end;

switch option
case 1 % For legend and y axis
    switch upper(in)
    case {'DB' 'MAGNITUDE (DECIBELS)'}
        out = 'Magnitude (decibels)';
    case {'DBC/HZ'}
        out = 'dBc/Hz';
    case 'REAL'
        out = 'Real';
    case {'IMAG' 'IMAGINARY'}
        out = 'Imaginary';
    case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
        out = 'Magnitude (linear)';
    case {'ANGLE' 'ANGLE (DEGREES)'}
        out = 'Angle (degrees)';
    case 'ANGLE (RADIANS)'
        out = 'Angle (radians)';
    case 'NONE'
        out = 'None';
    case 'DBM'
        out = 'dBm';
    case 'DBW'
        out = 'dBW';
    case {'W' 'WATTS'}
        out = 'W';
    case 'MW'
        out = 'mW';
    case 'SEC'
        out = 'Sec';
    case 'KELVIN'
        out = 'Kelvin';
    otherwise
        out = in;
    end

case 2 % For datatip
    switch upper(in)
    case {'DB' 'MAGNITUDE (DECIBELS)'}
        out = 'dB';
    case {'DBC/HZ'}
        out = 'dBc/Hz';
    case 'REAL'
        out = 'Real';
    case {'IMAG' 'IMAGINARY'}
        out = 'Imag';
    case {'ABS' 'MAG' 'MAGNITUDE (LINEAR)'}
        out = 'Mag';
    case {'ANGLE' 'ANGLE (DEGREES)'}
        out = 'Deg';
    case 'ANGLE (RADIANS)'
        out = 'Rad';
    case 'NONE'
        out = '';
    case 'DBM'
        out = 'dBm';
    case 'DBW'
        out = 'dBW';
    case {'W' 'WATTS'}
        out = 'W';
    case 'MW'
        out = 'mW';
    case 'SEC'
        out = 'Sec';
    case 'KELVIN'
        out = 'K';
    otherwise
        out = in;
    end
end