function [ Ym ] = VdCmutualY(l, s, sep, f)
%computes the mutual admittance (real part only, for some reason) between
%two identically sized slots at some distance sep.  The slots have length l
%and width s.  These are absolute dimensions, not wavelengths.
k0=2*pi*f/(3e8);

Gs1 = Gs(k0*l, k0*s);
Kg=1;

Gm=Gs1*Kg*Fg(k0*sep, k0*s);
Ym=Gm;

end

function [G] = Gs(w, s)

G = (1/(pi*377))*((w*sinint(w)+sin(w)/w+cos(w)-2)*(1-s^2/24) + ...
    (s^2/12)*(1/3+cos(w)/w^2-sin(w)/w^3));
end

function [Fg] = Fg(l, s)
Fg = besselj(0,l)+s^2*besselj(2,l)/(24-s^2);
end

function [Fb] = Fb(l, s)
Fb = (pi/2)*(bessely(0,l)+s^2*bessely(2,l)/(24-s^2))/(log(s/2)+0.577216-3/2+(s^2/12)/(24-s^2));
end