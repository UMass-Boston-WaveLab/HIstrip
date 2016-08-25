% Calculates known G10 and G20 matrices from measured reflection matrices
% and previously calculated Ao and Bo matrices. 

function[newG10,newG20] = newG10_and_G20(Ao,Bo,r1s11,r1s12,r1s21,r1s22,...
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
% Matrices are close to singular, getting bad values.

newG10 = zeros(sub_size,sub_size,depth);
newG20 = zeros(sub_size,sub_size,depth);

X = zeros(2,2,depth);

for ii = 1:depth
    X(:,:,ii) = A011(:,:,ii) - r1s(:,:,ii)*A021(:,:,ii);
end

dets = zeros(1,1,depth);

for ii = 1:depth
    dets(1,1,ii) = det(X(:,:,ii));
    dets(1,1,ii) = 1/dets(1,1,ii);
end

invthingy = zeros(2,2,depth);

for ii = 1:depth
    invthingy(1,1,ii) = X(2,2,ii)*dets(1,1,ii);
    invthingy(2,2,ii) = X(1,1,ii)*dets(1,1,ii);
    invthingy(1,2,ii) = X(1,2,ii)*-dets(1,1,ii);
    invthingy(2,1,ii) = X(2,1,ii)*-dets(1,1,ii);
end

Y = zeros(2,2,depth);

for ii = 1:depth
    Y(:,:,ii) = B011(:,:,ii) - r2s(:,:,ii)*B021(:,:,ii);
end

dets2 = zeros(1,1,depth);

for ii = 1:depth
    dets2(1,1,ii) = det(Y(:,:,ii));
    dets2(1,1,ii) = 1/dets2(1,1,ii);
end

invthingy2 = zeros(2,2,depth);

for ii = 1:depth
    invthingy2(1,1,ii) = Y(2,2,ii)*dets2(1,1,ii);
    invthingy2(2,2,ii) = Y(1,1,ii)*dets2(1,1,ii);
    invthingy2(1,2,ii) = Y(1,2,ii)*-dets2(1,1,ii);
    invthingy2(2,1,ii) = Y(2,1,ii)*-dets2(1,1,ii);
end

for ii = 1:depth
    newG10(:,:,ii) = invthingy(:,:,ii)* ... 
        (r1s(:,:,ii)*A022(:,:,ii) - A012(:,:,ii));
    newG20(:,:,ii) = invthingy2(:,:,ii)* ... 
        (r2s(:,:,ii)*B022(:,:,ii) - B012(:,:,ii));
end
