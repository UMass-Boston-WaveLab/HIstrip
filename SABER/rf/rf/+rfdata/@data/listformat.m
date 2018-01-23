function list = listformat(varargin)
%LISTFORMAT List the valid formats for the specified PARAMETER.
%   LIST = LISTFORMAT(H, PARAMETER) lists the valid formats for the
%   specified PARAMETER.
%    
%   Type LISTPARAM(H) to get the valid parameters of the RFDATA.DATA object.
%
%   See also RFDATA.DATA, RFDATA.DATA/LISTPARAM, RFDATA.DATA/ANALYZE,
%   RFDATA.DATA/PLOT, RFDATA.DATA/TABLE, RFDATA.DATA/PLOTYY,
%   RFDATA.DATA/CALCULATE

%   Copyright 2003-2010 The MathWorks, Inc.

% Set the default
list = {};

% Get the object and inputs
h = varargin{1};
if nargin == 1
    parameter = 'ALL'; 
else
    parameter = varargin{2};
end

format_complexdata = {'dB' 'Magnitude (decibels)' 'Abs' 'Mag' ...
            'Magnitude (linear)' 'Angle' 'Angle (degrees)' ...
            'Angle (radians)' 'Real' 'Imag' 'Imaginary'};
        
% Determine the format
switch upper(parameter)
    case 'ALL'
         list = {'dB' 'Magnitude (decibels)' 'Abs' 'Mag' ...
                'Magnitude (linear)' 'Angle' 'Angle (degrees)' ...
                'Angle (radians)' 'Real' 'Imag' 'Imaginary' ...
                'dBm' 'dBW' 'W' 'mW' 'dBc/Hz' 'ns' 'us' 'ms' 's' 'ps' ...
                'Kelvin' 'None'};

    case {'OIP3' 'IIP3' 'OIP2' 'IIP2'}
        list = {'dBm' 'dBW' 'W' 'mW'};

    case {'POUT'}
        if haspowerreference(h) || hasp2dreference(h)
            list = {'dBm' 'dBW' 'W' 'mW'};
        end

    case {'PHASE'}
        if haspowerreference(h) || hasp2dreference(h)
            list = {'Angle' 'Angle (degrees)' 'Angle (radians)'};
        end

    case {'AM/AM'}
        if haspowerreference(h) || hasp2dreference(h)
            list = {'dB' 'Magnitude (decibels)' 'None'};
        end

    case {'AM/PM'}
        if haspowerreference(h) || hasp2dreference(h)
            list = {'Angle' 'Angle (degrees)' 'Angle (radians)'};
        end

    case {'PHASENOISE'}
        list = {'dBc/Hz'};

    case {'FMIN'}
        if hasnoisereference(h)
            list = {'dB' 'Magnitude (decibels)' 'None'};
        end

    case {'GAMMAIN' 'GAMMAOUT'}
        nport = getnport(h);
        if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters'))) && nport == 2
            list = format_complexdata;
        end

    case {'GAMMAOPT'}
        if hasnoisereference(h)
            list = format_complexdata;
        end

    case {'RN'}
        if hasnoisereference(h)
            list = {'None'};
        end

    case {'VSWRIN' 'VSWROUT'}
        nport = getnport(h);
        if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters'))) && nport == 2
            list = {'dB' 'Magnitude (decibels)' 'None'};
        end

    case {'NF'}
        nport = getnport(h);
        if nport == 2
            list = {'dB' 'Magnitude (decibels)'};
        end

    case {'LS11', 'LS12', 'LS21', 'LS22'}
        if hasp2dreference(h)
            list = format_complexdata;
        end

    case {'GA', 'GT', 'GP', 'GMAG', 'GMSG'}
        list = {'dB' 'Magnitude (decibels)' 'None'};

    case {'GAMMAMS', 'GAMMAML'}
        list = format_complexdata;

    case {'TF1', 'TF2', 'TF3'}
        list = format_complexdata;

    case {'K' 'MU' 'MUPRIME', 'NFACTOR'}
        list = {'None'};
        
    case {'NTEMP'}
        list = {'Kelvin'};
        
    case {'GROUPDELAY'}
        list = {'ns' 'us' 'ms' 's' 'ps'};
        
    case {'DELTA' }
        list = format_complexdata;

    otherwise
        if  strncmpi(parameter, 'S', 1)
            idx = strfind(parameter, ',');
            if numel(idx)==1
                nport = getnport(h);
                index1 = str2double(parameter(2:idx-1));
                index2 = str2double(parameter(idx+1:end));
                if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')))
                    if  ((0 < index1) && (index1 <= nport) && (0 < index2) && (index2 <= nport))
                        list = format_complexdata;
                    end
                end
            elseif (numel(parameter)==3)
                nport = getnport(h);
                index1 = str2double(parameter(2));
                index2 = str2double(parameter(3));
                if (~isempty(get(h,'Freq')) && ~isempty(get(h,'S_Parameters')))
                    if  ((0 < index1) && (index1 <= nport) && (0 < index2) && (index2 <= nport))
                        list = format_complexdata;
                    end
                end
            end
        end
end

if isempty(list)
    error(message('rf:rfdata:data:listformat:InvalidInput', parameter));
else
    list = list';
end