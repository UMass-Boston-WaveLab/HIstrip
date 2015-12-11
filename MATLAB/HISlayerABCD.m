function [ABCD, ABCDL, ABCDgaphalf1, ABCDgaphalf2, ABCDline] = HISlayerABCD(w,  g, h, rad, epsr, f, viaflag)
%HISlayerABCD outputs a 2 x 2 x length(f) array of ABCD matrix vs.
%frequency.  Assumes the whole width of the substrate is involved in TEM
%mode.

Lvia = viaL(h, rad);



mu0= 4*pi*10^-7;
eps0=8.854*10^-12;

%Z0= sqrt(mu0/eps0)*h/(wsub*sqrt(epsr)); %characteristic Z for parallel plate WG TEM mode
Z0=microstripZ0_pozar(w,h,epsr);

[Cs,Cp1,Cp2] = microstripgapcap(epsr,g, h, w);
eff = epseff(w,h,epsr);

for ii = 1:length(f)
    omega = 2*pi*f(ii);
    beta = omega*sqrt(mu0*eps0*eff);
    if viaflag
        ABCDL(:,:,ii) = [1 0; 1/(j*omega*Lvia) 1];
    else
        ABCDL(:,:,ii)=eye(2);
    end
    
    ABCDCg = [1 1/((j*omega*2*Cs)); 0 1]; %consider adding real part here to include rad loss
    ABCDCp1 = [1 0; j*omega*Cp1 1];
    ABCDCp2 = [1 0; j*omega*Cp2 1];
    
    ABCDgaphalf1(:,:,ii)=ABCDCg*ABCDCp1;
    ABCDgaphalf2(:,:,ii)=ABCDCp2*ABCDCg;
    

    ABCDline(:,:,ii) = [cos(beta*w/2) j*Z0*sin(beta*w/2); j*sin(beta*w/2)/Z0 cos(beta*w/2)];
    
    ABCD(:,:,ii) = ABCDgaphalf1(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii)*ABCDgaphalf2(:,:,ii);
    
end

end

