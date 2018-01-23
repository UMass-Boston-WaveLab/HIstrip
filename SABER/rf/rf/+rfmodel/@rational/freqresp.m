function [resp, freq] = freqresp(h, freq)
%FREQRESP Compute the frequency response of a rational function object.
%   [RESP, FREQ] = FREQRESP(H, FREQ) computes the frequency response of the
%   rational function object, H, at the frequencies specified by the input
%   FREQ.
%
%   H is the handle to the RFMODEL.RATIONAL object. FREQ is a vector of
%   frequencies, in Hz, over which the frequency response will be
%   calculated. 
%
%   See also RFMODEL.RATIONAL, RFMODEL.RATIONAL/ISPASSIVE, 
%   RFMODEL.RATIONAL/TIMERESP, RFMODEL.RATIONAL/STEPRESP,
%   RFMODEL.RATIONAL/WRITEVA, RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

% Check the input
narginchk(2,2);

% Check the properties
checkproperty(h);
% Get the properties
poles = h.A;
c = h.C;
d = h.D;
e = h.E;
delay = h.Delay;

% Calculate the frequency response
freq = checkfrequency(h, freq);
s = 2j*pi*freq;
resp = exp(-2j*pi*freq*delay) .* (e*s + d + ...
    sum(bsxfun(@rdivide,c(:).',bsxfun(@minus,s(:),poles(:).')),2));
