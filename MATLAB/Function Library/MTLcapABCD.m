function [ Csmathalf, Cpmat, Cptopmat ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, gap, freq)
%MTLcapABCD Makes ABCD matrix for pi-network of capacitors in MTL unit
%cell. Csmathalf represents half the series capacitor (split in half
%because that's the boundary of the unit cell). Cpmat represents one of the
%shunt capacitors from the middle layer to ground.  Cptopmat represents
%shunt capacitors from the middle to upper layer (which may not need to be
%included - needs testing).

        %[Cgap,~, ~] = microstripgapcap(eps2,gap, h2, w2, w2); 
        %[~,Cp, ~] = microstripgapcap(eps2,gap, h2, w1, w2); 
        %[~,~, Cptop] = microstripgapcap(eps1,gap,h1-h2, w1, w2);
        [Cgap, Cp] = microstripGapCap2(w2, h2, eps2, gap, freq);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1, gap, freq); 
        
        omega = 2*pi*freq;
        
        %can add radiative loss from gap
        a1 = 1/(1i*omega*Cgap*2+2*real((harringtonslotY((freq),gap/2,w2))));
%       a = 1/(j*vpa(omega)*Cgap*2);
        b = 1j*omega*Cp;
        c = 1j*omega*Cptop;

Csmathalf=[1 0 0 0;
            0 1 0 a1;
            0 0 1 0;
            0 0 0 1];
Cpmat = [1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 b 0 1];
    
Cptopmat = [1 0 0 0;
            0 1 0 0;
            c (-c) 1 0;
            -c c 0 1];

end

