function [ Cs, Cp ] = microstripGapCap2( w,h,eps2,g, f )
%MICROSTRIPGAPCAP2 Uses Hammerstad's fits of Koster & Jansen's data


lambda = 3e8/f;
omega = 2*pi*f;
% g = 0.02;
u = w/h;
[Z, ~, ~, epseff] = microstrip(w,h,eps2);
Y = 1/Z;

%Hammerstad represents the circuit as "J-inverter with admittance Bg centered between two
%line extensions deltag" (Bg is a series load, it's just expressed as
%admittance)
deltae = h*0.102*(u+0.106)/(u+0.264)*(1.166+(eps2+1)/eps2 * (0.9+log(u+2.475)));
Bg = Y*h/lambda * 2.4*(u+0.1)/(u+1) * sqrt((eps2+2)/(eps2+1)) * log(coth(eps2*g/((eps2+2)*h)));
deltap = deltae*(tanh(sqrt(0.5*g/deltae)))^2;
deltag = deltap+Bg*lambda/(2*pi*Y);

beta = (2*pi/lambda)*sqrt(epseff);

TL = [cos(beta*deltag) j*Z*sin(beta*deltag); j*Y*sin(beta*deltag) cos(beta*deltag)];

ABCD = TL * [1 1/(j*Bg); 0 1] * TL;

%Assume ABCD represents a pi-network to get cap values
%use the Y indices in Pozar p. 208
Y3 = 1/ABCD(1,2);
Y1 = (ABCD(2,2)-1)*Y3;
Y2 = (ABCD(1,1)-1)*Y3;

Cs = imag(Y3)/omega;
Cp = imag(Y1)/omega;


end

