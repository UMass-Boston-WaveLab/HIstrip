% Function takes in rectangular S-parameters from HFSS in a .csv format
% and converts them into a square matrix.
% You need to strip the whitespace from the HFSS data first (use find and 
% replace in Excel, find spaces and replace them with nothing.)

function [S11, S12, S21, S22, S] = read_HFSS_S(filename)
x = csvread(filename, 1, 1);
[m,n] = size(x);
y = zeros(4, 4, m);
for ii = 1:m
    w = x(ii, :);
    z = reshape(w, 4, 4);
    y(:,:,ii) = z;
end
A = zeros(2,2,m);
B = zeros(2,2,m);
C = zeros(2,2,m);
D = zeros(2,2,m);
for ii = 1:m
    A(1,1,ii) = y(1,1,ii);
    A(1,2,ii) = y(1,2,ii);
    A(2,1,ii) = y(2,1,ii);
    A(2,2,ii) = y(2,2,ii);
    B(1,1,ii) = y(1,3,ii);
    B(1,2,ii) = y(1,4,ii);
    B(2,1,ii) = y(2,3,ii);
    B(2,2,ii) = y(2,4,ii);
    C(1,1,ii) = y(3,1,ii);
    C(1,2,ii) = y(3,2,ii);
    C(2,1,ii) = y(4,1,ii);
    C(2,2,ii) = y(4,2,ii);
    D(1,1,ii) = y(3,3,ii);
    D(1,2,ii) = y(3,4,ii);
    D(2,1,ii) = y(4,3,ii);
    D(2,2,ii) = y(4,4,ii);
end
S11 = A;
S12 = B;
S21 = C;
S22 = D;
S = [S11 S12; S21 S22];
end

   
