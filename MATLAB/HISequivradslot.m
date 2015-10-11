function [ Z ] = HISequivradslot( f, hsub, hant, want, viarad, patcharea, eps_upper, eps_lower)
%HISEQUIVRADSLOT calculates radiation impedance due to equivalent radiating
%slot at the end of a HIS-backed antenna
%f is a vector, all other things are scalars.  Z is a vector.

Y_upper=harringtonslotY(hant, want, eps_upper, f);

Ys=harringtonslotY(hsub, patcharea, eps_lower, f);

Lvia = viaL(hsub,viarad);

YL = 1./j*2*pi*f*Lvia;

Cpatch = eps_lower*patcharea/hsub;

YC = (j*2*pi*f*Cpatch);

Y_lower = YL+YC+Ys;

Z = 1./Y_upper + 1./Y_lower;


end

