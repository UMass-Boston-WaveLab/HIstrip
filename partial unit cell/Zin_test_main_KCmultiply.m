% function [Z]  = Zin_test(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L_ant, startpos, L_sub, W_sub, viaflag)
%% Uses a dipole or probe fed relationship to enforce boundary conditions on

%% Antenna/HIS geometries
clc
clear all;

%sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
% the best/hanna antenna is actually a 0.005m radius dipole
%"the equivalent strip width for a cylindrical wire is almost twice (~1.89)
%the wire diameter"
% (see "Equivalent Strip Width for Cylindrical Wire for Mesh Reflector
% Antennas: Experiments, Waveguide, and Plane-Wave Simulations")
sf = 1; 
<<<<<<< HEAD
w_ant = 0.0189*sf; %depends on kind of antenna placed on top of HIS
=======
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
>>>>>>> 0d731aa100612fd3954213f7e003831151dc5ee2
w1=w_ant;
H_sub = 0.04*sf; %ground to patch distance
h_ant = 0.02*sf; %antenna height above substrate

w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
gap=g;
a =w2+g;       %unit cell size

L_sub = 8*a;
w_sub = 1*a;
<<<<<<< HEAD
% w_sub = 2*a;

L_ant = 0.48; 
=======
L_ant = 0.54; 
>>>>>>> 0d731aa100612fd3954213f7e003831151dc5ee2
%f = 2e9:250e6:10e9; %f vector sweep for 6ghz
%f = 1e9:500e6:6.5e9;
f=(100:5:600)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant;
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA
digitsOld = digits(8);
remainder = vpa(0.5*L_ant-N*a);

%% Constants
eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);


%% Symbolic Variables

   % Vin = sym ('Vin');
   % Iin = sym ('Iin');
   % Zin = sym ('Zin');
   % V1b = sym ('V1b');
   % V2b = sym ('V2b');
   % I1b = sym ('I1b');
   % I2b = sym ('I2b');

% % % |<--------Lsub----------->|
% % % |                         | 
% % % |        |<-Lant>|        |
% % % |        |       |        |
% % % |        |       |        |
% % % |        2       3        | 
% % % |                         |
% % % |                         | 
% % % 1                         4           
%% slot spacing description
sep_12=L_sub/2-L_ant/2;
sep_13=L_sub/2+L_ant/2;
sep_14=L_sub;
sep_23=L_ant;
sep_24=L_sub/2+L_ant/2;
sep_34=L_sub/2-L_ant/2;
slot_1_x=w_ant;
slot_2_x=w_sub;
slot_3_x=w_ant;
slot_4_x=w_sub;
%% 

% sep_12=0.05;
% sep_13=.1;
% sep_14=.15;
% sep_23=0.05;
% sep_24=.1;
% sep_34=0.05;
% slot_1_x=4;
% slot_2_x=.5;
% slot_3_x=.5;
% slot_4_x=4;
%% 
% L_ant_eff = L_ant+microstripdeltaL(w_ant, h_ant, eps1);

[ABCD, ABCDgaphalf1,ABCDline,ABCDL,~] = HISlayerABCD(w2, g, H_sub, rad, eps2, f, viaflag, eps1);
botn = floor((L_sub-L_ant_eff)/(2*a))-1;% Number of compelete unit cell not under antenna===HIS
for ii = 1:length(f)

%  Y(:,:,ii)= HIS_admittance_saber_test(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii));
   
   
 Y(:,:,ii) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii),...
     w_ant, h_ant, L_ant,eps1, w_sub, H_sub, L_sub,eps2, f(ii));  
% Y(:,:,ii) = HISantYmat_SS(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);

Z = inv(Y(:,:,ii));

%HIS is terminated by admittance of HIS-edge slots.
ZL = Z(1,1);
ZR = Z(4,4);

ZLtemp=ZL;
temp={ABCDgaphalf1(:,:,ii),ABCDline(:,:,ii),ABCDL(:,:,ii),ABCDline(:,:,ii)};

for jj=length(temp):-1:1
    ZLtemp = unitcellMultiply(ZLtemp, temp{jj}, 1);%  last HIS connection from ground side to load
end
ZinL_l(ii) = unitcellMultiply(ZLtemp, ABCD(:,:,ii), botn);% HIS from antenna edge to last HIS connection from ground side

ZRtemp=ZR;
for jj=length(temp):-1:1
    ZRtemp = unitcellMultiply(ZRtemp, temp{jj}, 1);% RIGHT
end
ZinR_l(ii) = unitcellMultiply(ZRtemp, ABCD(:,:,ii), botn);


%Cascade of 4x4 unit cells for left and right of source voltage. 
unitcell(:,:,ii)=multicond_unitcell(a,  w_ant, w2, h_ant+H_sub, H_sub, rad, eps1, eps2, f(ii), viaflag);

%impedance of upper equivalent radiating slots
ZLR(ii)=Z(2,2);
ZLL(ii)=Z(3,3);

N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA

%% NEED IF STATEMENT HERE
ZinR_mid(:,:,ii) = partialcells([ZLR(ii)+ZinR_l(ii) ZinR_l(ii); ZinR_l(ii) ZinR_l(ii)], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
ZinL_mid(:,:,ii) = partialcells([ZLL(ii)+ZinL_l ZinL_l; ZinL_l ZinL_l], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
%%

Zmat_R(:,:,ii) = unitcellMultiply(ZinR_mid(:,:,ii), unitcell(:,:,ii), N);
Zmat_L = unitcellMultiply(ZinL_mid(:,:,ii), unitcell(:,:,ii), N);


MTLtemp(:,:,ii) = ustripMTLABCD(w_ant,h_ant+H_sub, w2, H_sub, eps1, eps2, f(ii), w2/2);

ZRtemp = unitcellMultiply(ZinR_mid(:,:,ii), MTLtemp(:,:,ii),1);
ZLtemp = unitcellMultiply(ZinL_mid(:,:,ii), MTLtemp(:,:,ii),1);
%% Solution for Zin - dipole

Z = Zmat_R(:,:,ii)+Zmat_L;
    Zd(ii) = Z(1,1)-Z(1,2)*Z(2,1)/Z(2,2);
S11(ii) = (Zd(ii)-50)/(Zd(ii)+50);

Ztemp = ZRtemp+ZLtemp;
Zapprox(ii) = Ztemp(1,1)-Ztemp(1,2)*Ztemp(2,1)/Ztemp(2,2);


%% Solution for Zin - Patch

                %%Patch Term Simplification    
                %X = Y22 + Y24 + Y42 + Y44;

                % Solution for Zin - Probe
                %Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))

end 


%% Zin Geometric Parametric sweep

    %still need to write this code.
 figure(1); 
plot(f*1e-9, real(Zd), f*1e-9, imag(Zd),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('\Omega')
legend({'R';'X'})
title('HIStrip Model Calculated Input Impedance')
grid on
set(gca,'fontsize',14)    
xlim([0.1 0.6])
ylim([-400 800])


figure(2); 
plot(f*1e-9, 20*log10(abs(S11)), 'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('|S_{11}| (dB)')
grid on
set(gca,'fontsize',14)
xlim([0.1 0.6])

figure(3);
plot(f*1e-9, squeeze(real(Zapprox)), f*1e-9, squeeze(imag(Zapprox)),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('\Omega')
title('Approximate Zin')
legend({'R';'X'})
grid on
set(gca,'fontsize',14)    
xlim([0.1 0.6])
ylim([-400 800])

figure(4); 
plot(f*1e-9, squeeze(real(ZLR)), f*1e-9, squeeze(imag(ZLR)), f*1e-9, squeeze(real(ZinR_l)), f*1e-9, squeeze(imag(ZinR_l)),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('\Omega')
title('Right half impedance matrix terms')
legend({'R_{upper}';'X_{upper}'; 'R_{lower}';'X_{lower}'})
grid on
set(gca,'fontsize',14)    
xlim([0.1 0.6])
ylim([-400 800])

figure(4); 
plot(f*1e-9, squeeze(real(ZLR)),f*1e-9, squeeze(imag(ZLR)), f*1e-9, squeeze(real(ZinR_l)),f*1e-9, squeeze(imag(ZinR_l)),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('\Omega')
title('Right half impedance matrix terms')
%legend({'R_{upper}';'X_{upper}'; 'R_{lower}';'X_{lower}'})
grid on
set(gca,'fontsize',14)    
xlim([0.1 0.6])
ylim([-400 800])


%     end
% end
 
