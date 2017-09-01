function [Z] = ABCD4toZ(ABCD)
A = ABCD(1:2, 1:2);
B = ABCD(1:2, 3:4);
C = ABCD(3:4, 1:2);
D = ABCD(3:4, 3:4);

Zii = A/C;
Zio = (A/C)*D-B;
Zoi = inv(C);
Zoo = C\D;

Z = [Zii Zio; Zoi Zoo];