function [ Lprod, Rprod ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, gap, freq)
%MTLcapABCD Makes ABCD matrix for pi-network of capacitors in MTL unit cell

        [Cgap,Cp] = microstripGapCap2(w2,h2,eps2,gap, freq);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,gap, freq);
        
        omega = 2*pi*freq;
        
        %the radiative loss term in here is pretty important
        a = 1/(j*vpa(omega)*Cgap*2+real(vpa(harringtonslotY(vpa(freq),gap,w2))));
%        a = 1/(j*vpa(omega)*Cgap*2);
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

