function [ABCD] = ZtoABCD(Z)
Z11 = Z(1,1);
Z12 = Z(1,2);
Z21 = Z(2,1);
Z22 = Z(2,2);

A = Z11/Z21;
B = (Z11*Z22-Z12*Z21)/Z21;
C = 1/Z21;
D = Z22/Z21;

ABCD = [A B; C D];