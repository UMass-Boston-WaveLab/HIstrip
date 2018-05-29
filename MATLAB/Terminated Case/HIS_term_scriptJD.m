
clear all;
close all;
clc;
s=20; %scale factor
f = (100:1:600)*10^6*s;
a = 0.14/s;
w1 = 0.02/s; 
w2 = 0.12/s;
%h2 = 0.05/s;
h2 = 0.002;
h1 = 0.02/s+h2; 
via_rad = 0.005/s;
eps1 = 1;
eps2 = 2.2;
feed = 0; %1 for probe feed, 0 for diff

%% Import HFSS
%S11data = csvread('MagS11_Cu2.csv',1,0); 
% S11data1 = csvread('TermS11Via_2.csv',1,0);
% S11data2 = csvread('S11Term2.csv',1,0);
% S11data3 = csvread('S11Term3.csv',1,0);
% S11data4 = csvread('S11Term4.csv',1,0);
% Zindata1 = csvread('TermZinVia.csv',1,0);

%%

n = 4; % number of unit cells in model
%n = floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA
%digitsOld = digits(8);
%remainder = vpa(0.5*L_ant_eff-n*a);

L1 = viaL(h1-h2, via_rad);
L2 = viaL(h2, via_rad);

loadIndMat = [L1 0; 0 0]+L2*ones(2,2);

ZL = zeros(2,2);

Zin = zeros(size(f));

for ii = 1:length(f)
    ZL = (j*2*pi*f(ii)*loadIndMat);
    Zin(ii) = HIS_term_test_case(n, a, w1, w2, h1, h2, via_rad, eps1, eps2, f(ii), feed, ZL, ZL);
    if real(Zin(ii))<0
        sprintf('Check me\n')
    end
    S11_term(ii) = (Zin(ii)-50)/(Zin(ii)+50);
end
    magS11_term = abs(S11_term(:));

%% IEEE Plotting Standard Figure Configuration
    % run before the plot command
    % IEEE Transactions and Journals: 
    % Times New Roman is the suggested font in labels. 
    % For a singlepart figures labels should be in 8 to 10 points,
    % multipart figures, labels should be in 8 points.
    % Width: column width: 8.8 cm; page width: 18.1 cm.

%% width & height of the figure
% (You need to plot a figure which has a width of (8.8*k_scaling)
% in MATLAB, so that when you paste it into your paper, the width will be
% scalled down to 8.8 cm
k_scaling = 1; % scaling factor of the figure
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
    
figure(1); 
plot(f, real(Zin), f*1e-6, imag(Zin),'linewidth',1)
% hold on 
% plot(f*1e-6, Zindata1(:,2), f*1e-6, Zindata1(:,3),'linewidth',1)
%hold off
xlabel('Frequency [MHz]')
ylabel('\Omega')
grid on
set(gca,'fontsize',14)
legend({'R Model';'X Model';'R HFSS';'X HFSS'})

figure(2); 
plot(f, 20*log10((magS11_term)))
% hold on 
% plot(f*1e-6, 20*log10(S11data1(:,2)))
% hold off
xlabel('Frequency [MHz]')
ylabel('|S_{11}|')
legend({'Model';'HFSS'})
grid on
set(gca,'fontsize',12)


figure(3); 
plot(f*1e-6, abs(S11data1(:,2)-magS11_term))
xlabel('Frequency [MHz]')
ylabel('|S_{11}|')
grid on
set(gca,'fontsize',12)

figure(4)
plot(f*1e-6, 20*log10(S11data1(:,2)));
hold on 
plot(f*1e-6, 20*log10(S11data2(:,2)));
plot(f*1e-6, 20*log10(S11data3(:,2)));
plot(f*1e-6, 20*log10(S11data4(:,2)));
hold off
xlabel('Frequency [MHz]')
ylabel('|S_{11}|')
legend({'1 Row';'3 Rows';'6 Rows';'8 Rows'})
grid on
set(gca,'fontsize',12)


% figure(6); 
% plot(f*1e-9, abs(Zin))
% hold on
% plot(f*1e-9,Zindata1(:,2))
% xlabel('Frequency [GHz]')
% ylabel('|Z_{in}|')
% grid on
% set(gca,'fontsize',10)
% legend({'Model';'HFSS'})

%maxdeltaS=max(abs(S11data(:,2)-magS11_term));
%mindeltaS=min(S11data(:,2)-min(magS11_term));


