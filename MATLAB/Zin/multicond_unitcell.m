function [ ABCD ] = multicond_unitcell( a, w1, w2, h1, h2, via_rad, eps1, eps2, f, viaflag)
%MULTICOND_UNITCELL result is the 4x4 ABCD matrix of the HIstrip unit cell
%using the "multiconductor TL" formulation

w1 = 0.01; %depends on kind of antenna placed on top of HIS
h1 = 0.02;
w2 = .12; %patch width
h2 = 0.04 %ground to patch
eps1 = 1;
eps2 = 2.2;
via_rad = .0015875;
f = 300e6;
len = .14; %length of microstrip segment above patches 
mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;
a = .14 %edge to edge patch length
gap = a-w2;
viaflag = 1;
%keep in mind that w/h for viaABCD is outside the range tested in Goldfarb
%& Pucel's results - ours is more than 3, they only checked up to 2.2
%d/h is also too small (0.0397 vs. their minimum of 0.2)
if viaflag
    Lmat = MTLviaABCD(h2, via_rad, f);
else
    Lmat=eye(4);
end

%gap cap split in half because that's where the ref plane is
[Cmat, Cpmat, Cptopmat] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, gap, f);
% Cptopmat is a problematic capacitor
% because the expression was for a gap in the "top" line but the gap is
% actually in the "ground" which is physically much bigger (would it be
% reasonable to say Cptopmat = Cptop*w1/w2?)

%be careful with cosh - it produces 1 for input 0, so cosh(diagonal matrix)
%is not diagonal as intended, the off-axis elements will be 1
%I am dealing with T and gameig properly here - see MTL book by Faria
MTL = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, w2/2);

ABCD = Cmat*Cpmat*Cptopmat*MTL*Lmat*MTL*Cptopmat*Cpmat*Cmat;

end

