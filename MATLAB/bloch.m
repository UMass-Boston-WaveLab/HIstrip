function [ blochZ, gamma ] = bloch( ABCD, L )
%BLOCH calculates the bloch impedance and propagation constant when given
%an ABCD matrix.  It can compute these vs. frequency if the ABCD matrix has
%dimensions 2 x 2 x N.

for ii = 1:size(ABCD,3)
    [V,D] = eig(ABCD(:,:,ii));
    temp = diag(D);
    if any(abs(temp~=1))
        [~, index] = min(abs(temp));
    else
        index = find(imag(log(temp))<0);
    end
   
    A=ABCD(1,1,ii);
    B = ABCD(1,2,ii);
    C = ABCD(2,1,ii);
    D = ABCD(2,2,ii);
    gamma(ii) = acosh((A+D)/2)/L;
    if real(gamma(ii))>0
        gamma(ii)=-gamma(ii);
    end
    blochZ(ii)=-B/(A-exp(-gamma(ii)*L));
    if real(blochZ(ii))<0
        blochZ(ii)=-blochZ(ii);
    end
end

blochZ=blochZ.';


