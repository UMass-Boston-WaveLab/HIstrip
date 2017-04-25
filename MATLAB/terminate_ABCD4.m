function [ Z ] = terminate_ABCD4( ABCD4, ZL )
%returns 2x2 Z matrix of terminated ABCD4 matrix

A = ABCD4(1:2,1:2);
B = ABCD4(1:2, 3:4);
C = ABCD4(3:4, 1:2);
D = ABCD4(3:4, 3:4);


Z = vpa((A*ZL+B))/vpa((C*ZL+D));


end

