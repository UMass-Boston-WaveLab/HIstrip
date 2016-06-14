function [ Cmat, Cpmat, Cptopmat ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, g, f)
%computes ABCD matricies of mutual capacitence matricies 
f = 300e6; %Mhz
omega = 2*pi*f;
w1 = 0.01; %depends on kind of antenna placed on top of HIS?
h1 = 0.02; %antenna height above HIS
w2 = .12; %patch width
h2 = 0.04 %patch to ground
g = .02 %gap between HIS patches
eps1 = 1;
eps2 = 2.2;


        [Cgap,Cp] = microstripGapCap2(w2,h2,eps2,g, f);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,g, f);

        
        Cmat = [1 0 0 0; 0 1 0 1/(j*omega*Cgap*2+real(harringtonslotY(f,g,w2))); 0 0 1 0; 0 0 0 1]; %ABCD of unit cell gap capacitence (is 1/JHWZ better for this value?)
        Cpmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 j*omega*Cp 0 1];
        Cptopmat = [1 0 0 0; 0 1 0 0; j*omega*Cptop -j*omega*Cptop 1 0; -j*omega*Cptop j*omega*Cptop 0 1];

end

