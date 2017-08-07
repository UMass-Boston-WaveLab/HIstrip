function [ A11, A12, A21, A22 ] = split( A )
%SPLIT Splits a matrix into four submatrices.  Matrix can have a third
%dimension that is frequency or something. first and second dimensions must
%be equal and even.

d = size(A,1);
if size(A,2)~=d
    error('Error in split.m: Matrix is not square');
end
if floor(d/2)~=d/2
    error('Error in split.m: Matrix dimension is not even');
end

A11 = A(1:d/2, 1:d/2, :);
A12 = A(1:d/2, (d/2+1):d, :);
A21 = A((d/2+1):d, 1:d/2, :);
A22 = A((d/2+1):d, (d/2+1):d, :);


end

