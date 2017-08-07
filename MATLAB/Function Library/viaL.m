function [ L ] = viaL( h2, r)

%Implements empirical solution due to Goldfarb & Pucel
%valid for height < 0.03 wavelengths
%fit from data for heights between 100 um and 631 um



mu0 = 4*pi*10^-7;
L = (mu0/(2*pi))*(h2*log((h2+sqrt(r^2+h2^2))/r) + 1.5*(r-sqrt(r^2+h2^2)));


end

