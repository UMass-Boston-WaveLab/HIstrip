
%% Uses a dipole or probe fed relationship to enforce boundary conditions on
%% Antenna/HIS geometries
clc;
clear all;

%% To Do
%% s11 to hfss
%%
%the best/hanna antenna is actually a 0.005m radius dipole
%"the equivalent strip width for a cylindrical wire is almost twice (~1.89)
%the wire diameter"
%(see "Equivalent Strip Width for Cylindrical Wire for Mesh Reflector
%Antennas: Experiments, Waveguide, and Plane-Wave Simulations")
sf = 1; %sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
parametric_flag = 1;
%w_ant = 0.01*sf; %depends on kind of antenna placed on top of HIS

if parametric_flag == 1
        w_ant = [0.02, 0.2, 0.3, 0.5];
    else parametric_flag = 0;
        w_ant = 0.02;
end

w1 = w_ant(1,1);
H_sub = 0.04*sf; %ground to patch distance
h_ant = 0.02*sf; %antenna height above substrate

w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
gap = g;
a = w2+g;        %unit cell size

L_sub = 16*a;
w_sub = 16*a;
L_ant = 0.48; 

dataS11 = csvread('MagS11one2six2.csv',1,0); %simulation data from HFSS
dataAntW = csvread('ParaAntW.csv',1,0); %simulation data from HFSS
dataPatchW = csvread('ParaPatchW.csv',1,0); %simulation data from HFSS

%f = (100:.5:600)*10^6/sf;
f = (250:2:450)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant;
N = floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA
digitsOld = digits(8);
remainder = vpa(0.5*L_ant-N*a);

%% Constants
eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);

%% slot spacing description
% % % |<--------Lsub----------->|
% % % |                         | 
% % % |        |<-Lant>|        |
% % % |        |       |        |
% % % |        |       |        |
% % % |        2       3        | 
% % % |                         |
% % % |                         | 
% % % 1                         4 
slot_1_x = zeros(size(w_ant));
slot_3_x = zeros(size(w_ant));

for ggg = 1:numel(w_ant)
slot_1_x(ggg) = w_ant(1,ggg);
slot_3_x(ggg) = w_ant(1,ggg);

sep_12=L_sub/2-L_ant/2;
sep_13=L_sub/2+L_ant/2;
sep_14=L_sub;
sep_23=L_ant;
sep_24=L_sub/2+L_ant/2;
sep_34=L_sub/2-L_ant/2;
slot_2_x=w_sub;
slot_4_x=w_sub;
%% Components of just HIS Layer

[ABCD, ABCDgaphalf1,ABCDline,ABCDL,~] = HISlayerABCD(w2, g, H_sub, rad, eps2, f, viaflag, eps1);
botn = floor((L_sub-L_ant_eff)/(2*a))-1;% Number of compelete unit cell not under antenna===HIS

for ii = 1:length(f)   
Y(:,:,ii,ggg) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x(ggg), slot_2_x, slot_3_x(ggg), slot_4_x, f(ii),...
     w_ant(ggg), h_ant, L_ant,eps1, w_sub, H_sub, L_sub,eps2, f(ii));  


Z = inv(Y(:,:,ii,ggg));

%HIS is terminated by admittance of HIS-edge slots.
ZL = Z(1,1);
ZR = Z(4,4);

ZLtemp=ZL;
temp = {ABCDgaphalf1(:,:,ii),ABCDline(:,:,ii),ABCDL(:,:,ii),ABCDline(:,:,ii)};

for jj = length(temp):-1:1
    ZLtemp = unitcellMultiply(ZLtemp, temp{jj}, 1); %last HIS connection from ground side to load
end
ZinL_l = unitcellMultiply(ZLtemp, ABCD(:,:,ii), botn); %HIS from antenna edge to last HIS connection from ground side

ZRtemp = ZR;
for jj = length(temp):-1:1
    ZRtemp = unitcellMultiply(ZRtemp, temp{jj}, 1); %RIGHT
end
ZinR_l = unitcellMultiply(ZRtemp, ABCD(:,:,ii), botn);


%Cascade of 4x4 unit cells for left and right of source voltage. 
unitcell = multicond_unitcell(a,  w_ant(ggg), w2, h_ant+H_sub, H_sub, rad, eps1, eps2, f(ii), viaflag);

%impedance of upper equivalent radiating slots
ZLR = Z(2,2);
ZLL = Z(3,3);

N = floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA

%% NEED IF STATEMENT HERE
ZinR_mid = partialcells([ZLR+ZinR_l ZinR_l; ZinR_l ZinR_l], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
ZinL_mid = partialcells([ZLL+ZinL_l ZinL_l; ZinL_l ZinL_l], L_ant_eff, a, w1, w2, H_sub+h_ant, H_sub, rad, eps1, eps2, f(ii), viaflag);
%%

Zmat_R = unitcellMultiply(ZinR_mid, unitcell, N);
Zmat_L = unitcellMultiply(ZinL_mid, unitcell, N);

%% Solution for Zin - dipole

Z = Zmat_R+Zmat_L;
    Zd(ii,ggg) = Z(1,1)-Z(1,2)*Z(2,1)/Z(2,2);
S11(ii,ggg) = (Zd(ii,ggg)-50)/(Zd(ii,ggg)+50);
S11 = abs(S11);

%% Solution for Zin - Patch
    %Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))

    end 
end

%% Zin Geometric Parametric sweep

    %still need to write this code.
% figure; 
% plot(f*1e-9, real(Zd), f*1e-9, imag(Zd),'linewidth',2)
% hold on
% xlabel('Frequency [GHz]')
% ylabel('Zin')
% legend({'R';'X'})
% grid on
% set(gca,'fontsize',14)    
% xlim([0.1 0.6])
% ylim([-5000 5000])

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


figure(1) 
plot(dataAntW(:,1),dataAntW(:,2))
hold on 
plot(dataAntW(:,1),dataAntW(:,3))
plot(dataAntW(:,1),dataAntW(:,4))
plot(dataAntW(:,1),dataAntW(:,5))
hold off

figure(2)
plot(f*1e-9, 10*log10(S11(:,1)))
% hold on
% plot(f*1e-9, 10*log10(S11(:,2)))
% plot(f*1e-9, 10*log10(S11(:,3)))
% plot(f*1e-9, 10*log10(S11(:,4)))
% hold off
G = {'w_{0.02}','w_{0.2}','w_{0.3}','w_{0.5}','w_{0.02}','w_{0.2}','w_{0.3}','w_{0.5}'};
figure(3)
plot(f*1e-9,dataAntW(:,2))
hold on 
plot(f*1e-9,dataAntW(:,3))
plot(f*1e-9,dataAntW(:,4))
plot(f*1e-9,dataAntW(:,5))
plot(f*1e-9, 20*log10(S11(:,1)))
plot(f*1e-9, 20*log10(S11(:,2)))
plot(f*1e-9, 20*log10(S11(:,3)))
plot(f*1e-9, 20*log10(S11(:,4)))
hold off
columnlegend(2,G)
%'w_{0.02}','w_{0.2}','w_{0.3}','w_{0.5}','w_{0.02}','w_{0.2}','w_{0.3}','w_{0.5}'


 
