% Calculates the error boxes Ao and Bo from the measured
% thru and line standards. 

function[invAo, Bo] = Bo(Ao,tt,thrulength,sorted_prop2,depth)

% Preallocating and inverting Ao matrix.
invAo = zeros(4,4,depth);
for ii = 1:depth
    invAo(:,:,ii) = inv(Ao(:,:,ii));
end

% Calculates the reverse cascaded product of inv(Ao) and M1.
Z = zeros(4,4,depth);
for ii = 1:depth
    Z(:,:,ii) = invAo(:,:,ii)*tt(:,:,ii);
end
YoM1 = reverse_cascade(Z);

% Calculates the known T-parameters of the thru standard using the
% previously determined propagation constants, and permutates the matrix.
N = zeros(4,4,depth);
for ii = 1:depth
    for jj = 1:4
        N(jj,jj,ii) = exp(sorted_prop2(jj,jj,ii)*thrulength);
    end
end
NN = permutate(N);

% Calculates Bo.
Bo = zeros(4,4,depth);
for ii = 1:depth
    Bo(:,:,ii) = YoM1(:,:,ii)*NN(:,:,ii);
end