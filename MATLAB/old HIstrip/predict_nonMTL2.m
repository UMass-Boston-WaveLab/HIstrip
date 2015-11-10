function [gamma, Zbloch, ABCD2] = predict_nonMTL2(ABCD4,a, freq, Yterm1,Yterm2)
% predicts outcome of Valerio-style simulation of a 2-port 2-terminal (T1,
% GND) structure if the actual thing is a 2-port 3-terminal structure (T1, 
% T2, GND), and at the terminals of the n1-cell and n2-cell simulation
% structures, I2 = 0.


ABCD2_4 = BlochABCD4toABCD2(ABCD4^1,a*1, freq, Yterm1,Yterm2);
ABCD2_5 = BlochABCD4toABCD2(ABCD4^1,a*1, freq, Yterm1,Yterm2);
ABCD2 = BlochABCD4toABCD2(ABCD4,a, freq, eye(4), eye(4));
        
%now we have to do the Valerio-style Bloch solution for this using the two
%ABCD matrices
if freq ==215e6
    fprintf(1,'pause\n');
end
gamma = valerio_bloch(ABCD2_4, ABCD2_5, 1,1, a);
ABCD2 = ABCD2_5/ABCD2_4;

[~, Zbloch] = blochgamma(ABCD2,a);

