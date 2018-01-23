function [out_mat, freq, power] = interp(h, parameter, varargin)
%INTERP Interpolate the required power-dependent parameters.
%   [OUTMAT, FREQ, POWER] = INTERP(H, PARAMETER, INTERP_TYPE, FREQ, POWER,  
%   POWER_TYPE) calculates the required parameter and returns it.
%
%   See also RFDATA.P2P

%   Copyright 2006-2007 The MathWorks, Inc.

num_varargin = numel(varargin);
if num_varargin == 0
    interp_type = 'linear';
else
    interp_type = varargin{1};
end
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
        p_original = h.P1;
    otherwise % if power_type is 'pout'
        p_original = h.P2;
end
if num_varargin < 3
    power = uniquepower(p_original);
else
    power = varargin{3};
    if isempty(power)
        power = uniquepower(p_original);
    end
end

n1 = str2double(parameter(3));
n2 = str2double(parameter(4));
sparam = h.Data;
freq_original = h.Freq;
num_freq_original = numel(freq_original);
num_freq = numel(freq);
num_power = numel(power);

% Interpolate on power first
power_mat = zeros(num_power, num_freq_original);
for ii = 1:num_freq_original
    power_mat(:,ii) = interpolate(h, p_original{ii}, ...
        squeeze(sparam{ii}(n1, n2, :)), power, interp_type);
end

% Interpolate on freq
out_mat = zeros(num_power, num_freq);
for ii = 1:num_power
    out_mat(ii, :) = interpolate(h, freq_original, ...
        power_mat(ii, :), freq, interp_type);
end

function out = uniquepower(p_original)
out = unique(cat(1, p_original{:}));