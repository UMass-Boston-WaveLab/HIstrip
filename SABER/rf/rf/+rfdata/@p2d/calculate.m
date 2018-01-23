function [ydata, param, xdata] = calculate(h, parameter, varargin)
%CALCULATE Calculate the required power-dependent parameter.
%   [YDATA, PARAM, XDATA] = CALCULATE(H, PARAMETER, POWER, FREQ,
%   INTERP_TYPE, POWER_TYPE) calculates the required parameter and returns
%   it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object. 
%
%   See also RFDATA.P2P

%   Copyright 2006-2009 The MathWorks, Inc.

% Set the defaults
ydata = [];
param = '';
xdata = [];
num_varargin = numel(varargin);
if num_varargin < 4
    power_type = 'pin';
else
    power_type = varargin{4};
end

[part1, part2] = strtok(parameter, '-');
% Calculate the ydata
if strcmpi(part2, '-Freq') || isempty(part2)
    [out_mat, freq, power] = interp(h, parameter, varargin{:});
    xdata = freq(:);
    out_mat = out_mat.'; % Every column of out_mat becomes ydata of a line
    numtrace = size(out_mat, 2); % Number of lines equals number of columns
    ydata = out_mat;
    temp_param = modifyname(h, parameter, 2);
    param = repmat({temp_param}, numtrace, 1);
    param = appendvars(h, param, power, power_type);

elseif strcmpi(part2, '-Pin')  || strcmpi(part2, '-Pout')
    [out_mat, freq, power] = interp(h, parameter, varargin{:});
    xdata = power(:);
    numtrace = size(out_mat, 2); % Number of lines equals number of columns
    ydata = out_mat;
    temp_param = modifyname(h, parameter, 2);
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
