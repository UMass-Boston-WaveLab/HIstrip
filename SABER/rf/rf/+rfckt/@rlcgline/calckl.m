function y = calckl(h, freq)
%CALCKL(H, FREQ) returns e^(-kl)
%   where k is the complex propagation constant and l is the transmission
%   line length.
%
%   See also RFCKT.RLCGLINE

%   Copyright 2003-2007 The MathWorks, Inc.

R = get(h, 'R');
L = get(h, 'L');
C = get(h, 'C');
G = get(h, 'G');
len = get(h, 'LineLength'); 
w = 2*pi*freq;
L(L == 0) = eps;
C(C == 0) = eps;
if length(R) == 1
    R = R*ones(size(freq));
else 
    R = interpolate(h, h.Freq, R, freq, h.IntpType);
end
R = R(:);
if length(L) == 1
    L = L*ones(size(freq));
else 
    L = interpolate(h, h.Freq, L, freq, h.IntpType);
end
L = L(:);
if length(C) == 1
    C = C*ones(size(freq));
else 
    C = interpolate(h, h.Freq, C, freq, h.IntpType);
end
C = C(:);
if length(G) == 1
    G = G*ones(size(freq));
else 
    G = interpolate(h, h.Freq, G, freq, h.IntpType);
end
G = G(:);


z0 = sqrt((R+1i*w.*L)./(G+1i*w.*C));
k = sqrt((R+1i*w.*L).*(G+1i*w.*C)); 

% Set characteristic impedance, phase velocity and Loss
set(h, 'Z0', z0);
pv = w./imag(k);
set(h, 'PV', pv);
alphadB = 20*log10(exp(real(k)));
alphadB(alphadB==inf) = 1/eps;
set(h, 'Loss', alphadB);
y = exp(-k*len);