% Function takes S-parameters read in from HFSS and converts them into
% generalized scattering parameter matrices. The end result is a 2x2 matrix
% composed of smaller submatrices of size "elements".

function [S11, S12, S21, S22, sub_size] = generalized_S(M,depth,sq_size)

% Reshapes the data from HFSS into a square matrix of size "dimension".

S = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    row = M(ii, :);
    square = reshape(row, sq_size, sq_size);
    S(:,:,ii) = square;
end

% Breaks up matrix S into 4 smaller square submatrices, each of size
% "elements".

if sq_size > 2
    sub_size = (sq_size)/2;
    S11 = zeros(sub_size,sub_size,depth);
    S12 = zeros(sub_size,sub_size,depth);
    S21 = zeros(sub_size,sub_size,depth);
    S22 = zeros(sub_size,sub_size,depth);
    for ii = 1:depth
        S11(:,:,ii) = S(1:sub_size,1:sub_size,ii);
        S12(:,:,ii) = S(1:sub_size,sub_size+1:end,ii);
        S21(:,:,ii) = S(sub_size+1:end,1:sub_size,ii);
        S22(:,:,ii) = S(sub_size+1:end,sub_size+1:end,ii);
    end
else 
    sub_size = 1;
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



