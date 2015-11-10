function [Zin] = getZinfromABCD(ABCD, ZL)
A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

if ~isinf(ZL)
    Zin = (A*ZL+B)/(C*ZL+D);
else
    Zin = A/C;
end