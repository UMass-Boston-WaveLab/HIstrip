function [Y] = slotadmittance(W, h, lam0)
G = (W/(120*lam0))*(1-(1/24)*(2*pi*h/lam0)^2);
B = (W/(120*lam0))*(1-0.636*log((2*pi*h/lam0)^2));
Y = G+j*B;