function [ Lmat ] = MTLviaABCD( h2, r, f)
%computes inductance of a Via and constructs ABCD matrix for vias 
 
omega=2*pi*f;   
mu0 = 4*pi*10^-7;
L  = viaL( h2, r);
  
 
   



Lmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 (1/(j*omega*L)) 0 1];


end

