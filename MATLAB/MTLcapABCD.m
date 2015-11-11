function [ Cmat, Cpmat, Cptopmat ] = MTLcapABCD( h1, h2, w1, w2, eps1, eps2, gap, freq)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        [Cgap,Cp] = microstripGapCap2(w2,h2,eps2,gap, freq);
        [~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,gap, freq);

        omega = 2*pi*freq;
        Cmat = [1 0 0 0; 0 1 0 1/(j*omega*Cgap*2); 0 0 1 0; 0 0 0 1];
        Cpmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 j*omega*Cp 0 1];
        Cptopmat = [1 0 0 0; 0 1 0 0; j*omega*Cptop -j*omega*Cptop 1 0; -j*omega*Cptop j*omega*Cptop 0 1];

end

