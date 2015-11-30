function [ Z ] = JHWslotZ(h, w, f, epsr )
%JHWslotZ calculates impedance of microstrip antenna equivalent radiating
%slot as described in James, Hall, & Wood's "Microstrip Antenna Theory and
%Design": equation 3.25 for the conductance, with effective width also from
%this book.
%   Effective width: equation 2.16
c=3e8;
lam=c/f;
beta0=2*pi/lam;

epsf=epseff(w,h,epsr);

deltaL = microstripdeltaL(w, h, epsr);

Zm = microstripZ0_pozar(epsr, w, h); %try a different expression here?

weff = 120*pi*h/(Zm*sqrt(epsf));

Gr = (1/Zm)*4*pi*(h*weff/lam^2)/(3*sqrt(epsf));

betaf=beta0*sqrt(epsf);

Z=1/Gr;
%include deltaL in MTL instead of single-conductor tline
Z = Zm*(1/Gr+j*Zm*tan(betaf*deltaL))/(Zm+j*(1/Gr)*tan(betaf*deltaL));

end

