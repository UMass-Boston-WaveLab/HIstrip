% Calculates reverse cascade matrix as defined by Wojnowsky et al in the
% Multimode TRL paper.

function [reverse] = reverse_cascade(M)
[k,l,m] = size(M);
for ii = 1:m
    X(:,:,ii) = inv(M(:,:,ii));
end
reverse = permutate(X);
