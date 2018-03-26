function [ABCD, ABCDgaphalf1,ABCDline,ABCDL,ABCDgaphalf2] = nbynHISABCD(cap, cap0, eps2, a, g, h2, rad, viaflag, f)
%NBYNHISABCD outputs 2N x 2N MTL ABCD matrices for HIS unit slice, gap
%discontinuity (split in half), line section, and inductive via.

mu0=4*pi*10^-7;
eps0=8.854*10^-12;
N=size(cap,1);
w2=a-g;


%% MTL ABCD for multiple parallel HIS rows
ABCDline = nbynMTL(cap, cap0, f, a);

%% inductive via
ABCDL = nbynviaABCD(h2, rad, f, N,0);

%% Capacitive gap
[seriesChalf, shuntC] = nbyncapABCD(h2, w2, eps2, g, N, f,0);

ABCDgaphalf1 = seriesChalf*shuntC;
ABCDgaphalf2 = shuntC*seriesChalf;

%% unit slice ABCD
ABCD = ABCDgaphalf1*ABCDline*ABCDL*ABCDline*ABCDgaphalf2;