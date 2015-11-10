function [ Z ] = equivslotZ_TL2( f, hsub, hant, want, viarad, patcharea, g, eps_lower)
%EQUIVSLOTZ assembles everything to get the equivalent slot impedance at
%the edges of a high impedance backed antenna.  This version assumes that
%the first patch's electrical length matters.

eps0=8.854*10^-12;
beta = 2*pi*f/(3e8);

%calculate impedance of upper equivalent radiating slot, same as the usual
%patch antenna slot would be
Y_upper=harringtonslotY(f, hant, want);


Z0=microstripZ0_2(want,hant,1); %assumes upper layer is air; doesn't have to.
deltaL = microstripdeltaL(want, hant, 1);

Z_upper = Z0*(Z0-j*(1./Y_upper).*tan(beta*deltaL))./((1./Y_upper)-j*Z0*tan(beta*deltaL));


ABCD = HISlayerABCD(sqrt(patcharea),g,hsub,viarad,eps_lower,f);
[ZB, ~] = bloch(ABCD, sqrt(patcharea)+g);


Z = Z_upper+ZB/2;


end

