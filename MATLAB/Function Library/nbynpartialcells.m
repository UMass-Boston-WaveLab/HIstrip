function [ Zin ] = nbynpartialcells(ZLb, ZLu, zluindex, cap, cap0, HIScap, HIScap0, f, a, gap, Lu, Lvia, Cseries, Cshunt, HISLvia, HISgaphalfsp, HISgaphalfps)
%NBYNPARTIALCELLS calculates the input impedance looking into a HIS unit
%cell (or slice if n>2) that is partially covered by the upper (antenna)
%layer.

%Lu is the length that is covered by the upper layer.
Lb=a-Lu; %length not covered

%break line down into parts and deal with it differently depending on
%whether covered is true or false.
if Lb>a/2
    Lblen=Lb-a/2;
else
    Lblen=Lb;
end
if Lu>a/2
    Lulen=Lu-a/2;
else
    Lulen=Lu;
end
HISlinelength = nbynMTL(HIScap, HIScap0, f, Lblen);
coveredlinelength = nbynMTL(cap, cap0, f, Lulen);

HISlinehalfcell = nbynMTL(HIScap, HIScap0, f, a/2);
coveredlinehalfcell = nbynMTL(cap, cap0, f, a/2);


temp={Cseries, Cshunt,coveredlinehalfcell, Lvia, coveredlinehalfcell, Cshunt, Cseries};
%this one can be done separately because nothing changes about the command
%depending on line length
if Lb>=gap/2
    ZLb = unitcellMultiply(ZLb, HISgaphalfps, 1);
    temp={Cseries, Cshunt,coveredlinehalfcell, Lvia, coveredlinehalfcell};
end
%in here, we have to adjust the TL section lengths, so it has to have
%multiple elseif statements.
if Lb>gap/2 && Lb<a/2
    ZLb = unitcellMultiply(ZLb, HISlinelength, 1);
    temp={Cseries, Cshunt,coveredlinehalfcell, Lvia, coveredlinelength};
elseif Lb==a/2
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell, 1);
    temp={Cseries, Cshunt,coveredlinehalfcell, Lvia};
elseif Lb>a/2 && Lb<(a-gap/2)
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell, 1);
    ZLb = unitcellMultiply(ZLb, HISLvia, 1);
    ZLb = unitcellMultiply(ZLb, HISlinelength);
    temp={Cseries, Cshunt, coveredlinelength};
elseif Lb==(a-gap/2)
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell, 1);
    ZLb = unitcellMultiply(ZLb, HISLvia, 1);
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell);
    temp={Cseries, Cshunt};
elseif Lb>(a-gap/2)
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell, 1);
    ZLb = unitcellMultiply(ZLb, HISLvia, 1);
    ZLb = unitcellMultiply(ZLb, HISlinehalfcell);
    ZLb = unitcellMultiply(ZLb, HISgaphalfsp, 1);
    temp={};
end
% <<<<<<< HEAD
% <<<<<<< HEAD
% % <<<<<<< HEAD
% =======
% >>>>>>> parent of 010b3b4... Revert "fixed how antenna layer couples to HIS layer at rad slot"
% =======
% >>>>>>> parent of 010b3b4... Revert "fixed how antenna layer couples to HIS layer at rad slot"
%ZLu is going to be connected to at
%least one of the HIS layer MTL lines, not to GND directly.  The way to do
%it is to specify an index to put ZLu in.  If even configuration, 2ZLu
%should be put in two different elemnt spaces
Zin = [ zeros([size(ZLu,1),size(ZLb,2)+size(ZLu,2)]);
       zeros([size(ZLb,1),size(ZLu,2)]) ZLb];
for ii=1:length(zluindex)  %this will break if ZLu isn't scalar but I don't know why it wouldn't be.
    Zin(1,zluindex(ii)) = ZLb(zluindex, zluindex);
    Zin(zluindex(ii),1) = ZLb(zluindex, zluindex);
    Zin(1,1)=ZLu+ZLb(zluindex, zluindex); 
end
% <<<<<<< HEAD
% <<<<<<< HEAD
% %    
% % =======

Zin = [ZLu zeros([size(ZLu,1),size(ZLb,2)]);
       zeros([size(ZLu,1),size(ZLb,2)]).' ZLb];
% % >>>>>>> parent of 37f130a... fixed how antenna layer couples to HIS layer at rad slot
% =======
%    
% >>>>>>> parent of 010b3b4... Revert "fixed how antenna layer couples to HIS layer at rad slot"
% =======
%    
% >>>>>>> parent of 010b3b4... Revert "fixed how antenna layer couples to HIS layer at rad slot"
for jj=length(temp):-1:1
    Zin = unitcellMultiply(Zin, temp{jj}, 1);
end