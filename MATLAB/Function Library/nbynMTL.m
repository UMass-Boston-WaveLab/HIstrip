function [ ABCD ] = nbynMTL( cap, cap0, f, len )
%NBYNMTL calculates the ABCD matrix for an n-1 terminal multiconductor
%transmission line of length L at frequency f.  The per-unit-length
%capacitance matrix (with dielectrics), cap, is taken as an input.  The
%per-unit-length capacitance matrix without dielectrics, cap0, is also
%taken as an input and used to calculate the per unit length inductance matrix.
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

ind = mu0*eps0*inv(cap0); %symmetric

Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = sqrt(diag(gamsq));

Zw = Gam\Z; %symmetric 
Yw = Y/Gam; %symmetric

ABCD = [T*diag(cosh(gameig*len))/T, (T*diag(sinh(gameig*len))/T)*Zw; 
        Yw*T*diag(sinh(gameig*len))/T, Yw*T*diag(cosh(gameig*len))/T*Zw];


end

