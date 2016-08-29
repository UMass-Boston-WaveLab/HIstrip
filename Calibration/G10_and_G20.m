% Calculates known G10 and G20 matrices from measured reflection matrices
% and previously calculated Ao and Bo matrices. 

function[G10,G20] = G10_and_G20(Ao,Bo,r1s11,r1s12,r1s21,r1s22,...
    r2s11,r2s12,r2s21,r2s22,sq_size,sub_size,depth)

% Creates 2x2 submatrices of Ao and Bo and populates them with the
% correct values.

A011 = zeros(sub_size,sub_size,depth);
A012 = zeros(sub_size,sub_size,depth);
A021 = zeros(sub_size,sub_size,depth);
A021 = zeros(sub_size,sub_size,depth);

B011 = zeros(sub_size,sub_size,depth);
B012 = zeros(sub_size,sub_size,depth);
B021 = zeros(sub_size,sub_size,depth);
B022 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    A011(:,:,ii) = Ao(1:sub_size,1:sub_size,ii);
    A012(:,:,ii) = Ao(1:sub_size,sub_size+1:sq_size,ii);
    A021(:,:,ii) = Ao(sub_size+1:sq_size,1:sub_size,ii);
    A022(:,:,ii) = Ao(sub_size+1:sq_size,sub_size+1:sq_size,ii);
    
    B011(:,:,ii) = Bo(1:sub_size,1:sub_size,ii);
    B012(:,:,ii) = Bo(1:sub_size,sub_size+1:sq_size,ii);
    B021(:,:,ii) = Bo(sub_size+1:sq_size,1:sub_size,ii);
    B022(:,:,ii) = Bo(sub_size+1:sq_size,sub_size+1:sq_size,ii);
    
end

r1s = [r1s11 r1s12;r1s21 r1s22];
r2s = [r2s11 r2s12;r2s21 r2s22];

% Creates G10 and G20 matrices and populates them with correct values.

G10 = zeros(sub_size,sub_size,depth);
G20 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    G10(:,:,ii) = inv(A011(:,:,ii) - r1s(:,:,ii)*A021(:,:,ii))* ... 
        (r1s(:,:,ii)*A022(:,:,ii) - A012(:,:,ii));
    G20(:,:,ii) = inv(B011(:,:,ii) - r2s(:,:,ii)*B021(:,:,ii))* ... 
        (r2s(:,:,ii)*B022(:,:,ii) - B012(:,:,ii));
end


 