function [ Z0 ] = microstripZ0( epsr, W, h, t)
%from https://www.rogerscorp.com/documents/780/acs/Design-Data-for-Microstrip-Transmission-Lines-on-RT-duroid-Laminates.pdf
%doesn't include correction for frequency effect (yet)
u=W/h;
U1 = u+t*log(1+4*exp(1)*tanh((6.517*u)^0.5)^2)/pi;
Ur = u+(U1-u)*(1+(1/cosh((epsr-1)^0.5)))/2;

a=1+(1/49)*log((Ur^4+(Ur/52)^2)/(Ur^4+0.432))+(1/18.7)*log(1+(Ur/18.1)^3);
b=0.564*((epsr-0.9)/(epsr+3))^0.053;

Y=(epsr+1)/2+((epsr-1)/2)*(1-10/Ur)^(-a*b);


Z0=Z01(Ur)/Y^0.5;


end

function [Z]=Z01(u)
Z=377*log((6+(2*pi-6)*exp(-(30.666/u)^0.7528))/u + (4/u^2+1)^0.5)/(2*pi);
end