%computes value of ABCD 4x2 transmission matrix at the edge of the
%substrate
function [eABCD] = HISedgeABCD(f,d);

f = 300000; %hz
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;
epsR = 1; %relative permitivity

%line characteristics 
r0 = 0;  %resistance of line
d = 1; %length of line 1Km
R = 0.2254; %unit length resistance - Mohm/kM
L = 0.55; %unit length inductance - mH/km
C = 24.44;   %unit length capacitence - nF/km
G = 10; %unit length conductance - ns/km
z0 = sqrt((R+j*omega*L)/(G+j*omega*C)); %not sure about this value
gamma = sqrt((R+j*omega*L)*(G+j*omega*C));

%matrix entries vb
eABCD(1,1)= 1;
eABCD(1,2)= 0;
eABCD(2,1)= 0;
eABCD(2,2)= 1;
eABCD(3,1)= cosh(gamma*d);
eABCD(3,2)= z0*sinh(gamma*d);
eABCD(4,1)=(1/z0)*(sinh(gamma*d));
eABCD(4,2)= eABCD(1,1);
end 


% [v3s,i3s] = [d, -b; -c, a] *[v2a, i2a]

function [eABCD1] = HISedgeABCD(f,d);

f = 300000; %hz
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;
epsR = 1; %relative permitivity

%line characteristics 
r0 = 0;  %resistance of line
d = 1; %length of line 1Km
R = 0.2254; %unit length resistance - Mohm/kM
L = 0.55; %unit length inductance - mH/km
C = 24.44;   %unit length capacitence - nF/km
G = 10; %unit length conductance - ns/km
z0 = sqrt((R+j*omega*L)/(G+j*omega*C)); %not sure about this value
gamma = sqrt((R+j*omega*L)*(G+j*omega*C));

%matrix entries va with respect to addmitance matrix
eABCD1(1,1)= 1;
eABCD1(1,2)= 0;
eABCD1(2,1)= 0;
eABCD1(2,2)= 1;
eABCD1(3,1)= cosh(gamma*d);
eABCD1(3,2)= -z0*sinh(gamma*d);
eABCD1(4,1)=(-1/z0)*(sinh(gamma*d));
eABCD1(4,2)= eABCD1(1,1);
end 