function [ ABCD ] = multicond_unitcell( f,  w_ant, w2, h1, H_sub, via_rad, eps1, eps2, g, viaflag)
%MULTICOND_UNITCELL result is the 4x4 ABCD matrix of the HIstrip unit cell
%using the "multiconductor TL" formulation



%keep in mind that w/h for viaABCD is outside the range tested in Goldfarb
%& Pucel's results - ours is more than 3, they only checked up to 2.2
%d/h is also too small (0.0397 vs. their minimum of 0.2)
if viaflag
    Lmat = MTLviaABCD(H_sub, via_rad, f);
else
    Lmat=eye(4);
end

%gap cap split in half because that's where the ref plane is
[Cmat, Cpmat, Cptopmat] = MTLcapABCD(h1, H_sub, w_ant, w2, eps1, eps2, g, f);
% Cptopmat is a problematic capacitor
% because the expression was for a gap in the "top" line but the gap is
% actually in the "ground" which is physically much bigger (would it be
% reasonable to say Cptopmat = Cptop*w1/w2?)

%be careful with cosh - it produces 1 for input 0, so cosh(diagonal matrix)
%is not diagonal as intended, the off-axis elements will be 1
%I am dealing with T and gameig properly here - see MTL book by Faria
MTL = ustripMTLABCD(w_ant, h1, w2, H_sub, eps1, eps2, f, w2/2);

ABCD = Cmat*Cpmat*Cptopmat*MTL*Lmat*MTL*Cptopmat*Cpmat*Cmat;

end

