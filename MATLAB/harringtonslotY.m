function [ Y ] = harringtonslotY( f, h, L)
%HARRINGTONSLOTY calculates admittance of a "capacitive" slot.  The
%equations from Harrington (p. 183) are for per-unit-length conductance and
%susceptance, so we have to multiply by the total slot length here to get
%slot admittance.  These are valid for k*h<0.1.  frequency can be a vector.

eta = 377;
lam = 3e8./f;
k=2*pi./lam;

Gpul = (pi./(vpa(lam)*eta)).*(1-(vpa(k)*h).^2/24);
Bpul = (1./(vpa(lam)*eta)).*(3.135-2*log(vpa(k)*h));

Y = L*(Gpul+j*Bpul);


end

