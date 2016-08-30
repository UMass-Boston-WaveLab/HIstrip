% Calculates the L0 matrix using the previously determined G10 and G20
% matrices. 

function[L0,L10,L20,L12] = Lo(G10,G20,sub_size,depth)

% The algorithm requires that L1 and L2 be the known positive or negative
% roots of the ratio matrices. Every element of L1 and L2 should be
% positive here and a corrective constant will be applied later in the
% algorithm. 

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

% Only one of these values needs to be calculated. Both are being
% calculated right now as a method of checking if the coding/data are
% correct.

L12 = zeros(1,2,depth);

for ii = 1:depth
    L12(1,1,ii) = G20(1,2,ii)/G10(1,2,ii);
    L12(1,2,ii) = G20(2,1,ii)/G10(2,1,ii);
end

% Calculates the L0 matrix.

L0 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    L0(1,1,ii) = L10(1,1,ii);
    L0(2,2,ii) = L12(1,1,ii)/L10(1,1,ii);
end



