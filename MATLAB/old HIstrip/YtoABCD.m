function [ABCD] = YtoABCD(Y);
Y11 = Y(1,1);
Y12 = Y(1,2);
Y21 = Y(2,1);
Y22 = Y(2,2);

A = -Y22/Y21;
B = -1/Y21;
C = (-Y11*Y22+Y12*Y21)/Y21;
D = -Y11/Y21;

ABCD = [A B; C D];