y = sym('y',[4 4]);
idx = eye(size(y));
idx = idx + -1*(1-idx);
Ya = idx.*y

yp = [1 -1 0 0; 0 1 0 0; 0 0 1 -1; 0 0 0 1]
yn = Ya*yp
a = sym('A');
b = sym('B');
c = sym('C');
d = sym('D');

I1R = sym('I1R');
I2R = sym('I2R');
I1L = sym('I1L');
I2L = sym('I2L');
I = [I1R; I2R; I1L; I2L]

V1R = sym('V1R');
V2R = sym('V2R');
V1L = sym('V1L');
V2L = sym('V2L');
V = [V1R; V2R; V1L; V2L]




Y1 = [ 1 0 0 0; 0 a 0 0; 0 0 1 0; 0 0 0 -d];
Y2 = [ 0 0 0 0; 0 -b 0 0; 0 0 0 0; 0 0 0 b];
Y3 = [ 1 0 0 0; 0 -d 0 0; 0 0 1 0; 0 0 0 a];
Y4 = [ 0 0 0 0; 0 c 0 0; 0 0 0 0; 0 0 0 -c];

I = yn*V;
x = (Y1 - yn*Y2);
b = (yn*Y3 + Y4);
Yeq = inv(x)*b;

Yii = Yeq(1:2,1:2); %(rows1:row2,column1:column2)
Yio = Yeq(1:2,3:4);
Yoi = Yeq(3:4,1:2);
Yoo = Yeq(3:4,3:4);

 
A = Yoo\(Yoi);
B = 1\Yoi;
C = (Yio*Yoi-Yii*Yoo)\Yoi;
D = Yii\Yoi;

ABCD = [A B; C D]