% Calculates the K0 matrix used to de-embed the DUT, using the reciprocal
% error networks parameters from the algorithm.

function[K0, K10, K20] = knought(Ao,L10,L20,depth)

% Calculates the necessary submatrices of Ao.
% Preallocates 2x2 matrices.
A011 = zeros(2,2,depth);
A012 = zeros(2,2,depth);
A021 = zeros(2,2,depth);
A022 = zeros(2,2,depth);

% Populates the 2x2 matrices.
for ii = 1:depth
    A011(:,:,ii) = Ao(1:2,1:2,ii);
    A012(:,:,ii) = Ao(1:2,3:4,ii);
    A021(:,:,ii) = Ao(3:4,1:2,ii);
    A022(:,:,ii) = Ao(3:4,3:4,ii);
end

% Preallocate and populate transpose of A022.
A022T = zeros(2,2,depth);
for ii = 1:depth
    A022T(:,:,ii) = transpose(A022(:,:,ii));
end

% Preallocate and populate inverse of A022.
X = zeros(2,2,depth);
for ii = 1:depth
    X(:,:,ii) = inv(A022(:,:,ii));
end

% K2L should be diagonal. This should be checked somehow when real data is
% used.
K2L = zeros(2,2,depth);
for ii = 1:depth
    K2L(:,:,ii) = inv(A022T(:,:,ii)*(A011(:,:,ii) - A012(:,:,ii)*...
        X(:,:,ii)*A021(:,:,ii)));
end

% Calculates the k10 and k20 constants. Like the L10,L20 constants, these
% are assumed to be the positive roots and a corrective sign factor is
% applied later in the algorithm.

% get the r1 and r2 values - the right hand side of the equation above
% (K2L)
R1 = zeros(1,1,depth);
R2 = zeros(1,1,depth);
for ii = 1:depth
    R1(1,1,ii) = K2L(1,1,ii);
    R2(1,1,ii) = K2L(2,2,ii);
end

% preallocate and calculate K10, K20 constants to within a sign
K10 = zeros(1,1,depth);
K20 = zeros(1,1,depth);
for ii = 1:depth
    K10(1,1,ii) = sqrt(R1(1,1,ii)/L10(1,1,ii));
    K20(1,1,ii) = sqrt(R2(1,1,ii)/L20(1,1,ii));
end

% preallocate and calculate K0 matrix, which is fully known at this point
K0 = zeros(4,4,depth);
for ii = 1:depth
    K0(1,1,ii) = K10(1,1,ii);
    K0(2,2,ii) = K20(1,1,ii);
    K0(3,3,ii) = L10(1,1,ii)*K10(1,1,ii);
    K0(4,4,ii) = L20(1,1,ii)*K20(1,1,ii);
end