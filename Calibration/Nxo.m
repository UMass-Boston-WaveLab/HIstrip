% Calculates the NX0 matrix.

function[Nxo] = Nxo(Ao,Bo,Ko,dutT,sq_size,depth)

% Calculates the preliminary matrices to get Nxo.

invAo = zeros(sq_size,sq_size,depth);
invKo = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    invAo(:,:,ii) = inv(Ao(:,:,ii));
    invKo(:,:,ii) = inv(Ko(:,:,ii));
end

permBo = permutate(Bo);

% Calculates the Nxo matrix. See eqn 53 in the multimode TRL paper.

Nxo = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    Nxo(:,:,ii) = invKo(:,:,ii)*invAo(:,:,ii)*dutT(:,:,ii)*...
        permBo(:,:,ii)*Ko(:,:,ii);
end
