% Calculates the 2x2 s-parameter matrix of the reflect standard

function[G] = calibrateReflectStandard(K10, K20, L10, L20, G10, depth)

% preallocate reflect matrix
G = zeros(2, 2, depth);

% calculate the reflect matrix
for ii = 1:depth
    G(1,1,ii) = L10(1,1,ii) * G10(1,1,ii);
    G(1,2,ii) = L20(1,1,ii) * K20(1,1,ii) / K10(1,1,ii) * G10(1,2,ii);
    G(2,1,ii) = L10(1,1,ii) / K20(1,1,ii) * K10(1,1,ii) * G10(2,1,ii);
    G(2,2,ii) = L20(1,1,ii) * G10(2,2,ii);
end

% Preallocate row vectors
G11 = zeros(1,depth);
G12 = zeros(1, depth);
G21 = zeros(1, depth);
G22 = zeros(1, depth);

% assign elements
for ii = 1:depth
    G11(1,ii) = 20*log10(abs(G(1,1,ii)));
    G12(1,ii) = 20*log10(abs(G(1,2,ii)));
    G21(1,ii) = 20*log10(abs(G(2,1,ii)));
    G22(1,ii) = 20*log10(abs(G(2,2,ii)));
end

% plot the s-parameters of the G matrix
figure;
freq = [3:0.1:3+(depth - 1)/10];
plot(freq,G11,'-o',freq,G12,'-+',freq,G21,'-x',freq,G22,'-s');
title('Calibrated Reflect S-Parameters');
xlabel('Freq., GHz');
ylabel('dB');
legend('S11', 'S12', 'S21', 'S22', 'Location', 'Southeast');
