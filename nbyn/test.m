close all;
clc
clear all;

%sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
% the best/hanna antenna is actually a 0.005m radius dipole
%"the equivalent strip width for a cylindrical wire is almost twice (~1.89)
%the wire diameter"
% (see "Equivalent Strip Width for Cylindrical Wire for Mesh Reflector
% Antennas: Experiments, Waveguide, and Plane-Wave Simulations")
sf = 1/20; 
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
w1=w_ant;
H_sub = 0.04*sf; %ground to patch distance
h2=H_sub;
h_ant = 0.02*sf; %antenna height above substrate
h1=h_ant+H_sub;
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a =w2+g;       %unit cell size

L_sub = 8*a;
w_sub = 1*a;
% <<<<<<< HEAD
% w_sub = 2*a;

L_ant = 0.48*sf; 
% =======
 
% >>>>>>> 0d731aa100612fd3954213f7e003831151dc5ee2
%f = 2e9:250e6:10e9; %f vector sweep for 6ghz
%f = 1e9:500e6:6.5e9;
f=(100:5:600)*10^6/sf;
omega = 2*pi*f;

%% Constants
eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;


for ii = 1:length(f)
    [ MTL, cap, cap0 ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f(ii), L_ant);
    [ HIScap, HIScap0 ] = ustripMTLABCD_HIS( w1, h1, w2, h2, eps1, eps2, f(ii))
    [ Zin ] = nbynHIStripZin(w1, h1, L_ant,eps1, w2, h2, L_sub, eps2, a, g, rad, cap, cap0, HIScap, HIScap0, f(ii));
end 

    