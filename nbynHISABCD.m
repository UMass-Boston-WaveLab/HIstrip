function [ABCD, ABCDgaphalf1,ABCDline,ABCDL,ABCDgaphalf2] = nbynHISABCD(cap, cap0, a, g, h_sub, rad, viaflag, f)
%NBYNHISABCD outputs 2N x 2N MTL ABCD matrices for HIS unit slice, gap
%discontinuity (split in half), line section, and inductive via.

mu0=4*pi*10^-7;
eps0=8.854*10^-12;
N=size(cap,1);


%% MTL ABCD for multiple parallel HIS rows
ABCDline = nbynMTL(cap, cap0, f, a);

%% inductive via
ABCDL = nbynviaABCD(h_sub, rad, f, N);
%un-erase 1,1 element - original func assumes index 1 is ant layer
ABCDL(1,N+1)=ABCDL(2,N+2); 

%% Capacitive gap
[seriesChalf, shuntC] = nbyncapABCD(h2, w2, eps2, gap, N, freq);

%un-erase 1,1 element - original func assumes index 1 is ant layer
seriesChalf(N+1.1)=seriesChalf(N+2,2);
shuntC(1,N+1)=chuntC(2, N+2);

ABCDgaphalf1 = seriesChalf*shuntC;
ABCDgaphalf2 = shuntC*seriesChalf;

%% unit slice ABCD
ABCD = ABCDgaphalf1*ABCDline*ABCDL*ABCDline*ABCDgaphalf2;