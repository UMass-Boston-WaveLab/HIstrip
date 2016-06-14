function [Ys] = Yeq(w_ant, h_ant, L_ant, w_sub, h_sub, L_sub, freq)
%% Finds the the equivilant addmittance matrix between that connects the ends of the antenna and substrate

w_ant = .01;
h_ant = .02;
L_ant = .48; 
w_sub = 1.12;
L_sub = 1.12; %these values need to be changed to reflect the distance from last T structure to edge of substrate
h_sub = 0.04;
g = .02;
w2 = .12; 
rad = .0015875;
viaflag = 1; 
eps1 = 1;
eps2 = 2.2;
freq = 300e6;


[Y] = HISantYmat(w_ant, h_ant, L_ant,eps1, w_sub, h_sub, L_sub,eps2, freq);
[ABCDt] = HISlayerABCD(w2,  g, rad, eps2, freq, viaflag);

A = ABCDt(1,1);
B = ABCDt(1,2);
C = ABCDt(2,1);
D = ABCDt(2,2);

% Accounting for the differences in voltages at the edge of the antenna and
% substrate results in new addmittance Yp
Yx = [1 -1 0 0; 0 1 -1 0; 0 0 1 0; 0 0 0 1];
Yp = Y*Yx;

% slot current admittance relations
YiAD = [1 0 0 0; 0 1 0 0; 0 0 A 0; 0 0 0 -D];
YiB = [0 0 0 0; 0 0 0 0; 0 0 -B 0; 0 0 0 B];
Yi = (YiAD - Yp*YiB);
Yix = inv(Yi);

% Voltage current addmitance relations
YvAD = [1 0 0 0; 0 1 0 0; 0 0 D 0; 0 0 0 A];
YvC = [0 0 0 0; 0 0 0 0; 0 0 C 0; 0 0 0 C];
Yv = Yp*YvAD + YvC;

%Equivilant addmitance matrix Yi^-1*Yv
Ys = Yix*Yv;

end
