% Assumes that the error networks A and B in the calibration algorithm are
% identical. Uses A and B to calculate the values of the L matrix. These
% values have the correct sign already. See section III.B in the Wojnowski
% et al paper for the equations/derivation.

function[L1, L2, L3, L4] = identicalErrorNetworksLo(Ao, Bo, depth)

% Creates 2x2 submatrices of Ao and Bo and populates them with the
% correct values.

% Create A submatrices
A011 = zeros(2,2,depth);
A012 = zeros(2,2,depth);
A021 = zeros(2,2,depth);
A021 = zeros(2,2,depth);
% Create B submatrices
B011 = zeros(2,2,depth);
B012 = zeros(2,2,depth);
B021 = zeros(2,2,depth);
B022 = zeros(2,2,depth);

% Populate matrices
for ii = 1:depth
    % the A submatrices
    A011(:,:,ii) = Ao(1:2,1:2,ii);
    A012(:,:,ii) = Ao(1:2,3:4,ii);
    A021(:,:,ii) = Ao(3:4,1:2,ii);
    A022(:,:,ii) = Ao(3:4,3:4,ii);
    % the B submatrices
    B011(:,:,ii) = Bo(1:2,1:2,ii);
    B012(:,:,ii) = Bo(1:2,3:4,ii);
    B021(:,:,ii) = Bo(3:4,1:2,ii);
    B022(:,:,ii) = Bo(3:4,3:4,ii);
end

% Generate the L matrix. There are four different equations for L. This
% function calculates them all - they should be equal, with off-diagonal
% terms zero. In reality, they should be roughly equal, and off-diagonal
% terms should be negligible.

% Preallocate the four matrices
L1 = zeros(2,2,depth);
L2 = zeros(2,2,depth);
L3 = zeros(2,2,depth);
L4 = zeros(2,2,depth);

% Perform the calculations
for ii = 1:depth
    L1(:,:,ii) = B011(:,:,ii) \ A011(:,:,ii); % (inv(Bo11) * Ao11)
    L2(:,:,ii) = A012(:,:,ii) \ B012(:,:,ii);
    L3(:,:,ii) = B021(:,:,ii) \ A021(:,:,ii);
    L4(:,:,ii) = A022(:,:,ii) \ B022(:,:,ii);
end