function [ Zin ] = HIS_term_test_case( n, a, w1, w2, h1, h2, via_rad, eps1, eps2, f, feed, ZL)
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

MTLhalf=unitcell^(n/2);

Zleft = terminate_ABCD4(MTLhalf, [ZL(1), 0; 0, ZL(2)]);

Zright = terminate_ABCD4(MTLhalf, [ZL(3), 0; 0, ZL(4)]);

if feed==1 %probe feed
    %boundary conditions are that upper Vleft = Vright=V, lower Vleft =
    %Vright, lower Ileft = -Iright, upper Ileft+Iright=I
else %diff feed
    %boundary conditions are that upper Vleft-Vright=V, upper Ileft=Iright,
    %lower Vleft=Vright, lower Ileft = Iright
end

end

