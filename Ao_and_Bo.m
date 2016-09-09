% Calculates the error boxes Ao and Bo from the measured
% thru and line standards. 

 function[Ao,Bo] = Ao_and_Bo(sorted_evectors,tt,thrulength,sorted_prop2,...
    sq_size,sub_size,depth)

invAo = zeros(sq_size,sq_size,depth);
Ao = sorted_evectors;

for ii = 1:depth
    invAo(:,:,ii) = inv(sorted_evectors(:,:,ii));
end

% Calculates the reverse cascaded product of inv(Ao) and M1.

Z = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    Z(:,:,ii) = invAo(:,:,ii)*tt(:,:,ii);
end
YoM1 = reverse_cascade(Z);

% Calculates the known T-parameters of the thru standard using the
% previously determined propagation constants, and permutates the matrix.
% Don't need a sign factor here, the gamma values already contain it.

N = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    for jj = 1:sq_size
        N(jj,jj,ii) = exp(sorted_prop2(jj,jj,ii)*thrulength);
    end
end
NN = permutate(N);

% Calculates Bo.

Bo = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    Bo(:,:,ii) = YoM1(:,:,ii)*NN(:,:,ii);
end



