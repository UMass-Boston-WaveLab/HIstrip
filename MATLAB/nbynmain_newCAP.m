close all;
clc
clear all;
%% DEFINE PARAMETERS

sf = 1/1; %scale factor
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
w1=w_ant;
h_sub = 0.04*sf; %ground to patch distance
h_ant = 0.02*sf; %antenna height above substrate
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a=w2+g;       %unit cell size

eps1 = 1;
eps2 = 2.2;

L_sub = 8*a;
w_slot = a; %each HIS row is terminated by an equivalent radiating slot, so slot width is width of one row
L_ant = 0.48*sf; 
f=(100:5:600)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant+microstripdeltaL(w_ant, h_ant, eps1);
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA HALF
remainder = 0.5*L_ant_eff-N*a; %partial unit cell distance under antenna
botn = floor((L_sub-L_ant_eff)/(2*a))-1; % Number of compelete unit cell not under antenna===HIS


%% Constants
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);

%% load/enter per unit length capacitance matrices here

% DATA FROM HFSS
% cap=(1e-12)*[33 -29; -29 117];
% cap0=(1e-12)*[33 -29; -29 75];
% HIScap=117e-12;  %if we calculate the cap matrix with and without the top line 
% HIScap0=75e-12; %and the HIS-related rows don't change, we may not need these 
%             %to be calculated separately.

% DATA FROM OUR CAP CALCULATOR
% <<<<<<< HEAD
% <<<<<<< HEAD
% cap=(1e-12)*[29 -29; -29 117];
% cap0=(1e-12)*[27 -27; -27 74];
% HIScap=117e-12;  %if we calculate the cap matrix with and without the top line 
% HIScap0=75e-12; %and the HIS-related rows don't change, we may not need these 
%             %to be calculated separately.
% =======
% =======

% cap=(1e-12)*[29 -29; -29 117];
% cap0=(1e-12)*[27 -27; -27 74];
% HIScap=117e-12;  %if we calculate the cap matrix with and without the top line 
% HIScap0=75e-12; %and the HIS-related rows don't change, we may not need these 
%             %to be calculated separately.

% cap=(1e-12)*[29 -29; -29 117];% 1 row
% cap0=(1e-12)*[27 -27; -27 74];% 1row
% HIScap=117e-12;  % 1 row if we calculate the cap matrix with and without the top line 
% HIScap0=75e-12; % 1row and the HIS-related rows don't change, we may not need these 
%             %to be calculated separately.
            
cap=(1e-12)*[33.33 28.42 1.73 0.38 0.22;...
             28.42 124.65 14.80 0.6 0.34; ...
             1.73 14.80 103.02 16.08 0.98; ...
             0.38 0.60 16.08 102.87 16.41; ...
             0.22 0.34 0.98 16.41 91.08]; %7ROW
% cap=cap(1:2, 1:2);%1ROW
% cap=cap(1:3, 1:3); %3ROW
% cap=cap(1:4, 1:4); %5ROW
         
      

HIScap=cap(2:end, 2:end);            

cap0=(1e-12)*[33.30 28.54 1.75 0.39 0.24;...
             28.54 81.38 11.47 0.64 0.38; ...
             1.75 11.47 59.85 12.72 1.02; ...
             0.39 0.64 12.72 59.72 13.09; ...
             0.24 0.38 1.02 13.09 54.24];
         
%   cap0=cap0(1:2, 1:2);%1ROW
% cap0=cap0(1:3, 1:3); %3ROW
% cap0=cap0(1:4, 1:4); %5ROW 

HIScap0=cap0(2:end, 2:end);   


% >>>>>>> 0c6e25044a3cf1f453beb8255d28abcf4e6d5614

% =======
HIScap0=cap0(2:end, 2:end);  


% >>>>>>> 37f130a5a6551ce4c44710cc13c54cce1d8d2d8d

M=size(cap,1);  %minimum 2 - total number of non-GND conductors in multiconductor line including antenna layer
                % this is up to the user - don't have to include all the HIS rows if
                % only some are important to the results.
midHISindex=2; %the index of the MTL conductor that is below the antenna.  If even geometry, this can be a 1x2 vector.  If very wide top conductor, this can be a 1xn vector.


%% input impedance calculation steps
for ii = 1:length(f)
    
    Zin(ii)=nbynHIStripZin(w_ant, h_ant, L_ant,eps1, w2, h_sub, L_sub, eps2, a, g, rad, cap, cap0, HIScap, HIScap0, f(ii));
    S11(ii) = (Zin(ii)-50)/(Zin(ii)+50);
end
%% make plots
 figure; 
plot(f*1e-9, real(Zin), f*1e-9, imag(Zin),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('Zin')
legend({'R';'X'})
grid on
set(gca,'fontsize',14)    
% xlim([0.1 0.6])
% ylim([-400 800])



figure; 
plot(f*1e-9, 20*log10(abs(S11)), 'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('|S_{11} (dB)')
grid on
set(gca,'fontsize',14)
% xlim([0.1 0.6])