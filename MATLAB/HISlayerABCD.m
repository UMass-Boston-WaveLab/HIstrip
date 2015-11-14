function [ABCD] = HISlayerABCD(w, g, h, rad, epsr, f )
%HISlayerABCD outputs a 2 x 2 x length(f) array of ABCD matrix vs.
%frequency.  Assumes square patches

Lvia = viaL(h, rad);
[Cs,Cp1,Cp2] = microstripgapcap(epsr,g, h, w);
Z0= microstripZ0_2(w,h,epsr);
eff = epseff(w,h,epsr);
mu0= 4*pi*10^-7;
eps0=8.854*10^-12;
for ii = 1:length(f)
    omega = 2*pi*f(ii);
    beta = omega*sqrt(mu0*eps0*eff);
    
    ABCDL = [1 0; 1/(j*omega*Lvia) 1];
    ABCDCgaphalf = [1 1/((j*omega*2*Cs)); 0 1]; %removed +real(harringtonslotY(f(ii), g/2, w)
    ABCDCp1 = [1 0; j*omega*Cp1 1];
    ABCDCp2 = [1 0; j*omega*Cp2 1];
    ABCDline = [cos(beta*w/2) j*Z0*sin(beta*w/2); j*sin(beta*w/2)/Z0 cos(beta*w/2)];
    
    ABCD(:,:,ii) = ABCDCgaphalf*ABCDCp1*ABCDline*ABCDL*ABCDline*ABCDCp2*ABCDCgaphalf;
    
end

end

