function [ ABCD ] = multicond_unitcell( a, w1, w2, h1, h2, via_rad, eps1, eps2, freq, viaflag)
%MULTICOND_UNITCELL result is the 4x4 ABCD matrix of the HIstrip unit cell
%using the "multiconductor TL" formulation

gap = a-w2;


%keep in mind that w/h for viaABCD is outside the range tested in Goldfarb
%& Pucel's results - ours is more than 3, they only checked up to 2.2
%d/h is also too small (0.0397 vs. their minimum of 0.2)
if viaflag
    Lmat = MTLviaABCD(h2, via_rad, freq);
else
    Lmat=eye(4);
end

%gap cap split in half because that's where the ref plane is
[Cgapmat, Cpmat, Cptopmat] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, gap, freq);
% Cptopmat is a problematic capacitor
% because the expression was for a gap in the "top" line but the gap is
% actually in the "ground" which is physically much bigger (would it be
% reasonable to say Cptopmat = Cptop*w1/w2?)

%be careful with cosh - it produces 1 for input 0, so cosh(diagonal matrix)
%is not diagonal as intended, the off-axis elements will be 1
%I am dealing with T and gameig properly here - see MTL book by Faria
MTL = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, freq, w2/2);

ABCD = vpa(Cgapmat*Cpmat*Cptopmat*(MTL)*Lmat*(MTL)*Cptopmat*Cpmat*Cgapmat);

end

