function [ABCD2n] = ZtoABCD2n(Z)
%uses Faria's extension of ABCD matrices to 2n-port MTL structures.  Z is a
%2n x 2n matrix with form...
% [V1i; V2i; ... Vni; V1o; V2o;... Vno]=
%                               [Z]*[I1i; I2i; ... Ini; I1o; I2o; ... Ino]
% so you have a column vector V that lists all the voltages on the input
% side followed by all the voltages on the output side, and a column vector
% I that does the same for currents.
% Z, then, has the form [Zii Zio; Zoi Zoo], and we use that to find ABCD2n
% such that [Vi; Ii] = ABCD2n * [Vo; Io]

n = size(Z,1)/2;

Zii = Z(1:n, 1:n);
Zio = Z(1:n, (n+1):(2*n));
Zoi = Z((n+1):(2*n), 1:n);
Zoo = Z((n+1):(2*n),(n+1):(2*n));

A = Zii/Zoi;
C = inv(Zoi);
D = Zoi\Zoo;
B = (A*D.'-1)/(C.'); %requires passive

ABCD2n = [A B; C D];