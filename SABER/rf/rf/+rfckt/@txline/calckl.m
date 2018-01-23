function y = calckl(h, freq)
%CALCKL(H, FREQ) return e^(-kl)
%   where k is the complex propagation constant and l is the transmission
%   line length.
%
%   See also RFCKT.TXLINE

%   Copyright 2003-2007 The MathWorks, Inc.

len = get(h, 'LineLength');     % transmission line length
alphadB = get(h, 'Loss');
pv = get(h, 'PV'); 

% Check the Loss
if length(alphadB) == 1
    alphadB = alphadB*ones(size(freq));
else 
    alphadB = interpolate(h, h.Freq, alphadB, freq, h.IntpType);
end
alphadB = alphadB(:);

% Check the phase velocity
if length(pv) == 1
    pv = pv*ones(size(freq));
else
    pv = interpolate(h, h.Freq, pv, freq, h.IntpType);
end
pv = pv(:);

% Get wave number (propagation constant) beta
beta = 2*pi*freq./pv;
% Get the exponent of attenuation coefficient times -len
% e_negalphal stands for e^(-alpha*len)
e_negalphal = (10.^(-alphadB./20)).^len;
% k = alpha + j*beta; % complex propagation constant
y = e_negalphal .* exp(-j*beta*len);