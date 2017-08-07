function [Fb] = Fb(l, s)
%% Fb is a coupling function expressing the ratio between the per-unit-length mutual admittance and the per unit length self admittance

s = k0*h_ant;


Fb = (pi/2)*(bessely(0,l)+(s^2*bessely(2,l))/(24-s^2))/(log(s/2)+0.577216-3/2+(s^2/12)/(24-s^2))
end