function [ABCDL, ABCDgaphalf1, ABCDgaphalf2, ABCDline, ABCDt] = HISlayerABCD(w2,  g, h2, rad, epsr, f, viaflag)
%HISlayerABCD outputs a 2 x 2 x length(f) array of ABCD matrix vs.
%frequency.  Assumes the whole width of the substrate is involved in TEM
%mode.
w1 = 0.01; %depends on kind of antenna placed on top of HIS
h_ant = 0.02; %antenna height above substrate
w2 = .12; %patch width
h2 = 0.04; %ground to patch
g = 0.02; %patch spacing
rad = .0015875; %via radius
L = .24; %based on length of dipole at 300mHz which is .48lamba
Lsub = 1.12;
Wsub = 1.12;
startpos = 0;
eps1 = 1;
epsr = 2.2;
f = 300e6;
len = .14; %length of microstrip segment above patches 
mu0 = pi*4e-7;
omega = 2*pi*f;
a = .14; %edge to edge patch length
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1; %1 if HIS contains vias 0 otherwise
Lvia = viaL(h2, rad);
mu0= 4*pi*10^-7;
eps0=8.854*10^-12;

%Z0= sqrt(mu0/eps0)*h/(wsub*sqrt(epsr)); %characteristic Z for parallel plate WG TEM mode
Z0=microstripZ0_pozar(w2,h2,epsr);

[Cs,Cp1,Cp2] = microstripgapcap(epsr,g, h2, w2);
eff = epseff(w2,h2,epsr);

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
    

    ABCDline(:,:,ii) = [cos(beta*w2/2) j*Z0*sin(beta*w2/2); j*sin(beta*w2/2)/Z0 cos(beta*w2/2)];
    
    ABCD(:,:,ii) = ABCDgaphalf1(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii)*ABCDgaphalf2(:,:,ii);
    
    botn = floor((Lsub-L)/(w2+g))-1;
    ABCDt = (ABCD^botn)*ABCDgaphalf1*ABCDline*ABCDL*ABCDline;
end
      
  
end
