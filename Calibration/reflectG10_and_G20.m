function[G10,G20,G10new,G20new] = reflectG10_and_G20(Ao,Bo,r1s11,r1s12,r1s21,r1s22,...
    r2s11,r2s12,r2s21,r2s22,rs2111,rs2112,rs2121,rs2122,...
    rs2211,rs2212,rs2221,rs2222,sq_size,sub_size,depth)

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
r21s = [rs2111 rs2112;rs2121 rs2122];
r22s = [rs2211 rs2212;rs2221 rs2222];

% Creates G10 and G20 matrices and populates them with correct values.

G10 = zeros(sub_size,sub_size,depth);
G20 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    G10(:,:,ii) = inv(A011(:,:,ii) - r1s(:,:,ii)*A021(:,:,ii))* ... 
        (r1s(:,:,ii)*A022(:,:,ii) - A012(:,:,ii));
    G20(:,:,ii) = inv(B011(:,:,ii) - r2s(:,:,ii)*B021(:,:,ii))* ... 
        (r2s(:,:,ii)*B022(:,:,ii) - B012(:,:,ii));
end

% Creates G10new and G20new matrices and populates them with correct values
% from secondary reflect.

G10new = zeros(sub_size,sub_size,depth);
G20new = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    G10new(:,:,ii) = inv(A011(:,:,ii) - r21s(:,:,ii)*A021(:,:,ii))* ... 
        (r21s(:,:,ii)*A022(:,:,ii) - A012(:,:,ii));
    G20new(:,:,ii) = inv(B011(:,:,ii) - r22s(:,:,ii)*B021(:,:,ii))* ... 
        (r22s(:,:,ii)*B022(:,:,ii) - B012(:,:,ii));
end
