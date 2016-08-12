% Function takes S-parameters read in from HFSS and converts them into
% generalized scattering parameter matrices. The end result is a 2x2 matrix
% composed of smaller submatrices of size "elements".

function [S11, S12, S21, S22, elements] = generalized_S(M,depth,dimension)

% Reshapes the data from HFSS into a square matrix of size "dimension".

S = zeros(dimension,dimension,depth);
for ii = 1:depth
    row = M(ii, :);
    square = reshape(row, dimension, dimension);
    S(:,:,ii) = square;
end

% Breaks up matrix S into 4 smaller square submatrices, each of size
% "elements".

if dimension > 2
    elements = sqrt(dimension);
    S11 = zeros(elements,elements,depth);
    S12 = zeros(elements,elements,depth);
    S21 = zeros(elements,elements,depth);
    S22 = zeros(elements,elements,depth);
    for ii = 1:depth
        S11(:,:,ii) = S(1:elements,1:elements,ii);
        S12(:,:,ii) = S(1:elements,elements+1:end,ii);
        S21(:,:,ii) = S(elements+1:end,1:elements,ii);
        S22(:,:,ii) = S(elements+1:end,elements+1:end,ii);
    end
else 
    elements = 1;
    S11 = zeros(1,1,ii);
    S12 = zeros(1,1,ii);
    S21 = zeros(1,1,ii);
    S22 = zeros(1,1,ii);
    for ii = 1:depth
        S11(1,1,ii) = S(1,1,ii);
        S12(1,1,ii) = S(1,2,ii);
        S21(1,1,ii) = S(2,1,ii);
        S22(1,1,ii) = S(2,2,ii);
    end
end



