function [ Lprod, Rprod ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, gap, freq)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        [Cgap,Cp] = microstripGapCap2(w2,h2,eps2,gap, freq);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,gap, freq);
        
        omega = 2*pi*freq;
        
        a = 1/(j*vpa(omega)*Cgap*2+real(vpa(harringtonslotY(vpa(freq),gap,w2))));
        b = j*omega*Cp;
        c = j*omega*Cptop;

Lprod = [1 0 0 0; 
         -a*c (a*b+a*c+1) 0 a;
         c -c 1 0;
         -c b+c 0 1];
     
Rprod = [1 0 0 0;
         0 1 0 a;
         c -c 1 -a*c;
         -c b+c 0 a*b+a*c+1];

end

