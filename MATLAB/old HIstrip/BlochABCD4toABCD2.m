function [ABCD2] = BlochABCD4toABCD2(ABCD4,a, freq, Yterm1, Yterm2)
%solves the eigenvalue equation for ABCD4, then calculates the ABCD2 matrix
%we would observe if we were only observing terminal termnum (but the Bloch
%condition was still valid on all terminals).

%need to use the correct termination impedance to model the HFSS model -
%Yterm could be the characteristic admittance of a continuous microstrip line,
%or it could be some capacitance due to the open end of the line (depends
%on how the model is built)

[Cgap,Cp] = microstripGapCap2(0.12,0.04,2.2,0.02, freq);
omega = 2*pi*freq;
Cmat = [1 0 0 0; 0 1 0 1/(j*omega*Cgap*2); 0 0 1 0; 0 0 0 1]*[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 j*omega*Cp 0 1];


%this matrix relates [V1i; V2i; I1i] to [V10; V20; I10]
four =Yterm1*inv(Cmat)*ABCD4*inv(Cmat)*Yterm2; %needs MTL segments for the gap length before wave port
A = four(1:2,1:2);
B = four(1:2,3:4);
C = four(3:4,1:2);
D = four(3:4,3:4);


if abs(C(2,2))>1e-13
    ABCD2 = [A(1,1)-C(2,1)*A(1,2)/C(2,2), B(1,1)-D(2,1)*A(1,2)/C(2,2); C(1,1)-C(2,1)*C(1,2)/C(2,2), D(1,1)-D(2,1)*C(1,2)/C(2,2)];
else %if C(2,2) is too small, we get a divide by 0 problem
    Z4 = ABCD4toZ(four);
    Z2 = [Z4(1,1) Z4(1,3); Z4(3,1) Z4(3,3)]; 
    ABCD2 = ZtoABCD(Z2);
end

