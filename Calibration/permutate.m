% Calculates permutation matrix as defined by Wojnowsky et al in the
% Multimode TRL paper. Extends operation to multidimensional matrices.

function [M_p] = permutate(M)
[k,l,m] = size(M);
I = eye(k/2);
empty = zeros(k/2,k/2);
P = zeros(k,k,m);

% This portion only works for 4x4 matrix, needs to be generalized.
for ii = 1:m
    P(:,:,ii) = [empty I; I empty];
end
for ii = 1:m
    M_p(:,:,ii) = P(:,:,ii)*M(:,:,ii)*P(:,:,ii);
end
