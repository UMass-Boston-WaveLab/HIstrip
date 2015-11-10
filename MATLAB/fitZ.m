function [ Z ] = fitZ( f, hant, hsub, w, g, epsr, viarad)
%FITZ makes the right shape of input impedance but I don't know why it
%would do that physically.  implements a tank circuit in series with a TL
%resonator of a completely nonsensical length.

eps0 = 8.854*10^-12;

omega = 2*pi*f;

L = viaL(hsub, viarad);
YL = 1./(j*omega*L);
Cpatch = eps0*epsr*w^2/hsub;

[Cg, ~, ~] = microstripgapcap(epsr, g, hsub, w);

Ctot = Cpatch+4/(1/Cg+1/Cpatch);

YC = j*omega*Ctot;
tankZ = 1./(YL+YC);

ABCD = HISlayerABCD(w, g, hsub, viarad, epsr, f);
[ZB, ~] = bloch(ABCD, w+g);

Z = tankZ+ZB/2;

end

