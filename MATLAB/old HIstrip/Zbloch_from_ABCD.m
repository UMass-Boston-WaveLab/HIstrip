function [Zbloch] = Zbloch_from_ABCD(ABCD)
A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

Zbloch = -2*B/(A-D-sqrt((A+D)^2-4));
if real(Zbloch)<0
    Zbloch = -2*B/(A-D+sqrt((A+D)^2-4));
end