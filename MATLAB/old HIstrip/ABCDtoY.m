function [Y] = ABCDtoY(ABCD)
A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

Y11 = D/B;
Y12 = (B*C-A*D)/B;
Y21 = -1/B;
Y22 = A/B;
Y = [Y11 Y12; Y21 Y22];