function [ Zin ] = partialcells(ZL, L_ant, a,  w1, w2, h1, h2, rad, eps1, eps2, f, viaflag)
% Deals with partial unit cells in multilayer HIStrip model
g=a-w2;
N=floor(0.5*L_ant/a);
remainder = 0.5*L_ant-N*a;

%account for partial unit cell on the bottom, also
bot_remainder=a-remainder;
%building blocks for bottom cells
[ABCD, ABCDgaphalf1,ABCDline,ABCDL, ABCDgaphalf2] = HISlayerABCD(w2, g, h2, rad, eps2, f, viaflag, eps1);
deltaL_bot=microstripdeltaL(w2,h2,eps2);
epseff2=epseff(w2,h2,eps2);
betab=2*pi*f*sqrt(epseff2);
Z0 = microstripZ0_pozar(w2,h2,eps2);
if bot_remainder<g/2
    temp={ABCDgaphalf2};
elseif bot_remainder<a/2
    %other half of gap cap and TL length
    l=bot_remainder-g/2;
    ABCDlseg = [cos(betab*l) 1i*Z0*sin(betab*l); 1i*sin(betab*l)/Z0 cos(betab*l)];
    temp = {ABCDlseg, ABCDgaphalf2};
elseif bot_remainder==a/2
    temp = {ABCDL, ABCDline, ABCDgaphalf2};
elseif bot_remainder<a-g/2
    l=bot_remainder-a/2-g/2;
    ABCDlseg = [cos(betab*l) 1i*Z0*sin(betab*l); 1i*sin(betab*l)/Z0 cos(betab*l)];
    temp = {ABCDlseg, ABCDL, ABCDline, ABCDgaphalf2};
else
    temp = {ABCDgaphalf1, ABCDline, ABCDL, ABCDline, ABCDgaphalf2};
end

ZinL=ZL(2,2);
for ii=1:length(temp)
    ZinL=unitcellMultiply(ZinL,temp{ii},1);
end


%building blocks for upper cells
[Cgapmat, Cpmat, Cptopmat] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, g, f);
Lmat = MTLviaABCD(h2, rad, f);
MTL = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, w2/2);
deltaL=microstripdeltaL(w1,h1-h2,eps1);
if remainder<g/2
    %gap only
    temp2={Cptopmat, Cpmat, Cgapmat};
elseif remainder<a/2
    %account for other half of gap cap and TL length.
    l=remainder-g/2;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cptopmat, Cpmat, Cgapmat, MTLseg};
elseif remainder==a/2
    temp2={Cptopmat, Cpmat, Cgapmat, MTL, Lmat};
elseif remainder<a-g/2
    l=remainder-a/2-g/2;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cptopmat, Cpmat, Cgapmat, MTL, Lmat, MTLseg};
else
    temp2={Cptopmat, Cpmat, Cgapmat, MTL, Lmat, MTL, Cgapmat, Cpmat, Cptopmat};
end

Zin=[ZL(1,1) 0; 0 ZinL];
for ii=1:length(temp2)
    Zin=unitcellMultiply(Zin,temp2{ii},1);
end

end

