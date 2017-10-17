function [ Zin ] = HIS_term_test_case( n, a, w1, w2, h1, h2, via_rad, eps1, eps2, f, feed, ZL_left, ZL_right)
%calculates input impedance of a terminated HIS structure ("antenna" and
%HIS have the same length so there's no HIS-only section).  ZL is a vector
%(no mutual impedances) that describes the termination.  ZL1 is left upper
%layer to middle, ZL2 is left middle to ground, ZL3 is right upper to
%middle, ZL4 is right middle to ground.  n is the total number of unit
%cells and must be even.

if floor(n/2)<n/2
    error('n must be even');
end

unitcell = multicond_unitcell(a, w1, w2, h1, h2, via_rad, eps1, eps2, f, 1); %use vias (viaflag=1)

%UC=unitcell^(n/2-1);

MTL = ustripMTLABCD(w1, h1, w2, h2, eps1, eps2, f, a/2);
[Lprod, ~] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, (a-w2), f);
Lmat = MTLviaABCD(h2, via_rad, f);

%MTLhalf=UC*Lprod*MTL*Lmat*MTL; %second unit cell is terminated so there's no gap capacitance there

%two-step determination of Zleft and Zright using multiplier to avoid
%poorly conditioned matrices when unitcell is raised to a power.
Zleft = terminate_ABCD4(Lprod*MTL*Lmat*MTL, ZL_left);
Zleft = unitcellMultiply(Zleft, unitcell, n/2-1);

Zright = terminate_ABCD4(Lprod*MTL*Lmat*MTL, ZL_right);
Zright = unitcellMultiply(Zright, unitcell, n/2-1);

if feed==1 %probe feed
    %boundary conditions are that upper Vleft = Vright=V, lower Vleft =
    %Vright, lower Ileft = -Iright, upper Ileft+Iright=I
    YL = inv(Zleft);
    YR = inv(Zright);
    
    Y = YL+YR;
    
    Yin = Y(1,1)-Y(1,2)*Y(2,1)/Y(2,2);
    Zin =1/Yin;
    
else %diff feed
    %boundary conditions are that upper Vleft-Vright=V, upper Ileft=-Iright=I,
    %lower Vleft=Vright, lower Ileft = Iright
    Z = Zleft+Zright;
    Zin = Z(1,1)-Z(1,2)*Z(2,1)/Z(2,2);
    
end

end

