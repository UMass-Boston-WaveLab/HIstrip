function [data, param, xdata] = calculate(h, parameter, varargin)
%CALCULATE Calculate the required power parameter.
%   [DATA, PARAM, FREQ] = CALCULATE(H, PARAMETER) calculates the required
%   parameter and returns it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object. 
%
%   See also RFDATA.POWER
  
%   Copyright 2006-2009 The MathWorks, Inc.

% Set the defaults
data = [];
param = '';
xdata = [];
num_varargin = numel(varargin);
if num_varargin < 4
    power_type = 'pin';
else
    power_type = varargin{4}; 
end

[part1, part2] = strtok(parameter, '-');
% Calculate the data
if strcmpi(part2, '-Freq')
    [data, freq, power] = interp(h, parameter, varargin{:});
    xdata = freq(:);
    data = data.'; % Every column of out_mat becomes ydata of a line
    numtrace = size(data, 2); % Number of lines equals number of columns
    temp_param = modifyname(h, part1, 2);
    param = repmat({temp_param}, numtrace, 1);
    param = appendvars(h, param, power, power_type);

elseif isempty(part2) || strcmpi(part2, '-Pin') || strcmpi(part2, '-AM')
    [data, freq, power] = interp(h, parameter, varargin{:});
    xdata = power(:);
    numtrace = size(data, 2); % Number of lines equals number of columns
    temp_param = modifyname(h, part1, 2);
    param = repmat({temp_param}, numtrace, 1);
    param = appendvars(h, param, freq, 'Freq');

else
    return
end

function param = appendvars(h, param, vars, varname)
%APPENDVARS Append variable names and values to the parameter names.
switch upper(varname)
    case {'PIN','POUT'}
        [name, data, unit] = scalingpower(h, vars, 'dBm', varname);
    case {'FREQ'}
        [name, data, unit] = scalingfrequency(h, vars);
end
strmat = num2str(data(:));
tempstr = mat2cell(strmat, ones(1, size(strmat, 1)), size(strmat, 2));
tempstr = strtrim(tempstr);
tempstr = strcat(name, {'='}, tempstr, unit, ';');
param = strcat(param, {'('}, tempstr, {')'});
