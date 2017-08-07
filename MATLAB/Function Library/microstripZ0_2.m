function [ Z0 ] = microstripZ0_2( w,h,epsr )
%MICROSTRIPZ0 calculates the characteristic impedance of a microstrip line

u=w/h;
f=6+(2*pi-6)*exp(-(30.666/u)^0.7528);
eff = epseff(w,h,epsr);

Z0=(1/sqrt(eff))*(377/(2*pi))*log(f/u+sqrt(1+(2/u)^2));



end

