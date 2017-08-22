function [ H6_total ] = H_6_xOrder( L2, L1, d, frequency, order )
%% - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2))) 
%% 
lambda = 3E8/frequency;
k = 2*pi/lambda;

if order == 1
    H_6_1Order = (-1/1920).*(d.^2).^(1/2).*k.^(-1).*((-480).*d.^(-2)+(2/3).*d.^(-2) ...
        .*((-720)+(-2160).*d.^2.*k.^2+(-60).*d.^4.*k.^4+d.^6.*k.^6)).* ...
        pi.^(-1)+(1/1920).*k.^(-1).*(d.^2+L1.^2).^(1/2).*((-480).*(d.^2+ ...
        L1.^2).^(-1)+(1/3).*d.^(-2).*((-1440)+(-4320).*d.^2.*k.^2+(-120).* ...
        d.^4.*k.^4+2.*d.^6.*k.^6+(-30).*d.^2.*k.^4.*L1.^2+(-1).*d.^4.* ...
        k.^6.*L1.^2)).*pi.^(-1)+(sqrt(-1)*(-1/160)).*k.^2.*(20+d.^2.*k.^2) ...
        .*L1.*L2.*pi.^(-1)+(1/1920).*k.^(-1).*(d.^2+L2.^2).^(1/2).*((2/3) ...
        .*d.^(-2).*((-720)+(-2160).*d.^2.*k.^2+(-60).*d.^4.*k.^4+d.^6.* ...
        k.^6)+(-1/3).*k.^4.*(30+d.^2.*k.^2).*L2.^2+(-480).*(d.^2+L2.^2).^( ...
        -1)).*pi.^(-1)+(-1/1920).*k.^(-1).*(d.^2+L1.^2+(-2).*L1.*L2+L2.^2) ...
        .^(1/2).*((1/3).*d.^(-2).*((-1440)+(-4320).*d.^2.*k.^2+(-120).* ...
        d.^4.*k.^4+2.*d.^6.*k.^6+(-30).*d.^2.*k.^4.*L1.^2+(-1).*d.^4.* ...
        k.^6.*L1.^2)+(2/3).*k.^4.*(30+d.^2.*k.^2).*L1.*L2+(-1/3).*k.^4.*( ...
        30+d.^2.*k.^2).*L2.^2+(-480).*(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^( ...
        -1)).*pi.^(-1)+(-1/16).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+( ...
        sqrt(-1)*(-3)).*k.*L1+(sqrt(-1)*(-1)).*d.^2.*k.^3.*L1).*pi.^(-1).* ...
        atan(d.^(-1).*L1)+(1/16).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+( ...
        sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.*k.^3.*L1).*pi.^(-1).*atan(d.^( ...
        -1).*L1)+(-1/16).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)* ...
        3).*k.*L1+sqrt(-1).*d.^2.*k.^3.*L1).*pi.^(-1).*atan(d.^(-1).*(L1+( ...
        -1).*L2))+(sqrt(-1)*(1/8)).*d.^(-1).*(3+d.^2.*k.^2).*L2.*pi.^(-1) ...
        .*atan(d.^(-1).*(L1+(-1).*L2))+(sqrt(-1)*(1/8)).*d.^(-1).*(3+ ...
        d.^2.*k.^2).*L2.*pi.^(-1).*atan(d.^(-1).*L2)+(-1/16).*d.^(-1).* ...
        k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*(-3)).*k.*L1+(sqrt(-1)*(-1) ...
        ).*d.^2.*k.^3.*L1).*pi.^(-1).*atan(d.^(-1).*((-1).*L1+L2))+(sqrt( ...
        -1)*(1/16)).*k.^(-1).*(6.*k+d.^2.*k.^3).*pi.^(-1).*log(d.^2)+( ...
        sqrt(-1)*(-1/32)).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1) ...
        *(-3)).*k.*L1+(sqrt(-1)*(-1)).*d.^2.*k.^3.*L1).*pi.^(-1).*log( ...
        d.^2+L1.^2)+(sqrt(-1)*(-1/32)).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.* ...
        k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.*k.^3.*L1).*pi.^(-1).*log( ...
        d.^2+L1.^2)+(1/1920).*k.*((-720)+(-30).*d.^2.*k.^2+d.^4.*k.^4).* ...
        L1.*pi.^(-1).*log((-1).*L1+(d.^2+L1.^2).^(1/2))+(sqrt(-1)*(-1/16)) ...
        .*k.^(-1).*(6.*k+d.^2.*k.^3).*pi.^(-1).*log(d.^2+L2.^2)+(sqrt(-1)* ...
        (1/32)).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*(-3)).* ...
        k.*L1+(sqrt(-1)*(-1)).*d.^2.*k.^3.*L1).*pi.^(-1).*log(d.^2+L1.^2+( ...
        -2).*L1.*L2+L2.^2)+(sqrt(-1)*(1/32)).*d.^(-1).*k.^(-1).*(6.*d.*k+ ...
        d.^3.*k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.*k.^3.*L1).*pi.^(-1) ...
        .*log(d.^2+L1.^2+(-2).*L1.*L2+L2.^2)+(1/1920).*k.*((-720)+(-30).* ...
        d.^2.*k.^2+d.^4.*k.^4).*L2.*pi.^(-1).*log((-1).*L2+(d.^2+L2.^2).^( ...
        1/2))+(-1/1920).*k.*((-720)+(-30).*d.^2.*k.^2+d.^4.*k.^4).*L2.* ...
        pi.^(-1).*log(L1+(-1).*L2+(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(1/2))+ ...
        (-1/1920).*k.*((-720)+(-30).*d.^2.*k.^2+d.^4.*k.^4).*L1.*pi.^(-1) ...
        .*log((-1).*L1+L2+(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(1/2));
    H6_total = H_6_1Order;
    
elseif order == 2
    H_6_2Order = (-1/6720).*(d.^2).^(1/2).*k.^(-1).*((-1680).*d.^(-2)+(7/3).*d.^( ...
        -2).*((-720)+(-2160).*d.^2.*k.^2+(-60).*d.^4.*k.^4+d.^6.*k.^6)).* ...
        pi.^(-1)+(1/6720).*k.^(-1).*(d.^2+L1.^2).^(1/2).*((-1680).*(d.^2+ ...
        L1.^2).^(-1)+(7/6).*d.^(-2).*((-1440)+(-4320).*d.^2.*k.^2+(-120).* ...
        d.^4.*k.^4+2.*d.^6.*k.^6+(-30).*d.^2.*k.^4.*L1.^2+(-1).*d.^4.* ...
        k.^6.*L1.^2)).*pi.^(-1)+(sqrt(-1)*(1/20160)).*k.^2.*L1.*((-2520)+ ...
        3.*d.^4.*k.^4+42.*k.^2.*L1.^2+d.^2.*k.^4.*L1.^2).*L2.*pi.^(-1)+( ...
        sqrt(-1)*(1/13440)).*k.^2.*((-840)+d.^4.*k.^4).*L2.^2.*pi.^(-1)+( ...
        sqrt(-1)*(-1/13440)).*k.^2.*((-840)+d.^4.*k.^4+42.*k.^2.*L1.^2+ ...
        d.^2.*k.^4.*L1.^2).*L2.^2.*pi.^(-1)+(sqrt(-1)*(1/20160)).*k.^4.*( ...
        42+d.^2.*k.^2).*L1.*L2.^3.*pi.^(-1)+(1/6720).*k.^(-1).*(d.^2+ ...
        L2.^2).^(1/2).*((7/3).*d.^(-2).*((-720)+(-2160).*d.^2.*k.^2+(-60) ...
        .*d.^4.*k.^4+d.^6.*k.^6)+(-7/6).*k.^4.*(30+d.^2.*k.^2).*L2.^2+( ...
        -1680).*(d.^2+L2.^2).^(-1)).*pi.^(-1)+(-1/6720).*k.^(-1).*(d.^2+ ...
        L1.^2+(-2).*L1.*L2+L2.^2).^(1/2).*((7/6).*d.^(-2).*((-1440)+( ...
        -4320).*d.^2.*k.^2+(-120).*d.^4.*k.^4+2.*d.^6.*k.^6+(-30).*d.^2.* ...
        k.^4.*L1.^2+(-1).*d.^4.*k.^6.*L1.^2)+(7/3).*k.^4.*(30+d.^2.*k.^2) ...
        .*L1.*L2+(-7/6).*k.^4.*(30+d.^2.*k.^2).*L2.^2+(-1680).*(d.^2+ ...
        L1.^2+(-2).*L1.*L2+L2.^2).^(-1)).*pi.^(-1)+(-1/16).*d.^(-1).*k.^( ...
        -1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*(-3)).*k.*L1+(sqrt(-1)*(-1)).* ...
        d.^2.*k.^3.*L1).*pi.^(-1).*atan(d.^(-1).*L1)+(1/16).*d.^(-1).*k.^( ...
        -1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.* ...
        k.^3.*L1).*pi.^(-1).*atan(d.^(-1).*L1)+(-1/16).*d.^(-1).*k.^(-1).* ...
        (6.*d.*k+d.^3.*k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.*k.^3.*L1) ...
        .*pi.^(-1).*atan(d.^(-1).*(L1+(-1).*L2))+(sqrt(-1)*(1/8)).*d.^(-1) ...
        .*(3+d.^2.*k.^2).*L2.*pi.^(-1).*atan(d.^(-1).*(L1+(-1).*L2))+( ...
        sqrt(-1)*(1/8)).*d.^(-1).*(3+d.^2.*k.^2).*L2.*pi.^(-1).*atan(d.^( ...
        -1).*L2)+(-1/16).*d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)* ...
        (-3)).*k.*L1+(sqrt(-1)*(-1)).*d.^2.*k.^3.*L1).*pi.^(-1).*atan(d.^( ...
        -1).*((-1).*L1+L2))+(sqrt(-1)*(1/16)).*k.^(-1).*(6.*k+d.^2.*k.^3) ...
        .*pi.^(-1).*log(d.^2)+(sqrt(-1)*(-1/32)).*d.^(-1).*k.^(-1).*(6.* ...
        d.*k+d.^3.*k.^3+(sqrt(-1)*(-3)).*k.*L1+(sqrt(-1)*(-1)).*d.^2.* ...
        k.^3.*L1).*pi.^(-1).*log(d.^2+L1.^2)+(sqrt(-1)*(-1/32)).*d.^(-1).* ...
        k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1).*d.^2.* ...
        k.^3.*L1).*pi.^(-1).*log(d.^2+L1.^2)+(1/1920).*k.*((-720)+(-30).* ...
        d.^2.*k.^2+d.^4.*k.^4).*L1.*pi.^(-1).*log((-1).*L1+(d.^2+L1.^2).^( ...
        1/2))+(sqrt(-1)*(-1/16)).*k.^(-1).*(6.*k+d.^2.*k.^3).*pi.^(-1).* ...
        log(d.^2+L2.^2)+(sqrt(-1)*(1/32)).*d.^(-1).*k.^(-1).*(6.*d.*k+ ...
        d.^3.*k.^3+(sqrt(-1)*(-3)).*k.*L1+(sqrt(-1)*(-1)).*d.^2.*k.^3.*L1) ...
        .*pi.^(-1).*log(d.^2+L1.^2+(-2).*L1.*L2+L2.^2)+(sqrt(-1)*(1/32)).* ...
        d.^(-1).*k.^(-1).*(6.*d.*k+d.^3.*k.^3+(sqrt(-1)*3).*k.*L1+sqrt(-1) ...
        .*d.^2.*k.^3.*L1).*pi.^(-1).*log(d.^2+L1.^2+(-2).*L1.*L2+L2.^2)+( ...
        1/1920).*k.*((-720)+(-30).*d.^2.*k.^2+d.^4.*k.^4).*L2.*pi.^(-1).* ...
        log((-1).*L2+(d.^2+L2.^2).^(1/2))+(-1/1920).*k.*((-720)+(-30).* ...
        d.^2.*k.^2+d.^4.*k.^4).*L2.*pi.^(-1).*log(L1+(-1).*L2+(d.^2+L1.^2+ ...
        (-2).*L1.*L2+L2.^2).^(1/2))+(-1/1920).*k.*((-720)+(-30).*d.^2.* ...
        k.^2+d.^4.*k.^4).*L1.*pi.^(-1).*log((-1).*L1+L2+(d.^2+L1.^2+(-2).* ...
        L1.*L2+L2.^2).^(1/2));
    H6_total = H_6_2Order;
    
elseif order == 3 
    H_6_3Order =(-1/1290240).*pi.^(-1).*((1/5).*(d.^2).^(1/2).*k.^(-1).*((...
        -1612800).*d.^(-2)+(-134400).*d.^2.*k.^4+896.*d.^4.*k.^6+(-24).* ...
        d.^6.*k.^8+336.*((-4800).*d.^(-2)+(-14400).*k.^2))+(-1/5).*k.^(-1) ...
        .*(d.^2+L1.^2).^(1/2).*((-1612800).*d.^(-2)+(-24).*d.^6.*k.^8+ ...
        d.^4.*k.^6.*(896+27.*k.^2.*L1.^2)+2.*d.^2.*k.^4.*((-67200)+196.* ...
        k.^2.*L1.^2+3.*k.^4.*L1.^4)+336.*((-14400).*k.^2+(-100).*k.^4.* ...
        L1.^2+k.^6.*L1.^4+(-4800).*(d.^2+L1.^2).^(-1)))+80640.*d.^(-1).*( ...
        6.*d+d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.*k.^2.* ...
        L1).*atan(d.^(-1).*L1)+(-80640).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt( ...
        -1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*atan(d.^(-1).*L1)+(sqrt(-1)* ...
        (-80640)).*(6+d.^2.*k.^2).*log(d.^2)+(sqrt(-1)*40320).*d.^(-1).*( ...
        6.*d+d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*log( ...
        d.^2+L1.^2)+40320.*d.^(-1).*((sqrt(-1)*6).*d+sqrt(-1).*d.^3.*k.^2+ ...
        3.*L1+d.^2.*k.^2.*L1).*log(d.^2+L1.^2)+3.*k.*(161280+6720.*d.^2.* ...
        k.^2+(-56).*d.^4.*k.^4+3.*d.^6.*k.^6).*L1.*log((-1).*L1+(d.^2+ ...
        L1.^2).^(1/2)))+(1/1290240).*pi.^(-1).*((-1/5).*k.^(-1).*(( ...
        -1612800).*d.^(-2)+(-24).*d.^6.*k.^8+d.^4.*k.^6.*(896+27.*k.^2.*( ...
        L1+(-1).*L2).^2)+2.*d.^2.*k.^4.*((-67200)+196.*k.^2.*(L1+(-1).*L2) ...
        .^2+3.*k.^4.*(L1+(-1).*L2).^4)+336.*((-14400).*k.^2+(-4800).*( ...
        d.^2+(L1+(-1).*L2).^2).^(-1)+(-100).*k.^4.*(L1+(-1).*L2).^2+k.^6.* ...
        (L1+(-1).*L2).^4)).*(d.^2+(L1+(-1).*L2).^2).^(1/2)+(sqrt(-1)*64).* ...
        k.^2.*L1.*(3.*d.^4.*k.^4+d.^2.*k.^4.*L1.^2+42.*((-60)+k.^2.*L1.^2) ...
        ).*L2+(sqrt(-1)*(-96)).*k.^4.*(42+d.^2.*k.^2).*L1.^2.*L2.^2+(sqrt( ...
        -1)*64).*k.^4.*(42+d.^2.*k.^2).*L1.*L2.^3+(1/5).*k.^(-1).*(d.^2+ ...
        L2.^2).^(1/2).*((-1612800).*d.^(-2)+(-24).*d.^6.*k.^8+d.^4.*k.^6.* ...
        (896+27.*k.^2.*L2.^2)+2.*d.^2.*k.^4.*((-67200)+196.*k.^2.*L2.^2+ ...
        3.*k.^4.*L2.^4)+336.*((-14400).*k.^2+(-100).*k.^4.*L2.^2+k.^6.* ...
        L2.^4+(-4800).*(d.^2+L2.^2).^(-1)))+80640.*d.^(-1).*(6.*d+d.^3.* ...
        k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.*k.^2.*L1).*atan( ...
        d.^(-1).*(L1+(-1).*L2))+(-80640).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt( ...
        -1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*atan(d.^(-1).*(L1+(-1).*L2)) ...
        +(sqrt(-1)*161280).*d.^(-1).*(3+d.^2.*k.^2).*L2.*atan(d.^(-1).*( ...
        L1+(-1).*L2))+(sqrt(-1)*161280).*d.^(-1).*(3+d.^2.*k.^2).*L2.* ...
        atan(d.^(-1).*L2)+(sqrt(-1)*40320).*d.^(-1).*(6.*d+d.^3.*k.^2+( ...
        sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*log(d.^2+(L1+(-1).*L2) ...
        .^2)+40320.*d.^(-1).*((sqrt(-1)*6).*d+sqrt(-1).*d.^3.*k.^2+3.*L1+ ...
        d.^2.*k.^2.*L1).*log(d.^2+(L1+(-1).*L2).^2)+3.*k.*(161280+6720.* ...
        d.^2.*k.^2+(-56).*d.^4.*k.^4+3.*d.^6.*k.^6).*L2.*log(L1+(d.^2+(L1+ ...
        (-1).*L2).^2).^(1/2)+(-1).*L2)+3.*k.*(161280+6720.*d.^2.*k.^2+( ...
        -56).*d.^4.*k.^4+3.*d.^6.*k.^6).*L1.*log((-1).*L1+(d.^2+(L1+(-1).* ...
        L2).^2).^(1/2)+L2)+(sqrt(-1)*(-80640)).*(6+d.^2.*k.^2).*log(d.^2+ ...
        L2.^2)+(-3).*k.*(161280+6720.*d.^2.*k.^2+(-56).*d.^4.*k.^4+3.* ...
        d.^6.*k.^6).*L2.*log((-1).*L2+(d.^2+L2.^2).^(1/2)));
    H6_total = H_6_3Order;
    
elseif order == 9
    H6_total=(-1/1339058552832000).*pi.^(-1).*((-1/11).*(d.^2).^(1/2).*k.^(-1) ...
        .*(3682411020288000.*d.^(-2)+306867585024000.*d.^2.*k.^4+( ...
        -2045783900160).*d.^4.*k.^6+15656509440.*d.^6.*k.^8+(-96645120).* ...
        d.^8.*k.^10+465920.*d.^10.*k.^12+(-11520).*d.^12.*k.^14+9984.*( ...
        368831232000.*d.^(-2)+1106493696000.*k.^2))+(1/11).*d.^(-2).*k.^( ...
        -1).*(d.^2+L1.^2).^(-1/2).*((-11520).*d.^16.*k.^14+ ...
        3682411020288000.*L1.^2+5.*d.^14.*k.^12.*(93184+5283.*k.^2.*L1.^2) ...
        +5.*d.^12.*k.^10.*((-19329024)+172718.*k.^2.*L1.^2+14049.*k.^4.* ...
        L1.^4)+2.*d.^10.*k.^8.*(7828254720+(-83620680).*k.^2.*L1.^2+ ...
        1036945.*k.^4.*L1.^4+26271.*k.^6.*L1.^6)+4.*d.^8.*k.^6.*(( ...
        -511445975040)+6238140480.*k.^2.*L1.^2+(-70313100).*k.^4.*L1.^4+ ...
        899171.*k.^6.*L1.^6+6894.*k.^8.*L1.^8)+16.*d.^6.*k.^4.*( ...
        19179224064000+(-183800897280).*k.^2.*L1.^2+1661465520.*k.^4.* ...
        L1.^4+(-23170290).*k.^6.*L1.^6+183547.*k.^8.*L1.^8+531.*k.^10.* ...
        L1.^10)+9984.*d.^2.*(737662464000+1106493696000.*k.^2.*L1.^2+ ...
        7683984000.*k.^4.*L1.^4+(-76839840).*k.^6.*L1.^6+653400.*k.^8.* ...
        L1.^8+(-4235).*k.^10.*L1.^10+21.*k.^12.*L1.^12)+32.*d.^4.*k.^2.*( ...
        345226033152000+11987015040000.*k.^2.*L1.^2+(-51943731840).*k.^4.* ...
        L1.^4+744091920.*k.^6.*L1.^6+(-6323460).*k.^8.*L1.^8+38311.* ...
        k.^10.*L1.^10+36.*k.^12.*L1.^12))+83691159552000.*d.^(-1).*(6.*d+ ...
        d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.*k.^2.*L1).* ...
        atan(d.^(-1).*L1)+(-83691159552000).*d.^(-1).*(6.*d+d.^3.*k.^2+( ...
        sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*atan(d.^(-1).*L1)+( ...
        sqrt(-1)*(-83691159552000)).*(6+d.^2.*k.^2).*log(d.^2)+(sqrt(-1)* ...
        41845579776000).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt( ...
        -1).*d.^2.*k.^2.*L1).*log(d.^2+L1.^2)+41845579776000.*d.^(-1).*(( ...
        sqrt(-1)*6).*d+sqrt(-1).*d.^3.*k.^2+3.*L1+d.^2.*k.^2.*L1).*log( ...
        d.^2+L1.^2)+(-315).*k.*((-1594117324800)+(-66421555200).*d.^2.* ...
        k.^2+553512960.*d.^4.*k.^4+(-4942080).*d.^6.*k.^6+34320.*d.^8.* ...
        k.^8+(-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L1.*log((-1).*L1+( ...
        d.^2+L1.^2).^(1/2)))+(1/1339058552832000).*pi.^(-1).*((1/11).*d.^( ...
        -2).*k.^(-1).*(d.^2+(L1+(-1).*L2).^2).^(-1/2).*((-11520).*d.^16.* ...
        k.^14+5.*d.^14.*k.^12.*(93184+5283.*k.^2.*(L1+(-1).*L2).^2)+5.* ...
        d.^12.*k.^10.*((-19329024)+172718.*k.^2.*(L1+(-1).*L2).^2+14049.* ...
        k.^4.*(L1+(-1).*L2).^4)+2.*d.^10.*k.^8.*(7828254720+(-83620680).* ...
        k.^2.*(L1+(-1).*L2).^2+1036945.*k.^4.*(L1+(-1).*L2).^4+26271.* ...
        k.^6.*(L1+(-1).*L2).^6)+4.*d.^8.*k.^6.*((-511445975040)+ ...
        6238140480.*k.^2.*(L1+(-1).*L2).^2+(-70313100).*k.^4.*(L1+(-1).* ...
        L2).^4+899171.*k.^6.*(L1+(-1).*L2).^6+6894.*k.^8.*(L1+(-1).*L2) ...
        .^8)+16.*d.^6.*k.^4.*(19179224064000+(-183800897280).*k.^2.*(L1+( ...
        -1).*L2).^2+1661465520.*k.^4.*(L1+(-1).*L2).^4+(-23170290).*k.^6.* ...
        (L1+(-1).*L2).^6+183547.*k.^8.*(L1+(-1).*L2).^8+531.*k.^10.*(L1+( ...
        -1).*L2).^10)+9984.*d.^2.*(737662464000+1106493696000.*k.^2.*(L1+( ...
        -1).*L2).^2+7683984000.*k.^4.*(L1+(-1).*L2).^4+(-76839840).*k.^6.* ...
        (L1+(-1).*L2).^6+653400.*k.^8.*(L1+(-1).*L2).^8+(-4235).*k.^10.*( ...
        L1+(-1).*L2).^10+21.*k.^12.*(L1+(-1).*L2).^12)+32.*d.^4.*k.^2.*( ...
        345226033152000+11987015040000.*k.^2.*(L1+(-1).*L2).^2+( ...
        -51943731840).*k.^4.*(L1+(-1).*L2).^4+744091920.*k.^6.*(L1+(-1).* ...
        L2).^6+(-6323460).*k.^8.*(L1+(-1).*L2).^8+38311.*k.^10.*(L1+(-1).* ...
        L2).^10+36.*k.^12.*(L1+(-1).*L2).^12)+3682411020288000.*(L1+(-1).* ...
        L2).^2)+(sqrt(-1)*(-512)).*k.^2.*L1.*(315.*d.^10.*k.^10+420.* ...
        d.^8.*k.^10.*L1.^2+126.*d.^6.*k.^8.*L1.^2.*(130+3.*k.^2.*L1.^2)+ ...
        36.*d.^4.*k.^6.*L1.^2.*((-50050)+819.*k.^2.*L1.^2+5.*k.^4.*L1.^4)+ ...
        5.*d.^2.*k.^4.*L1.^2.*(25945920+(-432432).*k.^2.*L1.^2+4212.* ...
        k.^4.*L1.^4+7.*k.^6.*L1.^6)+780.*(419126400+(-6985440).*k.^2.* ...
        L1.^2+99792.*k.^4.*L1.^4+(-990).*k.^6.*L1.^6+7.*k.^8.*L1.^8)).*L2+ ...
        (sqrt(-1)*80640).*k.^4.*L1.^2.*(4.*d.^8.*k.^8+6.*d.^6.*k.^6.*(26+ ...
        k.^2.*L1.^2)+4.*d.^4.*k.^4.*((-4290)+117.*k.^2.*L1.^2+k.^4.*L1.^4) ...
        +156.*((-332640)+7920.*k.^2.*L1.^2+(-110).*k.^4.*L1.^4+k.^6.* ...
        L1.^6)+d.^2.*k.^2.*(1235520+(-34320).*k.^2.*L1.^2+468.*k.^4.* ...
        L1.^4+k.^6.*L1.^6)).*L2.^2+(sqrt(-1)*(-215040)).*k.^4.*L1.*(d.^8.* ...
        k.^8+3.*d.^6.*k.^6.*(13+k.^2.*L1.^2)+3.*d.^4.*k.^4.*((-1430)+78.* ...
        k.^2.*L1.^2+k.^4.*L1.^4)+d.^2.*k.^2.*(308880+(-17160).*k.^2.* ...
        L1.^2+351.*k.^4.*L1.^4+k.^6.*L1.^6)+78.*((-166320)+7920.*k.^2.* ...
        L1.^2+(-165).*k.^4.*L1.^4+2.*k.^6.*L1.^6)).*L2.^3+(sqrt(-1)*53760) ...
        .*k.^6.*L1.^2.*(9.*d.^6.*k.^6+3.*d.^4.*k.^4.*(234+5.*k.^2.*L1.^2)+ ...
        d.^2.*k.^2.*((-51480)+1755.*k.^2.*L1.^2+7.*k.^4.*L1.^4)+78.*( ...
        23760+(-825).*k.^2.*L1.^2+14.*k.^4.*L1.^4)).*L2.^4+(sqrt(-1)*( ...
        -64512)).*k.^6.*L1.*(3.*d.^6.*k.^6+2.*d.^4.*k.^4.*(117+5.*k.^2.* ...
        L1.^2)+156.*(3960+(-275).*k.^2.*L1.^2+7.*k.^4.*L1.^4)+d.^2.*k.^2.* ...
        ((-17160)+1170.*k.^2.*L1.^2+7.*k.^4.*L1.^4)).*L2.^5+(sqrt(-1)* ...
        53760).*k.^8.*L1.^2.*(6.*d.^4.*k.^4+156.*((-165)+7.*k.^2.*L1.^2)+ ...
        d.^2.*k.^2.*(702+7.*k.^2.*L1.^2)).*L2.^6+(sqrt(-1)*(-30720)).* ...
        k.^8.*L1.*(3.*d.^4.*k.^4+d.^2.*k.^2.*(351+7.*k.^2.*L1.^2)+78.*(( ...
        -165)+14.*k.^2.*L1.^2)).*L2.^7+(sqrt(-1)*80640).*k.^10.*(156+ ...
        d.^2.*k.^2).*L1.^2.*L2.^8+(sqrt(-1)*(-17920)).*k.^10.*(156+d.^2.* ...
        k.^2).*L1.*L2.^9+(-1/11).*k.^(-1).*(d.^2+L2.^2).^(1/2).*( ...
        3682411020288000.*d.^(-2)+(-11520).*d.^12.*k.^14+5.*d.^10.*k.^12.* ...
        (93184+7587.*k.^2.*L2.^2)+10.*d.^8.*k.^10.*((-9664512)+39767.* ...
        k.^2.*L2.^2+3231.*k.^4.*L2.^4)+12.*d.^6.*k.^8.*(1304709120+( ...
        -5883020).*k.^2.*L2.^2+139685.*k.^4.*L2.^4+1686.*k.^6.*L2.^6)+16.* ...
        d.^4.*k.^6.*((-127861493760)+581003280.*k.^2.*L2.^2+(-13166010).* ...
        k.^4.*L2.^4+120029.*k.^6.*L2.^6+459.*k.^8.*L2.^8)+32.*d.^2.*k.^4.* ...
        (9589612032000+(-27969701760).*k.^2.*L2.^2+540231120.*k.^4.*L2.^4+ ...
        (-5002140).*k.^6.*L2.^6+31759.*k.^8.*L2.^8+36.*k.^10.*L2.^10)+ ...
        9984.*(1106493696000.*k.^2+7683984000.*k.^4.*L2.^2+(-76839840).* ...
        k.^6.*L2.^4+653400.*k.^8.*L2.^6+(-4235).*k.^10.*L2.^8+21.*k.^12.* ...
        L2.^10+368831232000.*(d.^2+L2.^2).^(-1)))+83691159552000.*d.^(-1) ...
        .*(6.*d+d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.* ...
        k.^2.*L1).*atan(d.^(-1).*(L1+(-1).*L2))+(-83691159552000).*d.^(-1) ...
        .*(6.*d+d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).* ...
        atan(d.^(-1).*(L1+(-1).*L2))+(sqrt(-1)*167382319104000).*d.^(-1).* ...
        (3+d.^2.*k.^2).*L2.*atan(d.^(-1).*(L1+(-1).*L2))+(sqrt(-1)* ...
        167382319104000).*d.^(-1).*(3+d.^2.*k.^2).*L2.*atan(d.^(-1).*L2)+( ...
        sqrt(-1)*41845579776000).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)*3).* ...
        L1+sqrt(-1).*d.^2.*k.^2.*L1).*log(d.^2+(L1+(-1).*L2).^2)+ ...
        41845579776000.*d.^(-1).*((sqrt(-1)*6).*d+sqrt(-1).*d.^3.*k.^2+3.* ...
        L1+d.^2.*k.^2.*L1).*log(d.^2+(L1+(-1).*L2).^2)+(-315).*k.*(( ...
        -1594117324800)+(-66421555200).*d.^2.*k.^2+553512960.*d.^4.*k.^4+( ...
        -4942080).*d.^6.*k.^6+34320.*d.^8.*k.^8+(-182).*d.^10.*k.^10+9.* ...
        d.^12.*k.^12).*L2.*log(L1+(d.^2+(L1+(-1).*L2).^2).^(1/2)+(-1).*L2) ...
        +(-315).*k.*((-1594117324800)+(-66421555200).*d.^2.*k.^2+ ...
        553512960.*d.^4.*k.^4+(-4942080).*d.^6.*k.^6+34320.*d.^8.*k.^8+( ...
        -182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L1.*log((-1).*L1+(d.^2+(L1+( ...
        -1).*L2).^2).^(1/2)+L2)+(sqrt(-1)*(-83691159552000)).*(6+d.^2.* ...
        k.^2).*log(d.^2+L2.^2)+315.*k.*((-1594117324800)+(-66421555200).* ...
        d.^2.*k.^2+553512960.*d.^4.*k.^4+(-4942080).*d.^6.*k.^6+34320.* ...
        d.^8.*k.^8+(-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L2.*log((-1).* ...
        L2+(d.^2+L2.^2).^(1/2)));
    
elseif order == 10
H6_total=(-3/4).*(d.^2).^(1/2).*k.^4.*((-1/3).*d.^(-2).*k.^(-5)+( ...
1/8630650828800).*d.^(-2).*k.^(-5).*((-2876883609600)+( ...
-8630650828800).*d.^2.*k.^2+(-239740300800).*d.^4.*k.^4+ ...
1598268672.*d.^6.*k.^6+(-12231648).*d.^8.*k.^8+75504.*d.^10.* ...
k.^10+(-364).*d.^12.*k.^12+9.*d.^14.*k.^14)).*pi.^(-1)+(3/4).* ...
k.^4.*(d.^2+L1.^2).^(1/2).*((-1/3).*k.^(-5).*(d.^2+L1.^2).^(-1)+( ...
1/11047233060864000).*d.^(-2).*k.^(-5).*((-3682411020288000)+( ...
-11047233060864000).*d.^2.*k.^2+(-306867585024000).*d.^4.*k.^4+ ...
2045783900160.*d.^6.*k.^6+(-15656509440).*d.^8.*k.^8+96645120.* ...
d.^10.*k.^10+(-465920).*d.^12.*k.^12+11520.*d.^14.*k.^14+( ...
-76716896256000).*d.^2.*k.^4.*L1.^2+895030456320.*d.^4.*k.^6.* ...
L1.^2+(-9296052480).*d.^6.*k.^8.*L1.^2+70596240.*d.^8.*k.^10.* ...
L1.^2+(-397670).*d.^10.*k.^12.*L1.^2+(-37935).*d.^12.*k.^14.* ...
L1.^2+767168962560.*d.^2.*k.^6.*L1.^4+(-17287395840).*d.^4.*k.^8.* ...
L1.^4+210656160.*d.^6.*k.^10.*L1.^4+(-1676220).*d.^8.*k.^12.* ...
L1.^4+(-32310).*d.^10.*k.^14.*L1.^4+(-6523545600).*d.^2.*k.^8.* ...
L1.^6+160068480.*d.^4.*k.^10.*L1.^6+(-1920464).*d.^6.*k.^12.* ...
L1.^6+(-20232).*d.^8.*k.^14.*L1.^6+42282240.*d.^2.*k.^10.*L1.^8+( ...
-1016288).*d.^4.*k.^12.*L1.^8+(-7344).*d.^6.*k.^14.*L1.^8+( ...
-209664).*d.^2.*k.^12.*L1.^10+(-1152).*d.^4.*k.^14.*L1.^10)).* ...
pi.^(-1)+(-3/4).*k.^4.*((sqrt(-1)*(1/6)).*k.^(-2).*L1+(sqrt(-1)*( ...
-1/360)).*L1.^3+(sqrt(-1)*(-1/1080)).*d.^2.*k.^2.*L1.^3+(sqrt(-1)* ...
(1/54432)).*d.^4.*k.^4.*L1.^3+(sqrt(-1)*(-13/59875200)).*d.^6.* ...
k.^6.*L1.^3+(sqrt(-1)*(1/583783200)).*d.^8.*k.^8.*L1.^3+(sqrt(-1)* ...
(-1/35663846400)).*d.^10.*k.^10.*L1.^3+(sqrt(-1)*(1/1200)).*k.^2.* ...
L1.^5+(sqrt(-1)*(-19/604800)).*d.^2.*k.^4.*L1.^5+(sqrt(-1)*( ...
1/1848000)).*d.^4.*k.^6.*L1.^5+(sqrt(-1)*(-29/5189184000)).*d.^6.* ...
k.^8.*L1.^5+(sqrt(-1)*(-1/18162144000)).*d.^8.*k.^10.*L1.^5+(sqrt( ...
-1)*(-1/70560)).*k.^4.*L1.^7+(sqrt(-1)*(17/34927200)).*d.^2.* ...
k.^6.*L1.^7+(sqrt(-1)*(-41/5448643200)).*d.^4.*k.^8.*L1.^7+(sqrt( ...
-1)*(-1/18307441152)).*d.^6.*k.^10.*L1.^7+(sqrt(-1)*(1/6531840)).* ...
k.^6.*L1.^9+(sqrt(-1)*(-53/11208637440)).*d.^2.*k.^8.*L1.^9+(sqrt( ...
-1)*(-1/36778341600)).*d.^4.*k.^10.*L1.^9+(sqrt(-1)*(-1/878169600) ...
).*k.^8.*L1.^11+(sqrt(-1)*(-1/184415616000)).*d.^2.*k.^10.*L1.^11+ ...
(sqrt(-1)*(-1/2520)).*(d.^4.*k.^2.*L1+(-3).*d.^2.*k.^2.*L1.^3)+( ...
sqrt(-1)*(1/560)).*(d.^2.*k.^2.*L1.^3+(-1).*k.^2.*L1.^5)+(sqrt(-1) ...
*(1/5040)).*(2.*d.^4.*k.^2.*L1+(-10).*d.^2.*k.^2.*L1.^3+5.*k.^2.* ...
L1.^5)+(sqrt(-1)*(1/120960)).*(7.*d.^4.*k.^4.*L1.^3+(-5).*d.^2.* ...
k.^4.*L1.^5)+(sqrt(-1)*(1/831600)).*(d.^6.*k.^6.*L1.^3+(-1).* ...
d.^4.*k.^6.*L1.^5)+(sqrt(-1)*(1/10897286400)).*(d.^10.*k.^10.* ...
L1.^3+(-1).*d.^8.*k.^10.*L1.^5)+(sqrt(-1)*(-1/65383718400)).*( ...
d.^12.*k.^10.*L1+(-10).*d.^10.*k.^10.*L1.^3+5.*d.^8.*k.^10.*L1.^5) ...
+(sqrt(-1)*(-1/20160)).*(3.*d.^2.*k.^4.*L1.^5+(-1).*k.^4.*L1.^7)+( ...
sqrt(-1)*(-1/30240)).*(d.^4.*k.^4.*L1.^3+(-10).*d.^2.*k.^4.*L1.^5+ ...
3.*k.^4.*L1.^7)+(sqrt(-1)*(1/36288)).*(3.*d.^4.*k.^4.*L1.^3+(-10) ...
.*d.^2.*k.^4.*L1.^5+3.*k.^4.*L1.^7)+(sqrt(-1)*(-1/362880)).*(46.* ...
d.^4.*k.^4.*L1.^3+(-60).*d.^2.*k.^4.*L1.^5+7.*k.^4.*L1.^7)+(sqrt( ...
-1)*(17/14968800)).*(d.^6.*k.^6.*L1.^3+(-10).*d.^4.*k.^6.*L1.^5+ ...
3.*d.^2.*k.^6.*L1.^7)+(sqrt(-1)*(-1/4989600)).*(d.^8.*k.^6.*L1+( ...
-12).*d.^6.*k.^6.*L1.^3+(-8).*d.^4.*k.^6.*L1.^5+5.*d.^2.*k.^6.* ...
L1.^7)+(sqrt(-1)*(-41/1556755200)).*(3.*d.^6.*k.^8.*L1.^5+(-1).* ...
d.^4.*k.^8.*L1.^7)+(sqrt(-1)*(-41/2335132800)).*(d.^8.*k.^8.* ...
L1.^3+(-10).*d.^6.*k.^8.*L1.^5+3.*d.^4.*k.^8.*L1.^7)+(sqrt(-1)*( ...
-1/622702080)).*(11.*d.^8.*k.^8.*L1.^3+(-30).*d.^6.*k.^8.*L1.^5+ ...
7.*d.^4.*k.^8.*L1.^7)+(sqrt(-1)*(1/3113510400)).*(99.*d.^8.*k.^8.* ...
L1.^3+(-421).*d.^6.*k.^8.*L1.^5+138.*d.^4.*k.^8.*L1.^7)+(sqrt(-1)* ...
(1/87178291200)).*(2.*d.^12.*k.^10.*L1+(-24).*d.^10.*k.^10.*L1.^3+ ...
35.*d.^8.*k.^10.*L1.^5+(-7).*d.^6.*k.^10.*L1.^7)+(sqrt(-1)*( ...
-1/5230697472)).*(3.*d.^8.*k.^10.*L1.^5+(-1).*d.^6.*k.^10.*L1.^7)+ ...
(sqrt(-1)*(-1/7846046208)).*(d.^10.*k.^10.*L1.^3+(-10).*d.^8.* ...
k.^10.*L1.^5+3.*d.^6.*k.^10.*L1.^7)+(sqrt(-1)*(1/9340531200)).*( ...
d.^10.*k.^10.*L1.^3+(-8).*d.^8.*k.^10.*L1.^5+3.*d.^6.*k.^10.* ...
L1.^7)+(sqrt(-1)*(1/6652800)).*(d.^8.*k.^6.*L1+(-2).*d.^6.*k.^6.* ...
L1.^3+(-51).*d.^4.*k.^6.*L1.^5+56.*d.^2.*k.^6.*L1.^7+(-8).*k.^6.* ...
L1.^9)+(sqrt(-1)*(-1/2177280)).*(d.^6.*k.^6.*L1.^3+(-21).*d.^4.* ...
k.^6.*L1.^5+35.*d.^2.*k.^6.*L1.^7+(-5).*k.^6.*L1.^9)+(sqrt(-1)*( ...
1/777600)).*(d.^4.*k.^6.*L1.^5+(-6).*d.^2.*k.^6.*L1.^7+k.^6.* ...
L1.^9)+(sqrt(-1)*(-1/1088640)).*(6.*d.^4.*k.^6.*L1.^5+(-19).* ...
d.^2.*k.^6.*L1.^7+3.*k.^6.*L1.^9)+(sqrt(-1)*(53/3736212480)).*( ...
d.^8.*k.^8.*L1.^3+(-21).*d.^6.*k.^8.*L1.^5+35.*d.^4.*k.^8.*L1.^7+( ...
-5).*d.^2.*k.^8.*L1.^9)+(sqrt(-1)*(1/415134720)).*(11.*d.^8.* ...
k.^8.*L1.^3+(-42).*d.^6.*k.^8.*L1.^5+28.*d.^4.*k.^8.*L1.^7+(-3).* ...
d.^2.*k.^8.*L1.^9)+(sqrt(-1)*(-53/1334361600)).*(d.^6.*k.^8.* ...
L1.^5+(-6).*d.^4.*k.^8.*L1.^7+d.^2.*k.^8.*L1.^9)+(sqrt(-1)*( ...
53/1868106240)).*(6.*d.^6.*k.^8.*L1.^5+(-19).*d.^4.*k.^8.*L1.^7+ ...
3.*d.^2.*k.^8.*L1.^9)+(sqrt(-1)*(1/12259447200)).*(d.^10.*k.^10.* ...
L1.^3+(-21).*d.^8.*k.^10.*L1.^5+35.*d.^6.*k.^10.*L1.^7+(-5).* ...
d.^4.*k.^10.*L1.^9)+(sqrt(-1)*(-1/18681062400)).*(3.*d.^10.* ...
k.^10.*L1.^3+(-28).*d.^8.*k.^10.*L1.^5+28.*d.^6.*k.^10.*L1.^7+(-4) ...
.*d.^4.*k.^10.*L1.^9)+(sqrt(-1)*(-1/4378374000)).*(d.^8.*k.^10.* ...
L1.^5+(-6).*d.^6.*k.^10.*L1.^7+d.^4.*k.^10.*L1.^9)+(sqrt(-1)*( ...
1/6129723600)).*(6.*d.^8.*k.^10.*L1.^5+(-19).*d.^6.*k.^10.*L1.^7+ ...
3.*d.^4.*k.^10.*L1.^9)+(sqrt(-1)*(-1/217945728000)).*(2.*d.^12.* ...
k.^10.*L1+(-36).*d.^10.*k.^10.*L1.^3+126.*d.^8.*k.^10.*L1.^5+(-84) ...
.*d.^6.*k.^10.*L1.^7+9.*d.^4.*k.^10.*L1.^9)+(sqrt(-1)*( ...
-1/95800320)).*(8.*d.^6.*k.^8.*L1.^5+(-56).*d.^4.*k.^8.*L1.^7+55.* ...
d.^2.*k.^8.*L1.^9+(-5).*k.^8.*L1.^11)+(sqrt(-1)*(1/53222400)).*( ...
d.^6.*k.^8.*L1.^5+(-21).*d.^4.*k.^8.*L1.^7+31.*d.^2.*k.^8.*L1.^9+( ...
-3).*k.^8.*L1.^11)+(sqrt(-1)*(1/39916800)).*(2.*d.^8.*k.^6.*L1+( ...
-150).*d.^6.*k.^6.*L1.^3+506.*d.^4.*k.^6.*L1.^5+(-198).*d.^2.* ...
k.^6.*L1.^7+5.*d.^4.*k.^8.*L1.^7+9.*k.^6.*L1.^9+(-10).*d.^2.* ...
k.^8.*L1.^9+k.^8.*L1.^11)+(sqrt(-1)*(1/444787200)).*(5.*d.^8.* ...
k.^8.*L1.^3+(-60).*d.^6.*k.^8.*L1.^5+126.*d.^4.*k.^8.*L1.^7+(-60) ...
.*d.^2.*k.^8.*L1.^9+5.*k.^8.*L1.^11)+(sqrt(-1)*(-1/239500800)).*( ...
d.^8.*k.^8.*L1.^3+(-36).*d.^6.*k.^8.*L1.^5+126.*d.^4.*k.^8.*L1.^7+ ...
(-84).*d.^2.*k.^8.*L1.^9+7.*k.^8.*L1.^11)+(sqrt(-1)*( ...
-1/6227020800)).*(287.*d.^8.*k.^8.*L1.^3+(-1954).*d.^6.*k.^8.* ...
L1.^5+2086.*d.^4.*k.^8.*L1.^7+(-397).*d.^2.*k.^8.*L1.^9+11.*k.^8.* ...
L1.^11)+(sqrt(-1)*(1/1307674368000)).*(d.^12.*k.^10.*L1+(-55).* ...
d.^10.*k.^10.*L1.^3+330.*d.^8.*k.^10.*L1.^5+(-462).*d.^6.*k.^10.* ...
L1.^7+165.*d.^4.*k.^10.*L1.^9+(-11).*d.^2.*k.^10.*L1.^11)+(sqrt( ...
-1)*(-1/20118067200)).*(8.*d.^8.*k.^10.*L1.^5+(-56).*d.^6.*k.^10.* ...
L1.^7+55.*d.^4.*k.^10.*L1.^9+(-5).*d.^2.*k.^10.*L1.^11)+(sqrt(-1)* ...
(1/11176704000)).*(d.^8.*k.^10.*L1.^5+(-21).*d.^6.*k.^10.*L1.^7+ ...
31.*d.^4.*k.^10.*L1.^9+(-3).*d.^2.*k.^10.*L1.^11)+(sqrt(-1)*( ...
1/8382528000)).*(5.*d.^6.*k.^10.*L1.^7+(-10).*d.^4.*k.^10.*L1.^9+ ...
d.^2.*k.^10.*L1.^11)+(sqrt(-1)*(1/93405312000)).*(5.*d.^10.* ...
k.^10.*L1.^3+(-60).*d.^8.*k.^10.*L1.^5+126.*d.^6.*k.^10.*L1.^7+( ...
-60).*d.^4.*k.^10.*L1.^9+5.*d.^2.*k.^10.*L1.^11)+(sqrt(-1)*( ...
-1/50295168000)).*(d.^10.*k.^10.*L1.^3+(-36).*d.^8.*k.^10.*L1.^5+ ...
126.*d.^6.*k.^10.*L1.^7+(-84).*d.^4.*k.^10.*L1.^9+7.*d.^2.*k.^10.* ...
L1.^11)).*L2.*pi.^(-1)+(sqrt(-1)*(-1/3487131648000)).*k.^4.*( ...
10897286400.*L1.^2+(-259459200).*d.^2.*k.^2.*L1.^2+3603600.*d.^4.* ...
k.^4.*L1.^2+(-32760).*d.^6.*k.^6.*L1.^2+210.*d.^8.*k.^8.*L1.^2+5.* ...
d.^10.*k.^10.*L1.^2+(-259459200).*k.^2.*L1.^4+7207200.*d.^2.* ...
k.^4.*L1.^4+(-98280).*d.^4.*k.^6.*L1.^4+840.*d.^6.*k.^8.*L1.^4+ ...
10.*d.^8.*k.^10.*L1.^4+3603600.*k.^4.*L1.^6+(-98280).*d.^2.*k.^6.* ...
L1.^6+1260.*d.^4.*k.^8.*L1.^6+10.*d.^6.*k.^10.*L1.^6+(-32760).* ...
k.^6.*L1.^8+840.*d.^2.*k.^8.*L1.^8+5.*d.^4.*k.^10.*L1.^8+210.* ...
k.^8.*L1.^10+d.^2.*k.^10.*L1.^10).*L2.^2.*pi.^(-1)+(sqrt(-1)*( ...
1/1046139494400)).*k.^4.*(2179457280.*L1+(-51891840).*d.^2.*k.^2.* ...
L1+720720.*d.^4.*k.^4.*L1+(-6552).*d.^6.*k.^6.*L1+42.*d.^8.*k.^8.* ...
L1+d.^10.*k.^10.*L1+(-103783680).*k.^2.*L1.^3+2882880.*d.^2.* ...
k.^4.*L1.^3+(-39312).*d.^4.*k.^6.*L1.^3+336.*d.^6.*k.^8.*L1.^3+4.* ...
d.^8.*k.^10.*L1.^3+2162160.*k.^4.*L1.^5+(-58968).*d.^2.*k.^6.* ...
L1.^5+756.*d.^4.*k.^8.*L1.^5+6.*d.^6.*k.^10.*L1.^5+(-26208).* ...
k.^6.*L1.^7+672.*d.^2.*k.^8.*L1.^7+4.*d.^4.*k.^10.*L1.^7+210.* ...
k.^8.*L1.^9+d.^2.*k.^10.*L1.^9).*L2.^3.*pi.^(-1)+(sqrt(-1)*( ...
-1/4184557977600)).*k.^4.*((-311351040).*k.^2.*L1.^2+8648640.* ...
d.^2.*k.^4.*L1.^2+(-117936).*d.^4.*k.^6.*L1.^2+1008.*d.^6.*k.^8.* ...
L1.^2+12.*d.^8.*k.^10.*L1.^2+10810800.*k.^4.*L1.^4+(-294840).* ...
d.^2.*k.^6.*L1.^4+3780.*d.^4.*k.^8.*L1.^4+30.*d.^6.*k.^10.*L1.^4+( ...
-183456).*k.^6.*L1.^6+4704.*d.^2.*k.^8.*L1.^6+28.*d.^4.*k.^10.* ...
L1.^6+1890.*k.^8.*L1.^8+9.*d.^2.*k.^10.*L1.^8).*L2.^4.*pi.^(-1)+( ...
sqrt(-1)*(1/871782912000)).*k.^4.*((-25945920).*k.^2.*L1+720720.* ...
d.^2.*k.^4.*L1+(-9828).*d.^4.*k.^6.*L1+84.*d.^6.*k.^8.*L1+d.^8.* ...
k.^10.*L1+1801800.*k.^4.*L1.^3+(-49140).*d.^2.*k.^6.*L1.^3+630.* ...
d.^4.*k.^8.*L1.^3+5.*d.^6.*k.^10.*L1.^3+(-45864).*k.^6.*L1.^5+ ...
1176.*d.^2.*k.^8.*L1.^5+7.*d.^4.*k.^10.*L1.^5+630.*k.^8.*L1.^7+3.* ...
d.^2.*k.^10.*L1.^7).*L2.^5.*pi.^(-1)+(sqrt(-1)*(-1/5230697472000)) ...
.*k.^4.*(5405400.*k.^4.*L1.^2+(-147420).*d.^2.*k.^6.*L1.^2+1890.* ...
d.^4.*k.^8.*L1.^2+15.*d.^6.*k.^10.*L1.^2+(-229320).*k.^6.*L1.^4+ ...
5880.*d.^2.*k.^8.*L1.^4+35.*d.^4.*k.^10.*L1.^4+4410.*k.^8.*L1.^6+ ...
21.*d.^2.*k.^10.*L1.^6).*L2.^6.*pi.^(-1)+(sqrt(-1)*( ...
1/18307441152000)).*k.^4.*(5405400.*k.^4.*L1+(-147420).*d.^2.* ...
k.^6.*L1+1890.*d.^4.*k.^8.*L1+15.*d.^6.*k.^10.*L1+(-458640).* ...
k.^6.*L1.^3+11760.*d.^2.*k.^8.*L1.^3+70.*d.^4.*k.^10.*L1.^3+ ...
13230.*k.^8.*L1.^5+63.*d.^2.*k.^10.*L1.^5).*L2.^7.*pi.^(-1)+(sqrt( ...
-1)*(-1/1394852659200)).*k.^10.*L1.^2.*((-13104)+336.*d.^2.*k.^2+ ...
2.*d.^4.*k.^4+630.*k.^2.*L1.^2+3.*d.^2.*k.^4.*L1.^2).*L2.^8.*pi.^( ...
-1)+(sqrt(-1)*(1/3138418483200)).*k.^10.*L1.*((-6552)+168.*d.^2.* ...
k.^2+d.^4.*k.^4+630.*k.^2.*L1.^2+3.*d.^2.*k.^4.*L1.^2).*L2.^9.* ...
pi.^(-1)+(sqrt(-1)*(-1/3487131648000)).*k.^12.*(210+d.^2.*k.^2).* ...
L1.^2.*L2.^10.*pi.^(-1)+(sqrt(-1)*(1/19179224064000)).*k.^12.*( ...
210+d.^2.*k.^2).*L1.*L2.^11.*pi.^(-1)+(3/4).*k.^4.*(d.^2+L2.^2).^( ...
1/2).*((1/8630650828800).*d.^(-2).*k.^(-5).*((-2876883609600)+( ...
-8630650828800).*d.^2.*k.^2+(-239740300800).*d.^4.*k.^4+ ...
1598268672.*d.^6.*k.^6+(-12231648).*d.^8.*k.^8+75504.*d.^10.* ...
k.^10+(-364).*d.^12.*k.^12+9.*d.^14.*k.^14)+(-1/2209446612172800) ...
.*k.^(-1).*(15343379251200+(-179006091264).*d.^2.*k.^2+ ...
1859210496.*d.^4.*k.^4+(-14119248).*d.^6.*k.^6+79534.*d.^8.*k.^8+ ...
7587.*d.^10.*k.^10).*L2.^2+(-1/368241102028800).*k.*(( ...
-25572298752)+576246528.*d.^2.*k.^2+(-7021872).*d.^4.*k.^4+55874.* ...
d.^6.*k.^6+1077.*d.^8.*k.^8).*L2.^4+(-1/1380904132608000).*k.^3.*( ...
815443200+(-20008560).*d.^2.*k.^2+240058.*d.^4.*k.^4+2529.*d.^6.* ...
k.^6).*L2.^6+(-1/690452066304000).*k.^5.*((-2642640)+63518.*d.^2.* ...
k.^2+459.*d.^4.*k.^4).*L2.^8+(-1/9589612032000).*k.^7.*(182+d.^2.* ...
k.^2).*L2.^10+(-1/3).*k.^(-5).*(d.^2+L2.^2).^(-1)).*pi.^(-1)+( ...
-3/4).*k.^4.*(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(1/2).*(( ...
1/11047233060864000).*d.^(-2).*k.^(-5).*((-3682411020288000)+( ...
-11047233060864000).*d.^2.*k.^2+(-306867585024000).*d.^4.*k.^4+ ...
2045783900160.*d.^6.*k.^6+(-15656509440).*d.^8.*k.^8+96645120.* ...
d.^10.*k.^10+(-465920).*d.^12.*k.^12+11520.*d.^14.*k.^14+( ...
-76716896256000).*d.^2.*k.^4.*L1.^2+895030456320.*d.^4.*k.^6.* ...
L1.^2+(-9296052480).*d.^6.*k.^8.*L1.^2+70596240.*d.^8.*k.^10.* ...
L1.^2+(-397670).*d.^10.*k.^12.*L1.^2+(-37935).*d.^12.*k.^14.* ...
L1.^2+767168962560.*d.^2.*k.^6.*L1.^4+(-17287395840).*d.^4.*k.^8.* ...
L1.^4+210656160.*d.^6.*k.^10.*L1.^4+(-1676220).*d.^8.*k.^12.* ...
L1.^4+(-32310).*d.^10.*k.^14.*L1.^4+(-6523545600).*d.^2.*k.^8.* ...
L1.^6+160068480.*d.^4.*k.^10.*L1.^6+(-1920464).*d.^6.*k.^12.* ...
L1.^6+(-20232).*d.^8.*k.^14.*L1.^6+42282240.*d.^2.*k.^10.*L1.^8+( ...
-1016288).*d.^4.*k.^12.*L1.^8+(-7344).*d.^6.*k.^14.*L1.^8+( ...
-209664).*d.^2.*k.^12.*L1.^10+(-1152).*d.^4.*k.^14.*L1.^10)+( ...
1/5523616530432000).*k.^(-1).*L1.*(76716896256000+(-895030456320) ...
.*d.^2.*k.^2+9296052480.*d.^4.*k.^4+(-70596240).*d.^6.*k.^6+ ...
397670.*d.^8.*k.^8+37935.*d.^10.*k.^10+(-1534337925120).*k.^2.* ...
L1.^2+34574791680.*d.^2.*k.^4.*L1.^2+(-421312320).*d.^4.*k.^6.* ...
L1.^2+3352440.*d.^6.*k.^8.*L1.^2+64620.*d.^8.*k.^10.*L1.^2+ ...
19570636800.*k.^4.*L1.^4+(-480205440).*d.^2.*k.^6.*L1.^4+5761392.* ...
d.^4.*k.^8.*L1.^4+60696.*d.^6.*k.^10.*L1.^4+(-169128960).*k.^6.* ...
L1.^6+4065152.*d.^2.*k.^8.*L1.^6+29376.*d.^4.*k.^10.*L1.^6+ ...
1048320.*k.^8.*L1.^8+5760.*d.^2.*k.^10.*L1.^8).*L2+( ...
-1/11047233060864000).*k.^(-1).*(76716896256000+(-895030456320).* ...
d.^2.*k.^2+9296052480.*d.^4.*k.^4+(-70596240).*d.^6.*k.^6+397670.* ...
d.^8.*k.^8+37935.*d.^10.*k.^10+(-4603013775360).*k.^2.*L1.^2+ ...
103724375040.*d.^2.*k.^4.*L1.^2+(-1263936960).*d.^4.*k.^6.*L1.^2+ ...
10057320.*d.^6.*k.^8.*L1.^2+193860.*d.^8.*k.^10.*L1.^2+ ...
97853184000.*k.^4.*L1.^4+(-2401027200).*d.^2.*k.^6.*L1.^4+ ...
28806960.*d.^4.*k.^8.*L1.^4+303480.*d.^6.*k.^10.*L1.^4+( ...
-1183902720).*k.^6.*L1.^6+28456064.*d.^2.*k.^8.*L1.^6+205632.* ...
d.^4.*k.^10.*L1.^6+9434880.*k.^8.*L1.^8+51840.*d.^2.*k.^10.*L1.^8) ...
.*L2.^2+(1/1380904132608000).*k.*L1.*((-383584481280)+8643697920.* ...
d.^2.*k.^2+(-105328080).*d.^4.*k.^4+838110.*d.^6.*k.^6+16155.* ...
d.^8.*k.^8+16308864000.*k.^2.*L1.^2+(-400171200).*d.^2.*k.^4.* ...
L1.^2+4801160.*d.^4.*k.^6.*L1.^2+50580.*d.^6.*k.^8.*L1.^2+( ...
-295975680).*k.^4.*L1.^4+7114016.*d.^2.*k.^6.*L1.^4+51408.*d.^4.* ...
k.^8.*L1.^4+3144960.*k.^6.*L1.^6+17280.*d.^2.*k.^8.*L1.^6).*L2.^3+ ...
(-1/1104723306086400).*k.*((-76716896256)+1728739584.*d.^2.*k.^2+( ...
-21065616).*d.^4.*k.^4+167622.*d.^6.*k.^6+3231.*d.^8.*k.^8+ ...
9785318400.*k.^2.*L1.^2+(-240102720).*d.^2.*k.^4.*L1.^2+2880696.* ...
d.^4.*k.^6.*L1.^2+30348.*d.^6.*k.^8.*L1.^2+(-295975680).*k.^4.* ...
L1.^4+7114016.*d.^2.*k.^6.*L1.^4+51408.*d.^4.*k.^8.*L1.^4+ ...
4402944.*k.^6.*L1.^6+24192.*d.^2.*k.^8.*L1.^6).*L2.^4+( ...
1/690452066304000).*k.^3.*L1.*(2446329600+(-60025680).*d.^2.*k.^2+ ...
720174.*d.^4.*k.^4+7587.*d.^6.*k.^6+(-147987840).*k.^2.*L1.^2+ ...
3557008.*d.^2.*k.^4.*L1.^2+25704.*d.^4.*k.^6.*L1.^2+3302208.* ...
k.^4.*L1.^4+18144.*d.^2.*k.^6.*L1.^4).*L2.^5+(-1/1380904132608000) ...
.*k.^3.*(815443200+(-20008560).*d.^2.*k.^2+240058.*d.^4.*k.^4+ ...
2529.*d.^6.*k.^6+(-147987840).*k.^2.*L1.^2+3557008.*d.^2.*k.^4.* ...
L1.^2+25704.*d.^4.*k.^6.*L1.^2+5503680.*k.^4.*L1.^4+30240.*d.^2.* ...
k.^6.*L1.^4).*L2.^6+(1/86306508288000).*k.^5.*L1.*((-2642640)+ ...
63518.*d.^2.*k.^2+459.*d.^4.*k.^4+196560.*k.^2.*L1.^2+1080.*d.^2.* ...
k.^4.*L1.^2).*L2.^7+(-1/690452066304000).*k.^5.*((-2642640)+ ...
63518.*d.^2.*k.^2+459.*d.^4.*k.^4+589680.*k.^2.*L1.^2+3240.*d.^2.* ...
k.^4.*L1.^2).*L2.^8+(1/958961203200).*k.^7.*(182+d.^2.*k.^2).*L1.* ...
L2.^9+(-1/9589612032000).*k.^7.*(182+d.^2.*k.^2).*L2.^10+(-1/3).* ...
k.^(-5).*(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(-1)).*pi.^(-1)+(-1/16) ...
.*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).* ...
d.^2.*k.^2.*L1).*pi.^(-1).*atan(d.^(-1).*L1)+(1/16).*d.^(-1).*(6.* ...
d+d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*pi.^(-1) ...
.*atan(d.^(-1).*L1)+(-1/16).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)* ...
3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*pi.^(-1).*atan(d.^(-1).*(L1+(-1) ...
.*L2))+(sqrt(-1)*(1/8)).*d.^(-1).*(3+d.^2.*k.^2).*L2.*pi.^(-1).* ...
atan(d.^(-1).*(L1+(-1).*L2))+(sqrt(-1)*(1/8)).*d.^(-1).*(3+d.^2.* ...
k.^2).*L2.*pi.^(-1).*atan(d.^(-1).*L2)+(-1/16).*d.^(-1).*(6.*d+ ...
d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.*k.^2.*L1).* ...
pi.^(-1).*atan(d.^(-1).*((-1).*L1+L2))+(sqrt(-1)*(1/16)).*(6+ ...
d.^2.*k.^2).*pi.^(-1).*log(d.^2)+(sqrt(-1)*(-1/32)).*d.^(-1).*(6.* ...
d+d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.*k.^2.*L1) ...
.*pi.^(-1).*log(d.^2+L1.^2)+(sqrt(-1)*(-1/32)).*d.^(-1).*(6.*d+ ...
d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt(-1).*d.^2.*k.^2.*L1).*pi.^(-1).* ...
log(d.^2+L1.^2)+(1/4250979532800).*k.*((-1594117324800)+( ...
-66421555200).*d.^2.*k.^2+553512960.*d.^4.*k.^4+(-4942080).*d.^6.* ...
k.^6+34320.*d.^8.*k.^8+(-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L1.* ...
pi.^(-1).*log((-1).*L1+(d.^2+L1.^2).^(1/2))+(sqrt(-1)*(-1/16)).*( ...
6+d.^2.*k.^2).*pi.^(-1).*log(d.^2+L2.^2)+(sqrt(-1)*(1/32)).*d.^( ...
-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)*(-3)).*L1+(sqrt(-1)*(-1)).*d.^2.* ...
k.^2.*L1).*pi.^(-1).*log(d.^2+L1.^2+(-2).*L1.*L2+L2.^2)+(sqrt(-1)* ...
(1/32)).*d.^(-1).*(6.*d+d.^3.*k.^2+(sqrt(-1)*3).*L1+sqrt(-1).* ...
d.^2.*k.^2.*L1).*pi.^(-1).*log(d.^2+L1.^2+(-2).*L1.*L2+L2.^2)+( ...
1/4250979532800).*k.*((-1594117324800)+(-66421555200).*d.^2.*k.^2+ ...
553512960.*d.^4.*k.^4+(-4942080).*d.^6.*k.^6+34320.*d.^8.*k.^8+( ...
-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L2.*pi.^(-1).*log((-1).*L2+( ...
d.^2+L2.^2).^(1/2))+(-1/4250979532800).*k.*((-1594117324800)+( ...
-66421555200).*d.^2.*k.^2+553512960.*d.^4.*k.^4+(-4942080).*d.^6.* ...
k.^6+34320.*d.^8.*k.^8+(-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L2.* ...
pi.^(-1).*log(L1+(-1).*L2+(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(1/2))+ ...
(-1/4250979532800).*k.*((-1594117324800)+(-66421555200).*d.^2.* ...
k.^2+553512960.*d.^4.*k.^4+(-4942080).*d.^6.*k.^6+34320.*d.^8.* ...
k.^8+(-182).*d.^10.*k.^10+9.*d.^12.*k.^12).*L1.*pi.^(-1).*log((-1) ...
.*L1+L2+(d.^2+L1.^2+(-2).*L1.*L2+L2.^2).^(1/2));
else    
    error('Calculations of that order-number not calculated')
end
end

