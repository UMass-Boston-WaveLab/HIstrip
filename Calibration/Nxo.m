% Calculates the NX0 matrix. 

function[Nxo] = Nxo(Ao,Bo,Ko,dutT,depth)

% Calculates the preliminary matrices to get Nxo.
invAo = zeros(4,4,depth);
invKo = zeros(4,4,depth);
for ii = 1:depth
    invAo(:,:,ii) = inv(Ao(:,:,ii));
    invKo(:,:,ii) = inv(Ko(:,:,ii));
end

permBo = permutate(Bo);

% Calculates the Nxo matrix. See eqn. 53 in the multimode TRL paper.
Nxo = zeros(4,4,depth);

for ii = 1:depth
    Nxo(:,:,ii) = invKo(:,:,ii)*invAo(:,:,ii)*dutT(:,:,ii)*...
        permBo(:,:,ii)*Ko(:,:,ii);
end
