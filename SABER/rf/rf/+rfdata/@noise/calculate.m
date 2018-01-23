function [data, param, freq] = calculate(h, parameter, freq)
%CALCULATE Calculate the required power parameter.
%   [DATA, PARAM, FREQ] = CALCULATE(H, PARAMETER) calculates the required
%   parameter and returns it.
%
%   The first input is the handle to this object, the second input is the
%   parameter that can be visualized from this object. 
%
%   See also RFDATA.NOISE

%   Copyright 2003-2007 The MathWorks, Inc.


% Set the default for returned data
% data = [];
% param = '';
if nargin < 3
    freq = h.Freq;
end
if isempty(freq)
    freq = h.Freq;
end

original_freq = h.Freq;
% Calculate the noise data
switch upper(parameter)
  case 'FMIN'
    data = interpolate(h,original_freq, get(h,'Fmin'), freq, 'linear');
  case 'GAMMAOPT'
    data = interpolate(h,original_freq, get(h,'GammaOPT'), freq, 'linear');
  case 'RN'
    data = interpolate(h,original_freq, get(h,'RN'), freq, 'linear');
  otherwise
    error(message('rf:rfdata:noise:calculate:InvalidInput', parameter));
end
param = modifyname(h, parameter, 2);