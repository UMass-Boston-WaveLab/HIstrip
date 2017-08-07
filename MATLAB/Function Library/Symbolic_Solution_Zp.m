   Vin = sym ('Vin');
   Iin = sym ('Iin');
   Zin = sym ('Zin');
   V1a = sym ('V1a');
   V2a = sym ('V2a');
   I1a = sym ('I1a');
   I2a = sym ('I2a');
   
   Y = sym('Y', [4 4])
   
   V = [Vin; V2a; Vin; V2a];
   
   I = [I1a; I2a; I1a+Iin; -I2a];
   
   K = Y*V
   
y11 = Y(1,1);
y12 = Y(1,2);
y13 = Y(1,3);
y14 = Y(1,4);

y21 = Y(2,1);
y22 = Y(2,2);
y23 = Y(2,3);
y24 = Y(2,4);

y31 = Y(3,1);
y32 = Y(3,2);
y33 = Y(3,3);
y34 = Y(3,4);

y41 = Y(4,1);
y42 = Y(4,2);
y43 = Y(4,3);
y44 = Y(4,4);

%Yt = ((-y41-y43+y21+y23)/(y22+y24+y42+y44))*(y32+y34-y12-y14)+y31+y33+y21+y23;

%Zt = Yt^-1


