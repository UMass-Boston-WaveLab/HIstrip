function y = calckl(h, freq)
%CALCKL(H, FREQ) return e^(-k)
%
%   See also RFCKT/DELLAY

%   Copyright 2004-2007 The MathWorks, Inc.

alphadB = get(h, 'Loss');
delay = get(h, 'TimeDelay'); 

beta = 2*pi*freq*delay;
e_negalphal = (10.^(-alphadB./20));
% the complex propagation constant: k = alpha + j*beta
y = e_negalphal .* exp(-1i*beta);