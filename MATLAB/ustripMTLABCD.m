function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, freq, len)
%Makes 4x4 ABCD matrix of stacked microstrip MTL structure of length len.


mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*freq;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here
[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12];
%cap = [C12+1/(1/C12+1/C2G), -C12; -C12, C2G]; %Symmetric; see MTL book for where this comes from 
%--changed c11 value on April 24 2017 - see Paul multiconductor lines book
%p. 164



[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);
cap0 = [C120, -C120; -C120, C2G0+C120];
%cap0 = [C120+1/(1/C120+1/C2G0), -C120; -C120, C2G0]; %symmetric --changed c11 value on April 24 2017
ind = mu0*eps0*inv(vpa(cap0)); %symmetric

Z = (j*omega*vpa(ind)); %symmetric
Y = (j*omega*vpa(cap)); %symmetric

[T,gamsq]=eig(vpa(Z)*vpa(Y)); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = [sqrt(gamsq(1,1)) 0; 0 sqrt(gamsq(2,2))];

%Gam = T*gameig/T;  %-both of these should be true
Gam = sqrtm(Z*Y);

Zw = vpa(Gam)\Z; %symmetric 
Yw = Y/vpa(Gam); %symmetric

A = T*[cosh(gameig(1,1)*len) 0; 0 cosh(gameig(2,2)*len)]/T;

MTL = [A, (T*sinh(gameig*len)/T)*Zw; 
    Yw*T*sinh(gameig*len)/T, Yw*A*Zw]; 

end
