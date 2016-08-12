% Function accepts ordinary and generalized S-parameter matrices and
% returns ordinary and generalized T-parameter matrices.

function [T11, T12, T21, T22, T] = genS_to_genT(S11, S12, S21, S22, depth, elements)

% Creates empty T-parameter submatrices to fill. Calculates invS21 to use
% in the upcoming parameter conversion.
T11 = zeros(elements, elements, depth);
T12 = zeros(elements, elements, depth);
T21 = zeros(elements, elements, depth);
T22 = zeros(elements, elements, depth);
X = zeros(elements, elements, depth);
for ii = 1:depth
    X(:,:,ii) = inv(S21(:,:,ii));
end

% Calculates T-parameter submatrices.
for ii = 1:depth
    T11(:,:,ii) = S12(:,:,ii) - S11(:,:,ii)*X(:,:,ii)*S22(:,:,ii);
    T12(:,:,ii) = S11(:,:,ii)*X(:,:,ii);
    T21(:,:,ii) = -X(:,:,ii)*S22(:,:,ii);
    T22 = X;
end
T = [T11 T12; T21 T22];
end

    

