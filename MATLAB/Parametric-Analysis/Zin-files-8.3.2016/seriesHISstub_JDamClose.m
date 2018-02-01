function [ Zin ] = seriesHISstub_J( f, w_ant, w2, h_ant, rad, eps0, eps1, eps2, g, L1,L2, startpos, visflag, L_sub, W_sub, H_sub, a, c, mu0)
%SERIESHISSTUB finds the two-terminal (upper to ground) input impedance of a
%combination of two HIS-backed stubs in series (i.e. differential feed like
%a dipole)

%//
% sf = 0.05;                                                                 %frequency scale factor
% w_ant = 0.01*sf;                                                           %depends on kind of antenna placed on top of HIS
% h_ant = 0.02*sf;                                                           %antenna height above substrate
% w2 = .12*sf;                                                               %patch width
% H_sub = 0.04*sf;                                                              %ground to patch
% g = 0.02*sf;                                                               %patch spacing
% rad = .00025;
% L1 = .24*sf;                                                               %based on length of dipole at 300mHz which is .48lamba
% L2 = .24*sf;
% L_sub = 1.12*sf;
% W_sub = 1.12*sf;
% startpos = 0;                                                              %length of microstrip ((a) for MTL section) segment above patches 
% a = .14*sf;                                                                %Length of unit cell
% sf = 0.05;                                                                 %frequency scale factor

w_ant = 0.0005;                                                           %depends on kind of antenna placed on top of HIS
h_ant = 0.001;                                                           %antenna height above substrate
w2 = 0.006;                                                               %patch width
H_sub = 0.002;                                                              %ground to patch
g = 0.001;                                                               %patch spacing
rad = .00025;
L1 = 0.012;                                                               %based on length of dipole at 300mHz which is .48lamba
L2 = 0.012;
L_sub = 0.056;
W_sub = 0.056;
startpos = 0;                                                              %length of microstrip ((a) for MTL section) segment above patches 
a = 0.007;                                                                %Length of unit cell

eps0 = 8.854e-12;
eps1 = 1;
eps2 = 2.2;       
viaflag = 1;                                                               %1 if HIS contains vias 0 otherwise
startpos = 0;                                                              
mu0 = pi*4e-7;
f = 2e9:250e6:7e9;
c = 3e8;

parfor ii=1:length(f)
    
        Zin1(:,:,ii) = HISstub_J(f(ii), w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L1, startpos, viaflag, 4*a,8*a, H_sub,  a)
        Zin2(:,:,ii) = HISstub_J(f(ii), w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L2, startpos, viaflag, 4*a,8*a, H_sub,  a)
        Y =inv(Zin1(:,:,ii) +  Zin2(:,:,ii));
        Zin(ii,:,:) = 1/Y(1,1);
        f(:)
  
end
        
Re = real(Zin);
Im = imag(Zin);
X = sqrt(Re.^2+Im.^2);
figure 
plot (f, X,'r')


   
 

end

