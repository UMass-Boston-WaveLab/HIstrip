function [Ys] = Yeq(Y, A, B, C, D)
%% Finds the the equivilant addmittance matrix between that connects the ends of the antenna and substrate


% Y = HISantYmat_1(f, w_ant, ~, h_ant, H_sub, ~, eps1, eps2, ~, L_ant, ~ , L_sub, W_sub, ~);
% ABCDt = HISlayerABCD(f, ~, w2, ~, H_sub, rad, ~, ~, g, L_ant, ~, L_sub, ~, viaflag);

%Y = sym('Y',[4 4])

% A = ABCDt(1,1);
% B = ABCDt(1,2);
% C = ABCDt(2,1);
% D = ABCDt(2,2);



% Accounting for the differences in voltages at the edge of the antenna and
% substrate results in new addmittance Yp
Yx = [1 -1 0 0; 0 1 0 0; 0 0 1 -1; 0 0 0 1];
Yp = Y*Yx;

% slot current admittance relations
YiAD = [1 0 0 0; 0 A 0 0; 0 0 1 0; 0 0 0 -D];
YiB = [0 0 0 0; 0 -B 0 0 ; 0 0 0 0; 0 0 0 B];
Yi = (YiAD - Yp*YiB);
Yix = inv(Yi);

% % Voltage current addmitance relations
YvAD = [1 0 0 0; 0 -D 0 0; 0 0 1 0; 0 0 0 A];
YvC = [0 0 0 0; 0 C 0 0; 0 0 0 0; 0 0 0 -C];
Yv = Yp*YvAD + YvC;
 
% %Equivilant addmitance matrix Yi^-1*Yv
Ys = Yix*Yv;

end
