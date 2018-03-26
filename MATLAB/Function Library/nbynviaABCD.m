function [ ABCD ] = nbynviaABCD( h2, via_rad, f, N, topflag )
%NBYNVIAABCD calculates the 2n by 2n generalized ABCD matrix for a via in a
%multiconductor transmission line representation of microstrip line above a
%HIS.  The via is from the HIS layer to ground.


L_via = viaL(h2, via_rad);

omega=2*pi*f;

A = eye(N);
B = zeros(N);
D = eye(N);
C = (1/(j*omega*L_via))*eye(N); 
if topflag
    C(1,1)=0;
end

ABCD = [A B; C D];


end

