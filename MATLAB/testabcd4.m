function [ val ] = testabcd4( M)
A = M(1:2,1:2);
B = M(1:2, 3:4);
C = M(3:4, 1:2);
D = M(3:4, 3:4);
val = A*D-B*C;


end

