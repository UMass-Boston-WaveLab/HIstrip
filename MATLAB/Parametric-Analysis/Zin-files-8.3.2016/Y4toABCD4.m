
function [ ABCD ] = Y4toABCD4(Y)

% Converts a 4x4 Y matrix into an ABCD4 matrix.  Y matrix must be in this
% form (i means input, o means output):
%  [Ii; Io] = [Yii Yio; Yoi Yoo][Vi; Vo]



Yii = Y(1:2,1:2); %(rows1:row2,column1:column2)
Yio = Y(1:2,3:4);
Yoi = Y(3:4,1:2);
Yoo = Y(3:4,3:4);

A = Yoi\Yoo;
B = inv(Yoi);
C = (Yio-Yii)*(Yoi\Yoo);
D = Yii/Yoi;

ABCD = [A B; C D];

end
