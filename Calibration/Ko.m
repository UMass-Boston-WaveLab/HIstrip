% Calculates the K0 matrix. This function requires that the reflect
% matrices are reciprocal, which was checked earlier in the sanitycheck
% function.

function[K0,K10,L21_root_hat,G10_transpose] = Ko(G10,G20,L0,depth)

% preallocate and transpose the g10 and g20 matrices
G10_transpose = zeros(2,2,depth);
G20_transpose = zeros(2,2,depth);
for ii = 1:depth
    G10_transpose(:,:,ii) = transpose(G10(:,:,ii));
    G20_transpose(:,:,ii) = transpose(G20(:,:,ii));
end

% preallocate g10_hat and g20_hat matrices
G10_hat = zeros(2,2,depth);
G20_hat = zeros(2,2,depth);

% calculate G10 hat and G20 hat matrices (eqn 66 and 67)
for ii = 1:depth
    G10_hat(:,:,ii) = L0(:,:,ii)*G10_transpose(:,:,ii) * inv(L0(:,:,ii)); % L0*G10*invL0
    G20_hat(:,:,ii) = L0(:,:,ii)*G20_transpose(:,:,ii) * inv(L0(:,:,ii));
end

% preallocate and calculate l21 root_hat matrix (see eqns 68 - 70)
L21_root_hat = zeros(1,1,depth);
for ii = 1:depth
    L21_root_hat(1,1,ii) = sqrt((G10(2,1,ii)/G10_hat(2,1,ii)));
end

% preallocate and calculate k10 matrix (eqn 70)
K10 = zeros(2,2,depth);
for ii = 1:depth
    K10(1,1,ii) = 1;
    K10(2,2,ii) = L21_root_hat(1,1,ii);
end

% preallocate and build Ko matrix from Lo and K10 (eqn 71)
K0 = zeros(4,4,depth);
for ii = 1:depth
    K0(1:2,1:2,ii) = K10(:,:,ii);
    K0(3:4,3:4,ii) = L0(:,:,ii)*K10(:,:,ii);
end