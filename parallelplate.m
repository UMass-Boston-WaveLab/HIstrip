function [Z, C, L] = parallelplate(w, h, epsr)
%inputs: width, height, and dielectric constant of parallel plate guide
%outputs: characteristic impedance, capacitance per unit length, inductance
%per unit length.

mu0 = pi*4e-7;
eps0=8.854e-12;

C = eps0*epsr*w/h; %capacitance per unit length
L = mu0*h/w;

Z = sqrt(L/C);