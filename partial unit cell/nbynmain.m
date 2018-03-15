clc
clear all;
%% DEFINE PARAMETERS

sf = 1/20; %scale factor
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
w1=w_ant;
h_sub = 0.04*sf; %ground to patch distance
h_ant = 0.02*sf; %antenna height above substrate
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a=w2+g;       %unit cell size

L_sub = 8*a;
w_slot = a; %each HIS row is terminated by an equivalent radiating slot, so slot width is width of one row
L_ant = 0.48*sf; 
f=(100:5:600)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant+microstripdeltaL(w_ant, h_ant, eps1);
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA HALF
remainder = 0.5*L_ant_eff-N*a; %partial unit cell distance under antenna
botn = floor((L_sub-L_ant_eff)/(2*a))-1; % Number of compelete unit cell not under antenna===HIS
eps1 = 1;
eps2 = 2.2;

%% Constants
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);

%% load/enter per unit length capacitance matrices here
cap=[];
cap0=[];
HIScap=[];  %if we calculate the cap matrix with and without the top line 
HIScap0=[]; %and the HIS-related rows don't change, we may not need these 
            %to be calculated separately.

M=size(cap,1);  %minimum 2 - total number of non-GND conductors in multiconductor line including antenna layer
                % this is up to the user - don't have to include all the HIS rows if
                % only some are important to the results.



%% input impedance calculation steps
for ii = 1:length(f)
    Zin(ii)=nbynHIStripZin(w_ant, h_ant, L_ant,eps1, w2, h_sub, L_sub, eps2, a, g, rad, cap, cap0, HIScap, HIScap0, f(ii));
end
%% make plots
