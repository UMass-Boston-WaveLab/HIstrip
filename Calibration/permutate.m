% Calculates permutation matrix as defined by Wojnowsky et al in the
% Multimode TRL paper. Extends operation to multidimensional matrices.

function [M_p] = permutate(M)
[k,l,m] = size(M);
I = eye(2);
O = zeros(2,2);
P = zeros(4,4,m);
for ii = 1:m
    P(:,:,ii) = [O I; I O];
end
for ii = 1:m
    M_p(:,:,ii) = P(:,:,ii)*M(:,:,ii)*P(:,:,ii);
end
