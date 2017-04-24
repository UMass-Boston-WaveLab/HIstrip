function [ Zin ] = HIS_Zin_4by4( Z, feed )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
if feed==1 %probe feed
    Y = inv(Z);
    YRR = Y(1:2, 1:2);
    YRL = Y(1:2, 3:4);
    YLR = Y(3:4, 1:2);
    YLL = Y(3:4, 3:4);
    Yp = YRR+YRL+YLR+YLL;
    Yin = Yp(1,1)-Yp(1,2)*Yp(2,1)/Yp(2,2);
    Zin = 1/Yin;
else
    ZRR = Z(1:2, 1:2);
    ZRL = Z(1:2, 3:4);
    ZLR = Z(3:4, 1:2);
    ZLL = Z(3:4, 3:4);
    Zp = ZRR-ZRL-ZLR+ZLL;
    Zin = Zp(1,1)-Zp(1,2)*Zp(2,1)/Zp(2,2);
end



end

