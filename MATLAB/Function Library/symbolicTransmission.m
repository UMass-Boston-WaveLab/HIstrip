y = sym('y',[4 4])
a = sym('A');
b = sym('B');
c = sym('C');
d = sym('D');
v1 = sym('V1');
v2 = sym('V2');
i1 = sym('I1');
i2 = sym('I2')

v = [v1;v2;i1;i2]
g = [1 0 0 0; 0 a 0 b; 0 0 1 0; 0 c 0 d]

v = g*y*g