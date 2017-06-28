% Calculates the error boxes Ao and Bo from the measured
% thru and line standards. 

function [Bo] = Bo(Ao, thruT, thruLength, sortedPropagationConstants, depth)

% Calculates the reverse cascaded product of inv(Ao) and the measured thru
% cascade matrix (see eqn 28 - 29).
invAoM1 = zeros(4,4,depth);
for ii = 1:depth
    invAoM1(:,:,ii) = Ao(:,:,ii) \ thruT(:,:,ii); % inv(Ao) * M1
end
invAoM1ReverseCascaded = reverse_cascade(invAoM1);

% Calculates the actual T-parameters of the thru standard using the
% previously determined propagation constants, and permutates the matrix.
% See equations 5, 14, and 29 for the derivations.
N1 = zeros(4,4,depth);
for ii = 1:depth
    for jj = 1:4
        N1(jj,jj,ii) = exp(sortedPropagationConstants(jj,jj,ii)*thruLength);
    end
end
N1Permutated = permutate(N1);

% Calculates Bo.
Bo = zeros(4,4,depth);
for ii = 1:depth
    Bo(:,:,ii) = invAoM1ReverseCascaded(:,:,ii)*N1Permutated(:,:,ii);
end