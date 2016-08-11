% Calculates known G10 and G20 matrices from measured reflection matrices
% and previously calculated Ao and Bo matrices.

function[A011] = G10_and_G20(Ao,Bo,G1,G2)

% Gets frequency point count for Ao; this is redundant and needs to go.
% Then creates 2x2 submatrices of Ao and Bo and populates them with the
% correct values.

[k,l,m] = size(Ao);

A011 = zeros(2,2,m);
A012 = zeros(2,2,m);
A021 = zeros(2,2,m);
A021 = zeros(2,2,m);

B011 = zeros(2,2,m);
B012 = zeros(2,2,m);
B021 = zeros(2,2,m);
B022 = zeros(2,2,m);


% Use this notation to populate rest of submatrices; go back in to other
% functions and use this notation.
for ii = 1:m
    A011(:,:,ii) = Ao(1:2,1:2,ii);
end

 