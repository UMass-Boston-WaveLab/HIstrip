function [ Z ] = HISequivradslot( f, hsub, hant, want, viarad, patcharea, g, eps_lower)
%HISEQUIVRADSLOT calculates radiation impedance due to equivalent radiating
%slot at the end of a HIS-backed antenna
%f is a vector, all other things are scalars.  Z is a vector.
eps0=8.854*10^-12;
beta = 2*pi*f/(3e8);
Y_upper=harringtonslotY(f, hant, want);

Ys=harringtonslotY(f, hsub, sqrt(patcharea));

Lvia = viaL(hsub,viarad);

YL = 1./(j*2*pi*f*Lvia);

Cpatch = eps0*eps_lower*patcharea/hsub;
[Cg, ~, ~] = microstripgapcap(eps_lower, g, hsub, sqrt(patcharea));

Ctot = Cpatch+4/(1/Cg+1/Cpatch);


YC = (j*2*pi*f*Ctot);  %the factor of 4 makes it show up at the right frequency, and is handwavingly asociated with coupling to nearby patches.

Y_lower = YL+YC+Ys;

deltaL = microstripdeltaL(want, hant, 1);

Z0=microstripZ0_2(want,hant,1);

Zupper = Z0*(Z0-j*(1./Y_upper).*tan(beta*deltaL))./((1./Y_upper)-j*Z0*tan(beta*deltaL));

Z = Zupper + 1./Y_lower;


end

