% Function accepts ordinary and generalized S-parameter matrices and
% returns ordinary and generalized T-parameter matrices.

function [T11, T12, T21, T22, T] = genS_to_genT(S11, S12, S21, S22, ...
    depth,sub_size)

% Creates empty T-parameter submatrices to fill. Calculates invS21 to use
% in the upcoming parameter conversion.

T11 = zeros(sub_size, sub_size, depth);
T12 = zeros(sub_size, sub_size, depth);
T21 = zeros(sub_size, sub_size, depth);
T22 = zeros(sub_size, sub_size, depth);

for ii = 1:depth
    T22(:,:,ii) = inv(S21(:,:,ii));
end

% Calculates T-parameter submatrices.
for ii = 1:depth
    T11(:,:,ii) = S12(:,:,ii) - S11(:,:,ii)*T22(:,:,ii)*S22(:,:,ii);
    T12(:,:,ii) = S11(:,:,ii)*T22(:,:,ii);
    T21(:,:,ii) = -T22(:,:,ii)*S22(:,:,ii);
end

T = [T11 T12; T21 T22];

end