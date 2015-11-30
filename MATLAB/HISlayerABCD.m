function [ABCD, ABCDL, ABCDgaphalf, ABCDline] = HISlayerABCD(w, wsub, g, h, rad, epsr, f )
%HISlayerABCD outputs a 2 x 2 x length(f) array of ABCD matrix vs.
%frequency.  Assumes the whole width of the substrate is involved in TEM
%mode.

Lvia = viaL(h, rad);



mu0= 4*pi*10^-7;
eps0=8.854*10^-12;

Z0= sqrt(mu0/eps0)*h/(wsub*sqrt(epsr)); %characteristic Z for parallel plate WG TEM mode

for ii = 1:length(f)
    omega = 2*pi*f(ii);
    beta = omega*sqrt(mu0*eps0*epsr);
    
    ABCDL(:,:,ii) = [1 0; 1/(j*omega*Lvia) 1];
    ABCDgaphalf(:,:,ii) = [1 1/(2*harringtonslotY(f(ii), g, wsub)); 0 1]; %
    ABCDline(:,:,ii) = [cos(beta*w/2) j*Z0*sin(beta*w/2); j*sin(beta*w/2)/Z0 cos(beta*w/2)];
    
    ABCD(:,:,ii) = ABCDgaphalf(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii)*ABCDgaphalf(:,:,ii);
    
end

end

