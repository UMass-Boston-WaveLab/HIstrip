function [Z] = ABCD4toZ(ABCD)
A = ABCD(1:2, 1:2);
B = ABCD(1:2, 3:4);
C = ABCD(3:4, 1:2);
D = ABCD(3:4, 3:4);
Z = [A,B; C,D];
% Zii = C\A;
% Zio = (C\A)*D-B;
% Zoi = 1\(C);
% % Zoi = inv(C);
% % Zoi = I/(C);
% Zoo = C\D;
% 
% Z = [Zii Zio; Zoi Zoo];
end