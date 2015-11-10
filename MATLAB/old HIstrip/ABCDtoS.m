function [S] = ABCDtoS(ABCD, Z0)
A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

S11 = (A+B/Z0-C*Z0-D)/(A+B/Z0+C*Z0+D);
S12 = 2*(A*D-B*C)/(A+B/Z0+C*Z0+D);
S21 = 2/(A+B/Z0+C*Z0+D);
S22 =(-A+B/Z0-C*Z0+D)/(A+B/Z0+C*Z0+D);

S = [S11 S12; S21 S22];