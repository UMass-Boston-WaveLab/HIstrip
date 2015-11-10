function [Z] = ABCDtoZ(ABCD)
A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

Z11 = A/C;
Z12 = (A*D-B*C)/C;
Z21 = 1/C;
Z22 = D/C;

Z = [Z11 Z12; Z21 Z22];