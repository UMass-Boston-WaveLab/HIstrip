% Calculates known G10 and G20 matrices from measured reflection matrices
% and previously calculated Ao and Bo matrices. 

function[G10,G20] = G10_and_G20(Ao,Bo,R1S,R2S,depth)

% Creates 2x2 submatrices of Ao and Bo and populates them with the
% correct values.

A011 = zeros(2,2,depth);
A012 = zeros(2,2,depth);
A021 = zeros(2,2,depth);
A021 = zeros(2,2,depth);

B011 = zeros(2,2,depth);
B012 = zeros(2,2,depth);
B021 = zeros(2,2,depth);
B022 = zeros(2,2,depth);

for ii = 1:depth
    A011(:,:,ii) = Ao(1:2,1:2,ii);
    A012(:,:,ii) = Ao(1:2,3:4,ii);
    A021(:,:,ii) = Ao(3:4,1:2,ii);
    A022(:,:,ii) = Ao(3:4,3:4,ii);
    
    B011(:,:,ii) = Bo(1:2,1:2,ii);
    B012(:,:,ii) = Bo(1:2,3:4,ii);
    B021(:,:,ii) = Bo(3:4,1:2,ii);
    B022(:,:,ii) = Bo(3:4,3:4,ii);
end

% Creates G10 and G20 matrices and populates them with correct values.

G10 = zeros(2,2,depth);
G20 = zeros(2,2,depth);

for ii = 1:depth
    G10(:,:,ii) = inv(A011(:,:,ii) - R1S(:,:,ii)*A021(:,:,ii))* ... 
        (R1S(:,:,ii)*A022(:,:,ii) - A012(:,:,ii));
    G20(:,:,ii) = inv(B011(:,:,ii) - R2S(:,:,ii)*B021(:,:,ii))* ... 
        (R2S(:,:,ii)*B022(:,:,ii) - B012(:,:,ii));
end