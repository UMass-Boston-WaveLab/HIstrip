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
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
w1=w_ant;
H_sub = 0.04*sf; %ground to patch distance
h_ant = 0.02*sf; %antenna height above substrate

w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
gap=g;
a =w2+g;       %unit cell size

L_sub = 16*a;
w_sub = 16*a;
L_ant = 4*a;  %for now, must be integer number of unit cells
%f = 2e9:250e6:10e9; %f vector sweep for 6ghz
%f = 1e9:500e6:6.5e9;
f=(100:.5:600)*10^6/sf;
omega = 2*pi*f;
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


[ABCD, ABCDgaphalf1,ABCDline,ABCDL] = HISlayerABCD(w2, g, H_sub, rad, eps2, f, viaflag, eps1, L_sub, L_ant);
botn = floor((L_sub-L_ant)/(2*w2+g))-1;
for ii = 1:length(f)

%  Y(:,:,ii)= HIS_admittance_saber_test(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii));
   
   
 Y(:,:,ii) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii),...
     w_ant, h_ant, L_ant,eps1, w_sub, H_sub, L_sub,eps2, f(ii));  
% Y(:,:,ii) = HISantYmat_SS(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);

%HIS is terminated by admittance of HIS-edge slots.
ZL = 1/Y(2,2,ii);
ZR = 1/Y(4,4,ii);

ZLtemp = unitcellMultiply(ZL, ABCDgaphalf1(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii), 1);
ZinL = unitcellMultiply(ZLtemp, ABCD(:,:,ii), botn);

ZRtemp = unitcellMultiply(ZR, ABCDgaphalf1(:,:,ii)*ABCDline(:,:,ii)*ABCDL(:,:,ii)*ABCDline(:,:,ii), 1);
ZinR = unitcellMultiply(ZRtemp, ABCD(:,:,ii), botn);


%% BUHHHH

%Cascade of 4x4 unit cells for left and right of source voltage. 
unitcell=multicond_unitcell(a,  w_ant, w2, h_ant+H_sub, H_sub, rad, eps1, eps2, f(ii), viaflag);

Zmat_R = unitcellMultiply([1/squeeze(Y(1,1,ii)) 0; 0 ZinR], unitcell, floor(0.5*L_ant/a));
Zmat_L = unitcellMultiply([1/squeeze(Y(1,1,ii)) 0; 0 ZinL], unitcell, floor(0.5*L_ant/a));

% 
% %Convert total ABCD to Z matrix for solutions for the input impedance
% Zt(:,:,ii) = [Zmat_R zeros(2); zeros(2) Zmat_L];
% 
% 
% %% Components of Z matrix
% 
%     Z11 = Zt(1,1,ii);
%     Z12 = Zt(1,2,ii);
%     Z13 = Zt(1,3,ii);
%     Z14 = Zt(1,4,ii);
% 
%     Z21 = Zt(2,1,ii);
%     Z22 = Zt(2,2,ii);
%     Z23 = Zt(2,3,ii);
%     Z24 = Zt(2,4,ii);
% 
%     Z31 = Zt(3,1,ii);
%     Z32 = Zt(3,2,ii);
%     Z33 = Zt(3,3,ii);
%     Z34 = Zt(3,4,ii);
% 
%     Z41 = Zt(4,1,ii);
%     Z42 = Zt(4,2,ii);
%     Z43 = Zt(4,3,ii);
%     Z44 = Zt(4,4,ii);
 
    
%% Solution for Zin - dipole

%Zd(ii,:,:) = Z11 - Z13 + Z31 - Z33 + (1-Z32-Z34)*((Z21+Z43-Z23-Z41)/(Z24+Z42-Z22-Z44))
%Zd(ii,:,:) = Z11 - Z13 + Z31 - Z33 + (Z21-Z23-Z41+Z43)/(Z42-Z44-Z22+Z24)-(Z32-Z34)*((Z21-Z23-Z41+Z43)/(Z42-Z44-Z22+Z24));


Z = Zmat_R+Zmat_L;
    Zd(ii) = Z(1,1)-Z(1,2)*Z(2,1)/Z(2,2);

S11(ii) = (Zd(ii)-50)/(Zd(ii)+50);
%% Solution for Zin - Patch

                %%Patch Term Simplification    
                %X = Y22 + Y24 + Y42 + Y44;

                % Solution for Zin - Probe
                %Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))


end 


%% Zin Geometric Parametric sweep

    %still need to write this code.
 figure; 
plot(f*1e-9, real(Zd), f*1e-9, imag(Zd),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('Zin')
legend({'R';'X'})
grid on
set(gca,'fontsize',14)    
xlim([0.1 0.6])
ylim([-5000 5000])



figure; 
plot(f*1e-9, 20*log10(abs(S11)), 'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('|S_{11} (dB)')
grid on
set(gca,'fontsize',14)
xlim([0.1 0.6])


% end
 
