function [Q] = calcQ(Z, omega)
R = real(Z);
X = imag(Z);
Q = omega./(2*R) .* sqrt(gradient(R, omega).^2+(gradient(X,omega)+X./omega).^2);
end