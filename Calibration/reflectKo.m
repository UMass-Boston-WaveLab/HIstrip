% Calculates the K0 matrix. This function requires that the reflect
% matrices are reciprocal, which was checked earlier in the sanitycheck
% function.

function[K0] = reflectKo(G10,G20,G10new,G20new,L0,sq_size,sub_size,depth)

% Performs the calculations needed to populate the K10 matrix.

G10_transpose = zeros(sub_size,sub_size,depth);
G20_transpose = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    G10_transpose(:,:,ii) = transpose(G10new(:,:,ii));
    G20_transpose(:,:,ii) = transpose(G20new(:,:,ii));
end

G10_hat = zeros(sub_size,sub_size,depth);
G20_hat = zeros(sub_size,sub_size,depth);
invL0 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    invL0(:,:,ii) = inv(L0(:,:,ii));
end

for ii = 1:depth
    G10_hat(:,:,ii) = L0(:,:,ii)*G10_transpose(:,:,ii)*invL0(:,:,ii);
    G20_hat(:,:,ii) = L0(:,:,ii)*G20_transpose(:,:,ii)*invL0(:,:,ii);
end

L21_root_hat = zeros(1,1,depth);

for ii = 1:depth
    L21_root_hat(1,1,ii) = sqrt((G10new(2,1,ii)/G10_hat(2,1,ii)));
end

K10 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    K10(1,1,ii) = 1;
    K10(2,2,ii) = L21_root_hat(1,1,ii);
end

% Builds the Ko matrix from Lo and K10.

K0 = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    K0(1:sub_size,1:sub_size,ii) = K10(:,:,ii);
    K0(sub_size+1:sq_size,sub_size+1:sq_size,ii) = L0(:,:,ii)*K10(:,:,ii);
end


