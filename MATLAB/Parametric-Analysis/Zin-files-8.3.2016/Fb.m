function [Fb] = Fb(l, s)
%% Fb is a coupling function expressing the ratio between the per-unit-length mutual admittance and the per unit length self admittance

w_ant = .01;
h_ant = .02;
L_ant = .48; 
w_sub = 1.12;
h_sub = 0.04;
L_sub = 1.12;
eps1 = 1;
eps2 = 2.2;
freq = 300e6;
k0 = 2*pi*freq/(3e8);
s = k0*h_ant;
w = k0*w_ant;
l = k0*L_ant;
E = exp(-0.21*w);
Kb = 1 - E;

Fb = (pi/2)*(bessely(0,l)+(s^2*bessely(2,l))/(24-s^2))/(log(s/2)+0.577216-3/2+(s^2/12)/(24-s^2))
end