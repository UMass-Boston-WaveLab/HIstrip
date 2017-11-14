function [ABCD_g_half ABCD_g Yg ] = microstripgap1_saber( eps2,g, H_sub, w2,f)

% %N.G. Alexopoulos ; Shih-Chang Wu UCLA
% % Frequency-independent equivalent circuit model for microstrip open-end and gap discontinuities - 
% % Microwave Theory and Techniques, IEEE Tran 1994

% 
% clc
% clear all;
% f=3*10^8;%%sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
% 
% lambda = 3e8./f;
% omega = 2*pi*f;

% h=h/0.0254;  %% in our codes dimension unit is meter. In paper they use mil. 1m=1000mm= units mm to mil
% 1M=39370.1mil




eps=eps2
s=g*39370.1;
w=w2*39370.1;
h=H_sub*39370.1;

Z0 = microstripZ0_pozar(w2,H_sub,eps2);
eff = epseff(w2,H_sub,eps2);

%paper input data
% Z0=50;
% h=25;
% w=25;
% s=20;
% f=3*10^8;

% NOTE: UNITS IN PAPER ARE MIL, 1MIL=0.0254MM



%% 
% 
% * ITEM1
% * ITEM2
% 
%% 
C11=(h/(25*Z0))*((1.125*tanh(1.358*w/h)-0.315)*tanh((0.0262+0.184*h/w)+(0.217+0.0619*log(w/h))*(s/h)))*10^(-12);

C12=(h/(25*Z0))*(6.832*tanh(0.0109*w/h)+0.910)*tanh((1.411+0.314*h/w)+(s/h)^(1.248+0.360*atan(w/h)))*10^(-12);
%% 

L11=(h*Z0/25)*(0.134+0.0436*log(w/h))*exp(-1*(3.656+0.246*h/w)*(s/h)^(1.739+0.390*log(w/h)))*10^(-9);

L12=(h*Z0/25)*(0.008285*tanh(0.5665*w/h)+0.0103)+(0.1827+0.00715*log(w/h))*exp(-1*(5.207+1.283*tanh(1.656*h/w))...
   *(s/h)^ (0.542+0.873*atan(w/h)))*10^(-9);

R1=Z0*1.024*tanh(2.025*w/h)*tanh((0.01584+0.0187*h/w)*(s/h)+(0.1246+0.0394*sinh(w/h)));

C2=(h/(25*Z0))*((0.1776+0.05104*log(w/h))*(h/s)+(0.574+0.3615*(h/w)+1.156*log(w/h))*(sech(2.3345*s/h)))*10^(-12);

L2=(h*Z0/25)*(0.00228+0.0873/(7.52*(w/h)+cosh(w/h)))*sinh(2.3345*s/h)*10^(-9);

R2=Z0*(-1.78+0.749*w/h)*(s/h)+(1.196-.971*log(w/h))*sinh(2.3345*s/h);
%% 

%% 
%% 
for ii = 1:length(f)
    
omega = 2*pi*f(ii);
Yp1=j*C11*omega+1/(j*L11*omega);
Yp2=(1/R1)+j*C12*omega+1/(j*L12*omega);
Yp=Yp1+Yp2; % Parallel admitance for pi network

Ys=(1/R2)+j*C2*omega+1/(j*L2*omega); %Seri admitance for pi network

%Y matrix for pi network

Yg=[2*Yp -Ys;-Ys 2*Yp];

%ABCD for pi newtork
ABCD_g(:,:,ii)=[1 0;Yp 1]*[1 1/Ys;0 1]*[1 0;Yp 1];
ABCD_g_half(:,:,ii)=[1 0;Yp 1]*[1 (1/Ys)/2;0 1];
end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

end