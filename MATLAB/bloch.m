function [ blochZ, gamma ] = bloch( ABCD, L )
%BLOCH calculates the bloch impedance and propagation constant when given
%an ABCD matrix.  It can compute these vs. frequency if the ABCD matrix has
%dimensions 2 x 2 x N.

for ii = 1:size(ABCD,3)
    [V,D] = eig(ABCD(:,:,ii));
    temp = diag(D);
    if any(imag(temp)~=0)
        %choosing the right eigenvalue
        index = find(imag(log(temp))<0);
    else
        [~, index] = min(abs(temp));
    end
    gamma(ii) = -log(temp(index))/L;
    A=ABCD(1,1,ii);
    B = ABCD(1,2,ii);
    C = ABCD(2,1,ii);
    D = ABCD(2,2,ii);
    blochZ(ii) = -2*B/(A-D-sqrt((A+D)^2-4));
end



