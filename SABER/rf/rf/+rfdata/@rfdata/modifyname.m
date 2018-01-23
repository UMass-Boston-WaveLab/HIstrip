function out = modifyname(h, parameter, nport)
%MODIFYNAME Modify the parameter name for plot.
%
%   See also RFDATA

%   Copyright 2003-2010 The MathWorks, Inc.

% Set the default result
out = parameter;

% Check the data
if isempty(parameter); 
    return; 
end

part1 = strtok(parameter, '-');
switch upper(part1)
    case 'POUT'
        out = 'P_{out}';
    case 'PHASE'
        out = 'Phase';
    case 'AM/AM'
        out = 'AM of Output';
    case 'AM/PM'
        out = 'PM of Output';
    case 'FMIN'
        out = 'F_{min}';
    case 'GAMMAOPT'
        out = '\Gamma_{opt}';
    case 'RN'
        out = parameter;
    case 'GAMMAIN'
        out = '\Gamma_{in}';
    case 'GAMMAOUT'
        out = '\Gamma_{out}';
    case 'VSWRIN'
        out = 'VSWR_{in}';
    case 'VSWROUT'
        out = 'VSWR_{out}';
    case 'NF'
        out = 'NF';
    case 'NFACTOR'
        out = 'NFactor';
    case 'NTEMP'
        out = 'NTemp';
    case 'OIP3'
        out = 'OIP3';
    case 'IIP3'
        out = 'IIP3';
    case 'OIP2'
        out = 'OIP2';
    case 'IIP2'
        out = 'IIP2';
    case 'PHASENOISE'
        out = 'PhaseNoise';
    case 'GAMMAML'
        out = '\Gamma_{ML}';
    case 'GAMMAMS'
        out = '\Gamma_{MS}';
    case 'GMAG'
        out = 'G_{mag}';
    case 'GMSG'
        out = 'G_{msg}';
    case 'GA'
        out = 'G_{a}';
    case 'GT'
        out = 'G_{t}';
    case 'GP'
        out = 'G_{p}';
    case 'TF1'
        out = 'TF_{1}';
    case 'TF2'
        out = 'TF_{2}';  
    case 'TF3'
        out = 'TF_{3}';
    case 'K'
        out = 'K';
    case 'DELTA'
        out = 'Delta';
    case 'MU'
        out = 'Mu';
    case 'MUPRIME'
        out = 'MuPrime';
    case 'GROUPDELAY'
        out = 'GroupDelay';
    otherwise
        if numel(parameter)>=3 && strncmpi(parameter, 'S', 1)
            [index1, index2] = sparamsindexes(h, parameter, nport);
            if index1 >= 10 || index2 >= 10
                out = sprintf('S_{%i,%i}', index1, index2);
            else
                out = sprintf('S_{%i%i}', index1, index2);
            end
        elseif numel(parameter)>=4 && strncmpi(parameter, 'LS', 2)
            index1 = str2double(parameter(3));
            index2 = str2double(parameter(4));
            out = sprintf('LS_{%i%i}', index1, index2);
        else
            error(message('rf:rfdata:rfdata:modifyname:InvalidInput', parameter));
        end
end