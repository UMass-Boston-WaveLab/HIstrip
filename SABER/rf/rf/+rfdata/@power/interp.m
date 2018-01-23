function [out_mat, freq, power] = interp(h, parameter, varargin)
%INTERP Interpolate the required power-dependent parameters.
%   [OUTMAT, FREQ, POWER] = INTERP(H, PARAMETER, INTERP_TYPE, FREQ, POWER,  
%   POWER_TYPE) calculates the required parameter and returns it.
%
%   See also RFDATA.POWER
  
%   Copyright 2006-2007 The MathWorks, Inc.

num_varargin = numel(varargin);
interp_type = 'linear';
if num_varargin < 2
    freq = h.Freq;
else
    freq = varargin{2};
    if isempty(freq)
        freq = h.Freq;
    end
end
if num_varargin < 4
    power_type = 'pin';
else
    power_type = varargin{4};
end
switch lower(power_type)
    case 'pin'
        p_original = h.Pin;
    otherwise % if power_type is 'pout'
        p_original = h.Pout;
end
if num_varargin < 3
    power = uniquepower(p_original);
else
    power = varargin{3};
    if isempty(power)
        power = uniquepower(p_original);
    end
end

% Convert power to AM 
RL = real(h.Z0);
am_original = cell(size(p_original));
np_original = numel(p_original);
for ii = 1:np_original
    am_original{ii} = sqrt(RL * p_original{ii});
end
am_to_interp = sqrt(RL * power);

part1 = strtok(parameter, '-');
switch upper(part1)
    case {'PHASE', 'AM/PM', 'PM'}
        data_to_interp = h.Phase;
    otherwise % {'POUT', 'AM/AM', 'AM'}
        % Convert pout to am
        data_to_interp = cell(size(h.Pout));
        ndata_to_interp = numel(data_to_interp);
        for ii = 1:ndata_to_interp
            data_to_interp{ii} = sqrt(RL * h.Pout{ii});
        end
end

freq_original = h.Freq;
% Interpolate on AM/Voltage first
num_freq_original = numel(freq_original);
num_freq = numel(freq);
num_power = numel(power);
power_mat = zeros(num_power, num_freq_original);
switch upper(part1)
    case {'POUT', 'AM/AM', 'AM'}
        for ii = 1:num_freq_original
            power_mat(:,ii) = interpam(h, am_original{ii},              ...
                data_to_interp{ii}, am_to_interp);
        end
    otherwise
        for ii = 1:num_freq_original
            power_mat(:,ii) = interpolate(h, am_original{ii},           ...
                data_to_interp{ii}, am_to_interp, interp_type);
        end
end

% Interpolate on freq
out_mat = zeros(num_power, num_freq);
switch upper(part1)
    case {'POUT', 'AM/AM', 'AM'}
        for ii = 1:num_power
            out_mat(ii, :) = interpolate(h, freq_original,              ...
                power_mat(ii, :), freq, 'nearest');
        end
    otherwise
        for ii = 1:num_power
            out_mat(ii, :) = interpolate(h, freq_original,              ...
                power_mat(ii, :), freq, 'nearest');
        end
end

switch upper(part1)
    case {'POUT'}
        out_mat = (out_mat.^2)./RL; % Conver back to power
    case {'AM/AM', 'AM'}
        power = am_to_interp;
    case {'AM/PM', 'PM'}
        power = am_to_interp;
end

function out = uniquepower(p_original)
out = unique(cat(1, p_original{:}));
