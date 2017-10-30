function [ Zin ] = partialcells(ZL, L_ant, a,  w1, w2, h1, h2, rad, eps1, eps2, f, viaflag)
% Deals with partial unit cells in multilayer HIStrip model

N=floor(0.5*L_ant/a);
remainder = 0.5*L_ant-N*a;

%account for partial unit cell on the bottom, also
bot_remainder=a-remainder;
%building blocks for bottom cells
[ABCD, ABCDgaphalf1,ABCDline,ABCDL] = HISlayerABCD(w2, g, h2, rad, eps2, f, viaflag, eps1, L_ant);
deltaL_bot=microstripdeltaL(w2,h2,eps2);
if bot_remainder<g/2
    temp={};
elseif bot_remainder<a/2
    %other half of gap cap and TL length
    l=remainder-g/2+deltaL_bot;
    ABCDlseg = [cos(beta*l) 1i*Z0*sin(beta*l); 1i*sin(beta*l)/Z0 cos(beta*l)];
    temp = {ABCDgaphalf1, ABCDlseg};
elseif bot_remainder==a/2
    temp = {ABCDgaphalf1, ABCDline, ABCDL};
else
    l=remainder-g/2+deltaL_bot;
    ABCDlseg = [cos(beta*l) 1i*Z0*sin(beta*l); 1i*sin(beta*l)/Z0 cos(beta*l)];
    temp = {ABCDgaphalf1, ABCDline, ABCDL, ABCDlseg};
end

ZinL=ZL(2,2);
for ii=1:length(temp)
    ZinL=unitcellmultiply(ZinL,temp{ii},1);
end


%building blocks for upper cells
[Cgapmat, Cpmat, Cptopmat] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, g, f);
Lmat = MTLviaABCD(h2, rad, f);
MTL = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, w2/2);
deltaL=microstripdeltaL(w1,h1-h2,eps1);
if remainder<g/2
    %there's only a tiny bit of overlap - ignore it.
    temp2={};
elseif remainder<a/2
    %account for other half of gap cap and TL length.
    l=remainder-g/2+deltaL;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cgapmat, Cpmat, Cptopmap, MTLseg};
elseif remainder==a/2
    temp2={Cgapmat, Cpmat, Cptopmap, MTL, Lmat};
else
    l=remainder-g/2+deltaL;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cgapmat, Cpmat, Cptopmap, MTL, Lmat, MTLseg};
end

Zin=[ZL(1,1) 0; 0 ZinL];
for ii=1:length(temp2)
    Zin=unitcellmultiply(Zin,temp2{ii},1);
end

end

