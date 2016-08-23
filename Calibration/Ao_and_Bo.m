% Calculates the error boxes Ao and Bo from the measured
% thru and line standards. 

 function[Ao,Bo] = Ao_and_Bo(sorted_evectors,tt,thrulength,sorted_prop2,...
    sq_size,sub_size,depth)

X = zeros(sq_size,sq_size,depth);
Ao = sorted_evectors;

for ii = 1:depth
    X(:,:,ii) = inv(sorted_evectors(:,:,ii));
end

% Calculates the reverse cascaded product of inv(Ao) and M1.

Z = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    Z(:,:,ii) = X(:,:,ii)*tt(:,:,ii);
end
YoM1 = reverse_cascade(Z);

% Calculates the known T-parameters of the thru standard using the
% previously determined propagation constants, and permutates the matrix.

N = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    for jj = 1:sub_size
        N(jj,jj,ii) = exp(-1*(sorted_prop2(jj,jj,ii))*thrulength);
    end
    for jj = sub_size+1:sq_size
        N(jj,jj,ii) = exp(1*(sorted_prop2(jj,jj,ii))*thrulength);
    end
end
NN = permutate(N);

% Calculates Bo.

Bo = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    Bo(:,:,ii) = YoM1(:,:,ii)*NN(:,:,ii);
end



