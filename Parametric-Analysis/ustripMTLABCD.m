function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)
%Makes 4x4 ABCD matrix of stacked microstrip MTL structure of length a.

mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here
[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);
cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric
ind = mu0*eps0*inv(cap0); %symmetric

Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = [sqrt(gamsq(1,1)) 0; 0 sqrt(gamsq(2,2))];

Zw = Gam\Z; %symmetric 
Yw = Y/Gam; %symmetric

MTL = [T*[cosh(gameig(1,1)*len/2) 0; 0 cosh(gameig(2,2)*len/2)]/T,...
        (T*sinh(gameig*len/2)/T)*Zw; Yw*T*sinh(gameig*len/2)/T, ...
        Yw*T*[cosh(gameig(1,1)*len/2) 0; 0 cosh(gameig(2,2)*len/2)]/T*Zw];
   

end
