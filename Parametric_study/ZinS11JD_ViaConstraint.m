
%HIStrip under via constraints

% 1<w/h<2.2 ~~ outside this value should be accurate within 3% if the d/h
% condition is met 
% 0.2 < d/h < 1.5
% d/h = 0.85
clc;
clear all;
close all;

%% Constants
eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);

sf = 1; %sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
w_ant = 0.0001*sf; %depends on kind of antenna placed on top of HIS
w1 = w_ant;
H_sub = 0.000367*sf; %ground to patch distance
h_ant = 0.00019*sf; %antenna height above substrate

w2 = .00022*sf;     %patch width
rad = .00015*sf;   %via radius
g = 0.00011*sf;     %patch spacing
gap = g;         
a = w2+g;        %unit cell size

L_sub = 16*a;  
w_sub = 16*a;
L_ant = 0.00048; 
f = (100:.5:600)*10^6/sf;
%f = (250:2:450)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant+microstripdeltaL(w_ant, h_ant, eps1);
N = floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER HALF of ANTENNA
digitsOld = digits(8);
remainder = vpa(0.5*L_ant_eff-N*a);

%% slot spacing description
sep_12=L_sub/2-L_ant_eff/2;
sep_13=L_sub/2+L_ant_eff/2;
sep_14=L_sub;
sep_23=L_ant;
sep_24=L_sub/2+L_ant_eff/2;
sep_34=L_sub/2-L_ant_eff/2;
slot_1_x=w_ant;
slot_2_x=w_sub;
slot_3_x=w_ant;
slot_4_x=w_sub;
%% 

[ABCD, ABCDgaphalf1,ABCDline,ABCDL,~] = HISlayerABCD(w2, g, H_sub, rad, eps2, f, viaflag, eps1);
botn = floor((L_sub-L_ant_eff)/(2*a))-1;% Number of compelete unit cell not under antenna===HIS

% initializing output matricies
S11 = zeros(size(f));
Zd = zeros(size(f));

for ii = 1:length(f)
   
 Y(:,:,ii) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii),...
     w_ant, h_ant, L_ant_eff ,eps1, w_sub, H_sub, L_sub,eps2, f(ii));  

 Z = inv(Y(:,:,ii));

%HIS is terminated by admittance of HIS-edge slots.
    ZL = Z(1,1);
    ZR = Z(4,4);

ZLtemp=ZL;
temp={ABCDgaphalf1(:,:,ii),ABCDline(:,:,ii),ABCDL(:,:,ii),ABCDline(:,:,ii)};

for jj=length(temp):-1:1
    ZLtemp = unitcellMultiply(ZLtemp, temp{jj}, 1);%  last HIS connection from ground side to load
end

ZinL_l = unitcellMultiply(ZLtemp, ABCD(:,:,ii), botn);% HIS from antenna edge to last HIS connection from ground side
ZRtemp=ZR;

for jj=length(temp):-1:1
    ZRtemp = unitcellMultiply(ZRtemp, temp{jj}, 1);% RIGHT
end
ZinR_l = unitcellMultiply(ZRtemp, ABCD(:,:,ii), botn);


%Cascade of 4x4 unit cells for left and right of source voltage. 
unitcell=multicond_unitcell(a,  w_ant, w2, h_ant+H_sub, H_sub, rad, eps1, eps2, f(ii), viaflag);

%impedance of upper equivalent radiating slots
ZLR=Z(2,2);
ZLL=Z(3,3);
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA

%% NEED IF STATEMENT HERE
ZinR_mid = partialcells([ZLR+ZinR_l ZinR_l; ZinR_l ZinR_l], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
ZinL_mid = partialcells([ZLL+ZinL_l ZinL_l; ZinL_l ZinL_l], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
%%
Zmat_R = unitcellMultiply(ZinR_mid, unitcell, N);
Zmat_L = unitcellMultiply(ZinL_mid, unitcell, N);
%% Solution for Zin - dipole
Z = Zmat_R+Zmat_L;
    Zd(ii) = Z(1,1)-Z(1,2)*Z(2,1)/Z(2,2);
S11(ii) = (Zd(ii)-50)/(Zd(ii)+50);
  
%% Solution for Zin - Patch

                %%Patch Term Simplification    
                %X = Y22 + Y24 + Y42 + Y44;

                % Solution for Zin - Probe
                %Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))

end 

magS11 = abs(S11(:));
    [minS11, resFL] = min(magS11);
        resF = f(resFL);
     

%% IEEE Plotting Standard Figure Configuration

    % run before the plot command
    % IEEE Transactions and Journals: 
    % Times New Roman is the suggested font in labels. 
    % For a singlepart figures labels should be in 8 to 10 points,
    % multipart figures, labels should be in 8 points.
    % Width: column width: 8.8 cm; page width: 18.1 cm.

%% width & height of the figure

k_scaling = 1; % scaling factor of the figure
% (You need to plot a figure which has a width of (8.8*k_scaling)
% in MATLAB, so that when you paste it into your paper, the width will be
% scalled down to 8.8 cm
k_width_height = 2; % width:height ratio of the figure

width = 8.8 * k_scaling;
height = width / k_width_height;

%% figure margins

top = 0.5;  % normalized top margin
bottom = 3;	% normalized bottom margin
left = 3.5;	% normalized left margin
right = 3.5; % normalized right margin

%% set default figure configurations

set(0,'defaultFigureUnits','centimeters');
set(0,'defaultFigurePosition',[0 0 width height]);

set(0,'defaultLineLineWidth',1*k_scaling);
set(0,'defaultAxesLineWidth',0.25*k_scaling);

set(0,'defaultAxesGridLineStyle',':');
set(0,'defaultAxesYGrid','on');
set(0,'defaultAxesXGrid','on');

set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultAxesFontSize',8*k_scaling);

set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultTextFontSize',8*k_scaling);

set(0,'defaultLegendFontName','Times New Roman');
set(0,'defaultLegendFontSize',8*k_scaling);

set(0,'defaultAxesUnits','normalized');
set(0,'defaultAxesPosition',[left/width bottom/height (width-left-right)/width  (height-bottom-top)/height]);

set(0,'defaultAxesColorOrder',[0 0 0]);
set(0,'defaultAxesTickDir','out');

set(0,'defaultFigurePaperPositionMode','auto');

set(0,'defaultLegendLocation','best');
set(0,'defaultLegendBox','on');
set(0,'defaultLegendOrientation','vertical');

%% Plotting
% model impedance
figure(1); 
plot(f*1e-9, real(Zd), f*1e-9, imag(Zd),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('Zin')
legend({'R';'X'})

% Model & HFSS Comparisons
% figure(2)
% plot(f*1e-9, abs(Zd))
% hold on
% plot(f*1e-9, ZinData(:,2))
% hold off
% xlabel('Frequency [GHz]')
% ylabel('|Z_{in}|')
% legend('Model','HFSS')
% grid on
% set(gca,'fontsize',14)
% xlim([0.1 0.6])

% Model S11(dB)
figure(2); 
plot(f*1e-9, 20*log10(magS11), 'linewidth',1)
hold on
xlabel('Frequency [GHz]')
ylabel('|S_{11}| (dB)')
grid on
set(gca,'fontsize',10)


figure(3); 
plot(f*1e-9, magS11, 'linewidth',1)
hold on
xlabel('Frequency [GHz]')
ylabel('|S_{11}|')
grid on
set(gca,'fontsize',10)

% Data HFSS
% figure(3); 
% plot(f*1e-9, 20*log10(S11data(:,2)), 'linewidth',1)
% hold on
% plot(f*1e-9, 20*log10(magS11), 'linewidth',1)
% hold off
% xlabel('Frequency [GHz]')
% ylabel('|S_{11}| (dB)')
% grid on
% set(gca,'fontsize',10)
% xlim([0.1 0.6])

% Delta S
% figure(4); 
% plot(f*1e-9, abs(S11data(:,2)-magS11))
% xlabel('Frequency [GHz]')
% ylabel('\Delta|S_{11}| ')
% grid on
% set(gca,'fontsize',10)
% xlim([0.1 0.6])

