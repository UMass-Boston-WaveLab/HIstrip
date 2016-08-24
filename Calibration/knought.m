% Calculates the K0 matrix used to de-embed the DUT, using the reciprocal
% error networks parameters from the algorithm.

function[K0] = knought(Ao,L10,L20,sq_size,sub_size,depth)

% Calculates the necessary submatrices of Ao.
A011 = zeros(sub_size,sub_size,depth);
A012 = zeros(sub_size,sub_size,depth);
A021 = zeros(sub_size,sub_size,depth);
A022 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
A011(:,:,ii) = Ao(1:sub_size,1:sub_size,ii);
A012(:,:,ii) = Ao(1:sub_size,sub_size+1:sq_size,ii);
A021(:,:,ii) = Ao(sub_size+1:sq_size,1:sub_size,ii);
A022(:,:,ii) = Ao(sub_size+1:sq_size,sub_size+1:sq_size,ii);
end

A022T = zeros(sub_size,sub_size,depth);

for ii = 1:depth
A022T(:,:,ii) = transpose(A022(:,:,ii));
end

X = zeros(sub_size,sub_size,depth);

for ii = 1:depth
X(:,:,ii) = inv(A022(:,:,ii));
end

% K2L should be diagonal. This should be checked somehow when real data is
% used.

K2L = zeros(sub_size,sub_size,depth);

for ii = 1:depth
K2L(:,:,ii) = inv(A022T(:,:,ii)*(A011(:,:,ii) - A012(:,:,ii)*...
    X(:,:,ii)*A021(:,:,ii)));
end

% Calculates the k10 and k20 constants. Like the L10,L20 constants, these
% are assumed to be the positive roots and a corrective sign factor is
% applied later in the algorithm.

R1 = zeros(1,1,depth);
R2 = zeros(1,1,depth);

for ii = 1:depth
    R1(1,1,ii) = K2L(1,1,ii);
    R2(1,1,ii) = K2L(2,2,ii);
end

K10 = zeros(1,1,depth);
K20 = zeros(1,1,depth);

for ii = 1:depth
    K10(1,1,ii) = sqrt(R1(1,1,ii)/L10(1,1,ii));
    K20(1,1,ii) = sqrt(R2(1,1,ii)/L20(1,1,ii));
end

K0 = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    K0(1,1,ii) = K10(1,1,ii);
    K0(2,2,ii) = K20(1,1,ii);
    K0(3,3,ii) = L10(1,1,ii)*K10(1,1,ii);
    K0(4,4,ii) = L20(1,1,ii)*K20(1,1,ii);
end

