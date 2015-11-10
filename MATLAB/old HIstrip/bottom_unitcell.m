function [ABCD, Zbloch, gam] = bottom_unitcell(a, w2, h2, via_rad, eps2, freq)

gap = a-w2;
omega = 2*pi*freq;
mu0 = pi*4e-7;
eps0=8.854e-12;
c = 1/sqrt(mu0*eps0);
lam0 = c/freq;
k0 = omega/c;

L_via = via_calc(h2, via_rad);

[Cgap,Cp] = microstripGapCap2(w2,h2,eps2,gap, freq);
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

beta2 = epseff2*omega/c;

TL = [cos(beta2*w2/2) j*Z2*sin(beta2*w2/2);
       j*sin(beta2*w2/2)/Z2 cos(beta2*w2/2)];
 
Yrad = (w2/(120*lam0)) *(1-(1/24)*(k0*h2)^2);

ABCD = [1 1/(j*omega*Cgap+Yrad), ; 0 1]*[1 0; j*omega*Cp 1]*TL*...
    [1 j*omega*L_via; 0 1]*TL*[1 0; j*omega*Cp 1]*...
    [1 1/(j*omega*Cgap+Yrad); 0 1];

[gam, Zbloch] = blochgamma(ABCD,a);