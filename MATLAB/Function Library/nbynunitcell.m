function [ ABCD ] = nbynunitcell( cap, cap0,  a, w2, h2, via_rad, eps2, f, N, viaflag)
%NBYNUNITCELL calculates HIStrip unit cell with (N-1) HIS-layer rows
%included. Top row parameters are not necessary in inputs, because all the
%information required is included in the cap and cap0 matrices.

gap = a-w2;

if viaflag
    Lmat = nbynviaABCD(h2, via_rad, f, N);
else
    Lmat = eye(2*N);
end

[Cseries, Cshunt] = nbyncapABCD(h2, w2, eps2, gap, N, f);

MTL = nbynMTL(cap, cap0, f, a/2);

ABCD = Cseries*Cshunt*MTL*Lmat*MTL*Cshunt*Cseries;


end

