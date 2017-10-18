function [ Zin ] = unitcellMultiply( ZL, ABCD, N )
%UNITCELLMULTIPLY takes load impedance, ABCD matrix, and N (number of
%repeated unit cells), and calculates the input impedance of N unit cells
%whose ABCD matrix is ABCD, terminated by ZL.  ZL can be any size square
%matrix, and both dimensions of ABCD must be twice the dimensions of ZL
%(ABCD is also square).  So, if ZL is a scalar, ABCD is 2x2.  If ZL is 2x2,
%ABCD is 4x4, and so on.

m = size(ZL, 1);
Z = ZL;

%split ABCD into submatrices
A = ABCD(1:m, 1:m);
B = ABCD(1:m, (m+1):(2*m));
C = ABCD((m+1):(2*m), 1:m);
D = ABCD((m+1):(2*m), (m+1):(2*m));

for ii = 1:N
    %calculate input impedance to this unit cell when terminated by Z,
    %which contains either the load impedance or the input impedance to the
    %previous unit cell.
    Z = (A*Z+B)/(C*Z+D);
end
Zin = Z;

end

