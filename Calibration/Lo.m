% Calculates the L0 matrix using the previously determined G10 and G20
% matrices. 

function[L0,L10,L20,L12] = Lo(G10,G20,depth)

% Calculates L10 and L20. We can treat these as positive for now and 
% correct for possible sign errors in a later part of the algorithm.

ratio1 = zeros(1,1,depth);
ratio2 = zeros(1,1,depth);

for ii = 1:depth
    ratio1(1,1,ii) = G20(1,1,ii)/G10(1,1,ii);
    ratio2(1,1,ii) = G20(2,2,ii)/G10(2,2,ii);
end

L10 = zeros(1,1,depth);
L20 = zeros(1,1,depth);

for ii = 1:depth
    L10(1,1,ii) = sqrt(ratio1(1,1,ii));
    L20(1,1,ii) = sqrt(ratio2(1,1,ii));
end

% These formulas should result in equal values for each component of L12.
% Only one is needed; both are calculated as a check.

L12 = zeros(1,2,depth);

for ii = 1:depth
    L12(1,1,ii) = G20(1,2,ii)/G10(1,2,ii);
    L12(1,2,ii) = G20(2,1,ii)/G10(2,1,ii);
end

% Calculates the L0 matrix.

L0 = zeros(2,2,depth);
for ii = 1:depth
    L0(1,1,ii) = L10(1,1,ii);
    L0(2,2,ii) = L12(1,1,ii)/L10(1,1,ii);
end