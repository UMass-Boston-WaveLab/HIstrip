% Function accepts S-parameter matrices and returns T-parameter matrices.
% See Equation 154 in the Appendix for the derivation.

function [T] = genS_to_genT(S11, S12, S21, S22, depth)

% Creates empty T-parameter submatrices to fill. 
T11 = zeros(2, 2, depth);
T12 = zeros(2, 2, depth);
T21 = zeros(2, 2, depth);
T22 = zeros(2, 2, depth);

% Calculates T22 first.
for ii = 1:depth
    T22(:,:,ii) = inv(S21(:,:,ii));
end

% Calculates T-parameter submatrices.
for ii = 1:depth
    T11(:,:,ii) = S12(:,:,ii) - S11(:,:,ii)*T22(:,:,ii)*S22(:,:,ii);
    T12(:,:,ii) = S11(:,:,ii)*T22(:,:,ii);
    T21(:,:,ii) = -T22(:,:,ii)*S22(:,:,ii);
end

% Return the T-parameter matrix.
T = [T11 T12; T21 T22];