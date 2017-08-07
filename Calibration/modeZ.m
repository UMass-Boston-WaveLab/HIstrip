%%%%%%% Modal Impedance Function %%%%%
%
% Function does stuff...
% 
% Input Variables
%
% Output Variables
%

% Code starts here.

function [Zm1,Zm2,cap,modeCap] = modeZ(w1, w2, h1, h2, eps1, eps2, propConst, ...
                                       startFreq, endFreq)

% Calculates per unit length capacitance matrix. Code borrowed from Dr.
% Patel's ustripMTLABCD fn.
[~, C12, ~, ~] = microstrip(w1, h1-h2, eps1);
[~, C2G, ~, ~] = microstrip(w2, h2, eps2);
cap = [C12, -C12; -C12, C2G+C12];

% We want the modal per unit length capacitance matrix. We accomplish this
% by diagonalizing the cap matrix.
[~,modeCap] = eig(cap);

% Creates array of frequency points based off of size of propConst matrix. 
% User inputs range, this fills it based on amount of data.
[~,~,points] = size(propConst);
freqArray = linspace(startFreq,endFreq,points);

% Creates angular frequency (w) array.
angFreqs = freqArray * 2 * pi * 1000000000;

% Fills in Zm1 matrix using modal impedance calculations from paper. May
% have to switch the order later.
Zm1 = zeros(2,2,points);
for ii = 1:points
    Zm1(1,1,ii) = propConst(3,3,ii) / (j * angFreqs(1,ii) * modeCap(1,1));
    Zm1(2,2,ii) = propConst(4,4,ii) / (j * angFreqs(1,ii) * modeCap(2,2));
end

Zm2 = zeros(2,2,points);
for ii = 1:points
    Zm2(1,1,ii) = propConst(3,3,ii) / (j * angFreqs(1,ii) * modeCap(2,2));
    Zm2(2,2,ii) = propConst(4,4,ii) / (j * angFreqs(1,ii) * modeCap(1,1));
end

% Sets up arrays for graphing. Only plotting Zm1 options right now.
for ii = 1:points
    reZ1(1,ii) = real(Zm1(1,1,ii));
    reZ2(1,ii) = real(Zm1(2,2,ii));
    imZ1(1,ii) = imag(Zm1(1,1,ii));
    imZ2(1,ii) = imag(Zm1(2,2,ii));
    totZ1(1,ii) = abs(Zm1(1,1,ii));
    totZ2(1,ii) = abs(Zm2(2,2,ii));
end

plot(freqArray,reZ1,'b',freqArray,imZ1,'--b',freqArray,reZ2,'r',freqArray,imZ2,'--r');
legend('Re Z1','Im Z1','Re Z2', 'Im Z2');
xlabel('Freq (GHz)');
ylabel('Ohms');
title('Modal Impedance by Component');
figure;

plot(freqArray,totZ1,'b',freqArray,totZ2,'r');
legend('Mag Z1','Mag Z2');
xlabel('Freq (GHz)');
ylabel('Ohms');
title('Modal Impedance Magnitude');
