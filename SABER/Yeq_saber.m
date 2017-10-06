 function [Ys] = Yeq_saber(Y, A, B, C, D)
%% Finds the the equivilant addmittance matrix between that connects the ends of the antenna and substrate


% Accounting for the differences in voltages at the edge of the antenna and
% substrate results in new addmittance Yp
% Yx = [1 -1 0 0; 0 1 0 0; 0 0 1 -1; 0 0 0 1];
% Yx = [1 -1 0 0; 0 1 0 0; 0 0 1 -1; 0 0 0 1];
% Yp = Y*Yx;

Yp = Y;

% slot current admittance relations
YiAD = [1 0 0 0; 0 A 0 0; 0 0 1 0; 0 0 0 A];
YiB = [0 0 0 0; 0 B 0 0 ; 0 0 0 0; 0 0 0 B];
Yi = (YiAD - Yp*YiB);
Yix = 1\(Yi);

% % Voltage current addmitance relations
YvAD = [1 -1 0 0; -D 0 0 0; 0 0 1 -1; 0 0 0 -D];
YvC = [0 0 0 0; 0 C 0 0; 0 0 0 0; 0 0 0 C];
Yv = Yp*YvAD + YvC;
 
% %Equivilant addmitance matrix Yi^-1*Yv
Ys = Yix*Yv

end
