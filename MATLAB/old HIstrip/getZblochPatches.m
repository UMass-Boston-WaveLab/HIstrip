function [Zin] = getZblochPatches(L,Cs, Cp,Zline, beta, omega, w2)
%this is for the bloch impedance of the EBG surface without a line on top
%of it, which is what would be in parallel with the inductor of a unit
%cell of the two-TL line.
%I'm approximating it by using a line of EBG patches - essentially I'm
%assuming the wave doesn't split at every inductor, just the first one.
%This is almost certainly not true.

TL = [cos(beta*w2/2) j*Zline*sin(beta*w2/2);
      (1/Zline)*j*sin(beta*w2/2) cos(beta*w2/2)];
  
ser = [1 1/(j*omega*Cs); 0 1];

shunt = [1 0; j*omega*Cp 1];

ind1 = [1 0; 1/(j*omega*L) 1];

ABCD = shunt*ser*shunt*TL*ind1*TL;

A = ABCD(1,1);
B = ABCD(1,2);
C = ABCD(2,1);
D = ABCD(2,2);

Zin1 = -2*B/(A-D+sqrt((A+D)^2-4));
if real(Zin1)<0
    Zin1 = -2*B/(A-D-sqrt((A+D)^2-4));
end

% Zin = 0;
% 
% ztest = abs((Zin1-Zin)/Zin1);
% 
% while ztest>0.1
%     ind = [1 0; ((2/Zin1)+1/(j*omega*L)) 1];
%     ABCD = shunt*ser*shunt*TL*ind*TL;
%     
%     A = ABCD(1,1);
%     B = ABCD(1,2);
%     C = ABCD(2,1);
%     D = ABCD(2,2);
%     
%     Zin = -2*B/(A-D+sqrt((A+D)^2-4));
%     if real(Zin)<0
%         Zin = -2*B/(A-D-sqrt((A+D)^2-4));
%     end
%     
%     ztest = abs((Zin1-Zin)/Zin1);
%     Zin1 = Zin;
% end
Zin = Zin1;
