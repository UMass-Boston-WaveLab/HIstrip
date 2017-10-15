function [ABCDL, ABCDgaphalf1, ABCDgaphalf2, ABCDline, ABCDt] = HISlayerABCD(w2, g, h_sub, rad, eps2, f, viaflag, eps1, L_sub, w_ant)
%HISlayerABCD outputs a 2 x 2 x length(f) array of ABCD matrix vs.
%frequency.  Assumes the whole width of the substrate is involved in TEM
%mode.

mu0=4*pi*10^-7;
eps0=8.854*10^-12;

Lvia = viaL(h_sub, rad);
L_ant = w_ant;

%Z0= sqrt(mu0/eps0)*h/(wsub*sqrt(epsr)); %characteristic Z for parallel plate WG TEM mode
Z0 = microstripZ0_pozar(w2,h_sub,eps2);

[Cs,Cp1,Cp2] = microstripgapcap(eps2,g, h_sub, w2);
eff = epseff(w2,h_sub,eps2);

for ii = 1:length(f)
    omega = 2*pi*f(ii);
    beta = omega*sqrt(mu0*eps0*eff);
    if viaflag
        ABCDL(:,:,ii) = [1 0; 1/(1i*omega*Lvia) 1];
    else
        ABCDL(:,:,ii)=eye(2);
    end
    
    ABCDCg = [1 1/((1i*omega*2*Cs)); 0 1]; %consider adding real part here to include rad loss
    ABCDCp1 = [1 0; 1i*omega*Cp1 1];
    ABCDCp2 = [1 0; 1i*omega*Cp2 1];
    
    ABCDgaphalf1(:,:,ii)=ABCDCg*ABCDCp1;
    ABCDgaphalf2(:,:,ii)=ABCDCp2*ABCDCg;
    

    ABCDline(:,:,ii) = [cos(beta*w2/2) 1i*Z0*sin(beta*w2/2); 1i*sin(beta*w2/2)/Z0 cos(beta*w2/2)];
    
    ABCD(:,:,ii) = ABCDgaphalf1(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii)*ABCDgaphalf2(:,:,ii);
    
    botn = floor((L_sub-L_ant)/(2*w2+g))-1; %Number of HISlayer Cells %include prefix - 1/2 the antenna?
    
    ABCDt = (ABCD^botn)*ABCDgaphalf1*ABCDline*ABCDL*ABCDline;
end
      
  
end
