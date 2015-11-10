function [gamma] = valerio_bloch(ABCD_a, ABCD_b, na, nb, a)

[gamma_a, Z_a] = blochgamma(ABCD_a, a*na);
[gamma_b, Z_b] = blochgamma(ABCD_b, a*nb);

degeneracy_a = (0:(2*pi/(na)):(0.9999999*2*pi))/a; %exclude the last point
degeneracy_b = (0:(2*pi/(nb)):(0.9999999*2*pi))/a; %it's the same as 0

if abs(real(gamma_a)-real(gamma_b))>2*pi/a
    gamma_a = gamma_a+2*pi*floor((real(gamma_b)-real(gamma_a))/(2*pi/a))/a;
end
options_a = kron((real(gamma_a))+degeneracy_a+j*imag(gamma_a), ones(size(degeneracy_b)));
options_b = kron(ones(size(degeneracy_a)), (real(gamma_b))+degeneracy_b+j*imag(gamma_b));
test = abs(real(options_a)-real(options_b));
[~,ansindex] = min(test);

%two sim results might not be exactly the same so let's clean up the
%data with some averaging?
err = abs(real(options_a(ansindex)-options_b(ansindex)));
tol = max(2*pi/na, 2*pi/nb)/a;
if err>tol
    warning('Large disagreement between datasets \n')
end
gamma = (options_a(ansindex)+ options_b(ansindex))/2;
end
