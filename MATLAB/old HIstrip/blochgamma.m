function [gamma, Zbloch] = blochgamma(ABCD, a)

% [V, D] = eig(ABCD);
% prop = sort(diag(D));


A = ABCD(1,1);
B = ABCD(1,2);
D = ABCD(2,2);
gamma = acosh((A+D)/2)/a;
Zbloch = -2*B/(A-D-sqrt((A+D)^2-4));
if real(Zbloch)<0
    Zbloch = 2*B/(A-D-sqrt((A+D)^2-4));
end