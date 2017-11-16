function [ Zin ] = partialcells(ZL, L_ant, a,  w1, w2, h1, h2, rad, eps1, eps2, f, viaflag)
% Deals with partial unit cells in multilayer HIStrip model

%gap width isn't passed in because we can calculate it from other inputs
g=a-w2;

%how much of a partial unit cell is covered by the antenna layer?
N=floor(0.5*L_ant/a);
remainder = vpa(0.5*L_ant-N*a,5);
if remainder<0.00001
    remainder=0;
end
%building blocks and constants for bottom cell parts
[~, ~,ABCDline,ABCDL, ABCDgaphalf2] = HISlayerABCD(w2, g, h2, rad, eps2, f, viaflag, eps1);
Z0 = microstripZ0_pozar(w2,h2,eps2);
epseff2=epseff(w2,h2,eps2);
% betab=2*pi*f*sqrt(epseff2);%KC
lambda = 3e8/f;
betab=(2*pi/lambda)*sqrt(epseff2);%new

%building blocks for upper cell parts
[Cgapmat, Cpmat, Cptopmat] = MTLcapABCD(h1, h2, w1, w2, eps1, eps2, g, f);
Lmat = MTLviaABCD(h2, rad, f);
MTL = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, w2/2);


if remainder<=g/2 %treat it as though it is equal to g/2
    %antenna layer barely extends over gap, the rest is bottom layer only
    temp2={Cgapmat, Cpmat, Cptopmat};
    temp = {ABCDline, ABCDL, ABCDline, ABCDgaphalf2};
    
elseif remainder<a/2
    %top layer covers gap cap and part of a TL section
    l=remainder-g/2;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cgapmat, Cpmat, Cptopmat, MTLseg};%KC
    
    
    % more TL length, L, second half of cell in bottom layer
    l2=w2/2-l;
    ABCDlseg = [cos(betab*l2) 1i*Z0*sin(betab*l2); 1i*sin(betab*l2)/Z0 cos(betab*l2)];% if l2<w2/2 we use ABCDlseg inteasd of ABCDline
    temp = {ABCDlseg, ABCDL, ABCDline, ABCDgaphalf2};%KC
    
    
elseif remainder==a/2
    %split at the inductor
    temp2={Cgapmat, Cpmat, Cptopmat, MTL, Lmat};
    temp = {ABCDline, ABCDgaphalf2};
    
elseif remainder<a-g/2
    %top layer covers half a unit cell plus part of a TL section
    l=remainder-a/2-g/2;
    MTLseg = ustripMTLABCD(w1, h1,w2, h2, eps1, eps2, f, l);
    temp2={Cgapmat, Cpmat, Cptopmat, MTL, Lmat, MTLseg};
    
    %the rest of the TL section, gap cap
    l2=w2/2-l;
    ABCDlseg = [cos(betab*l2) 1i*Z0*sin(betab*l2); 1i*sin(betab*l2)/Z0 cos(betab*l2)];
    temp = {ABCDlseg, ABCDgaphalf2};
    
else
    temp2={Cgapmat, Cpmat, Cptopmat, MTL, Lmat, MTL};
    temp={ABCDgaphalf2};
end



%first propagate through just the bottom layer cells up to the edge of the
%antenna
ZinL=ZL(2,2);
for ii=length(temp):-1:1
    ZinL=unitcellMultiply(ZinL,temp{ii},1);
end

%then propagate Zin through the partial unit cell at the edge of the
%antenna
Zin=[ZL(1,1) 0; 0 ZinL];
for ii=length(temp2):-1:1
    Zin=unitcellMultiply(Zin,temp2{ii},1);
end

end

