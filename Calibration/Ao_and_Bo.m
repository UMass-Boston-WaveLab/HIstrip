% Calculates the partially known error boxes Ao and Bo from the measured
% thru and line standards. 

function[Ao,Bo] = Ao_and_Bo(Yo,thrufile,thrulength,gamma)

[k,l,m] = size(Yo);
X = zeros(4,4,m);
Ao = Yo;

for ii = 1:m
    X(:,:,ii) = inv(Yo(:,:,ii));
end

% Reads in the measured thru 4x4 S-parameters and converts them to
% T-parameters. This is probably redundant given other functions/code in
% the calibration module.

[TS11,TS12,TS21,TS22,TS] = readin_4x4S(thrufile);
[~,~,~,~,TT] = S_to_T(TS11,TS12,TS21,TS22,TS);

% Calculates the reverse cascaded product of inv(Ao) and M1.

Z = zeros(4,4,m);
for ii = 1:m
    Z(:,:,ii) = X(:,:,ii)*TT(:,:,ii);
end
ZZ = reverse_cascade(Z);

% Calculates the known T-parameters of the thru standard using the
% previously determined propagation constants, and permutates the matrix.

N = zeros(4,4,m);
for ii = 1:m
    for jj = 1:2
        N(jj,jj,ii) = exp(-(gamma(jj,jj,ii))*thrulength);
    end
    for jj = 3:4
        N(jj,jj,ii) = exp(gamma(jj,jj,ii)*thrulength);
    end
end
NN = permutate(N);

% Calculates Bo.

Bo = zeros(4,4,m);
for ii = 1:m
    Bo(:,:,ii) = ZZ(:,:,ii)*NN(:,:,ii);
end



