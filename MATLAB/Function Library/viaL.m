function [ L ] = viaL( h2, r)

%Implements empirical solution due to Goldfarb & Pucel
%valid for height < 0.03 wavelengths
%fit from data for heights between 100 um and 631 um

% 1<w/h<2.2 ~~ outside this value should be accurate within 3% if the d/h
% condition is met 
% 0.2 < d/h < 1.5

mu0 = pi*4e-7;
L1 = (mu0/(2*pi))*(h2*log((h2+sqrt(r^2+h2^2))/r) + 1.5*(r-sqrt(r^2+h2^2)));

L = L1+L1*0.04;

end

