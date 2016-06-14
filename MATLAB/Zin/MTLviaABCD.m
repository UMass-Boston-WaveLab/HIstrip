function [ Lmat ] = MTLviaABCD( h2, r, f)
%computes inductance of a Via and constructs ABCD matrix for vias 
    
    function [ L ] = viaL( h2, r)
    %Implements empirical solution due to Goldfarb & Pucel
    %valid for height < 0.03 wavelengths
    %fit from data for heights between 100 um and 631 um
    r = 1.5875e-3; %mm radius of via
    h2 = .04; %patch height above ground
    mu0 = 4*pi*10^-7;
    L = (mu0/(2*pi))*(h2*log((h2+sqrt(r^2+h2^2))/r) + 1.5*(r-sqrt(r^2+h2^2)))
    end

f = 300e6; %hz
omega=2*pi*f;
Lmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 (1/(j*omega*viaL)) 0 1];


end

