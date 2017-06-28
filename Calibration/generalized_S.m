% Function takes unformatted S-parameters read in from HFSS and converts 
% them into generalized scattering parameter matrices. Function produces an
% overall S-parameter matrix and four generalized submatrices.

function [S11, S12, S21, S22, S] = generalized_S(complexData, ...
    depth, sq_size)

% Reshapes the data from HFSS into a square matrix of size "sq_size".
% Retains the sq_size variable so this produces square S matrices of size 
% 2n x 2n, n = 1,2,...,etc. Submatrices (S11,S12,etc) are of size n x n.
S = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    row = complexData(ii,:);
    square = reshape(row, sq_size, sq_size);
    S(:,:,ii) = square;
end

% Breaks up matrix S into 4 smaller square submatrices, each of size
% "elements". For a 4x4 matrix, produces 2x2 submatrices.
if sq_size == 4
    S11 = zeros(2, 2, depth);
    S12 = zeros(2, 2, depth);
    S21 = zeros(2, 2, depth);
    S22 = zeros(2, 2, depth);
    for ii = 1:depth
        S11(:,:,ii) = S(1:2,1:2,ii);
        S12(:,:,ii) = S(1:2,3:4,ii);
        S21(:,:,ii) = S(3:4,1:2,ii);
        S22(:,:,ii) = S(3:4,3:4,ii);
    end
    % For a 2x2 matrix, produces 1x1 submatrices.
else 
    S11 = zeros(1,1,depth);
    S12 = zeros(1,1,depth);
    S21 = zeros(1,1,depth);
    S22 = zeros(1,1,depth);
    for ii = 1:depth
        S11(1,1,ii) = S(1,1,ii);
        S12(1,1,ii) = S(1,2,ii);
        S21(1,1,ii) = S(2,1,ii);
        S22(1,1,ii) = S(2,2,ii);
    end
end