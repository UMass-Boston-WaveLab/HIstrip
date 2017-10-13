function [ Cmat, Cpmat, Cptopmat ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, g, f)
%computes ABCD matricies of mutual capacitence matricies 
%3-output ABCD

omega = 2*pi*f;


        [Cgap,Cp] = microstripGapCap2(w2,h2,eps2,g, f);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,g, f);

        
        Cmat = [1 0 0 0; 0 1 0 1/(1i*omega*Cgap*2+real(harringtonslotY(f, g, w2))); 0 0 1 0; 0 0 0 1]; %ABCD of unit cell gap capacitence (is 1/JHWZ better for this value?)
        Cpmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 1i*omega*Cp 0 1];
        Cptopmat = [1 0 0 0; 0 1 0 0; 1i*omega*Cptop -1i*omega*Cptop 1 0; -1i*omega*Cptop 1i*omega*Cptop 0 1];

end

