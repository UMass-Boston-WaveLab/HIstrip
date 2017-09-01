function [ Zin ] = prllHISstub_J( f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L1,L2)
%PRLLHISSTUB finds the two-terminal (upper to ground) input impedance of a
%combination of two HIS-backed stubs in parallel (i.e. a probe fed
%HIS-backed patch antenna)

sf = 0.05;                                                                 %frequency scale factor
w_ant = 0.01*sf;                                                           %depends on kind of antenna placed on top of HIS
h_ant = 0.02*sf;                                                           %antenna height above substrate
w2 = .12*sf;                                                               %patch width
H_sub = 0.04*sf;                                                              %ground to patch
g = 0.02*sf;                                                               %patch spacing
rad = .00025;
L1 = .24*sf;                                                               %based on length of dipole at 300mHz which is .48lamba
L2 = .24*sf;
L_sub = 1.12*sf;
W_sub = 1.12*sf;
startpos = 0;
eps1 = 1;
eps2 = 2.2;                                                             %length of microstrip ((a) for MTL section) segment above patches 
f  = 2e9:250e6:7e9;
a = .14*sf;                                                                %Length of unit cell
eps0 = 8.854e-12;
viaflag = 1;                                                               %1 if HIS contains vias 0 otherwise
startpos = 0;

Zin1 = HISstub_J(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L1,0);
Zin2 = HISstub_J(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L2,0);

for ii=1:length(f)
    Yin1=inv(Zin1(:,:,ii));
    Yin2=inv(Zin2(:,:,ii));
    Zinmat=inv(Yin1+Yin2);
    Zin(ii)=Zinmat(1,1);
end
Re = real(Zin)
figure 
plot (f,Re)
end

