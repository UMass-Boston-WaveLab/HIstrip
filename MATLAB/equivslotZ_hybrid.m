function [ Z ] = equivslotZ_hybrid( f, hsub, hant, want, viarad, patcharea, g, eps_lower)
%EQUIVSLOTZ assembles everything to get the equivalent slot impedance at
%the edges of a high impedance backed antenna.  This version assumes that
%the first patch's electrical length matters.

eps0=8.854*10^-12;
beta = 2*pi*f/(3e8);

%calculate impedance of upper equivalent radiating slot, same as the usual
%patch antenna slot would be
Y_upper=harringtonslotY(f, hant, want);

Ys=harringtonslotY(f, hsub, sqrt(patcharea));

Z0=microstripZ0_2(want,hant,1); %assumes upper layer is air; doesn't have to.
deltaL = microstripdeltaL(want, hant, 1);

Z_upper = Z0*(Z0-j*(1./Y_upper).*tan(beta*deltaL))./((1./Y_upper)-j*Z0*tan(beta*deltaL));


%inductance of via from patch to ground
Lvia = viaL(hsub,viarad);

YL = 1./(j*2*pi*f*Lvia);

%calculate the input impedance of one branch of the 4-way parallel TL
%connection that accounts for the surface loading (parallel to that
%inductor)

[Cg, ~, ~] = microstripgapcap(eps_lower, g, hsub, sqrt(patcharea));
Cpatch = eps0*eps_lower*patcharea/hsub;
%only include half the gap because the other half is included in the Bloch
%unit cell
Zgap = 1./(2*pi*f*2*Cg);

ABCD = HISlayerABCD(sqrt(patcharea),g,hsub,viarad,eps_lower,f);
[ZB, ~] = bloch(ABCD, sqrt(patcharea)+g);

ZL=Zgap+ZB;

YCpatch = j*2*pi*Cpatch;


Y_lower = YL+YCpatch+4./ZL;

Z = Z_upper+1./Y_lower;


end

