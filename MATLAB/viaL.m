function [ L ] = viaL( h, r)
%Implements empirical solution due to Goldfarb & Pucel
%valid for height < 0.03 wavelengths
%fit from data for heights between 100 um and 631 um
%original formula provides results in picohenries so we multiply by 10^-12
L = (mu0/(2*pi))*(h*log((h+sqrt(r^2+h^2))/r)+1.5*(r-sqrt(r^2+h^2)))*10^-12;


end

