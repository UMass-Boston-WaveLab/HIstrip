function [ Z0 ] = microstripZ0_2( w,h2,epsr )
%MICROSTRIPZ0 calculates the characteristic impedance of a microstrip line
%epsr = 2.2;
%h2 = 0.04; %patch height above ground plane 
%w = 0.12; %patch width
u=w/h2;
f = 6+(2*pi-6)*exp(-(30.666/u)^0.7528);
eff = epseff(w,h2,epsr);
Z0=(1/sqrt(eff))*(377/(2*pi))*log(f/u+sqrt(1+(2/u)^2));
end