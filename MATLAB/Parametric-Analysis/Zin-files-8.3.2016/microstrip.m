function [Zm, C, L, epseff] = microstrip(w,h,epsr)
%from James/Hall/Wood "Microstrip Antenna Theory & Design" page 24
%
c = 3e8; %speed of light
% w = .01; %microstrip width
% h = .04; %substrate height
% epsr = 2.2;

if w/h<1
    Zm = 377/(pi*sqrt(2*(epsr+1))) * (log(8*h/w) + 1/32*(w/h)^2 - ...
        (epsr-1)/(2*(epsr+1)) * (log(pi/2)+log(4/pi)/epsr) );
else
    Zm = 377/(2*sqrt(epsr)) * (w/(2*h) + 0.441 + 0.082*(epsr-1)/epsr^2+...
        (epsr+1)/(2*pi*epsr)*(1.451+log(w/(2*h)+0.94)) )^(-1);
end

epseff=1/2*(epsr+1+(epsr-1)*(1+10*h/w)^(-1/2));
v = c/sqrt(epseff);
C = 1/(v*Zm);
L = Zm/v;