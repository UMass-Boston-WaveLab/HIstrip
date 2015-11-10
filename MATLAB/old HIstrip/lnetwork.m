function [ X, B ] = lnetwork( ZL, Z0 )
%LNETWORK Implements L matching network.  Pozar 2nd ed. p. 253

RL = real(ZL);
XL = imag(ZL);


if real(ZL/Z0)>1
    B(1) = (XL+sqrt(RL/Z0)*sqrt(RL^2+XL^2-Z0*RL))/(RL^2+XL^2);
    B(2) = (XL-sqrt(RL/Z0)*sqrt(RL^2+XL^2-Z0*RL))/(RL^2+XL^2);
    X = 1./B+XL*Z0/RL-Z0./(B*RL);
else
    B(1) = sqrt((Z0-RL)/RL)/Z0;
    X(1) = sqrt(RL*(Z0-RL))-XL;
    B(2) = -B(1);
    X(2) = -X(1);
end


end

