% function [ Cs, Cp ] = PPlate_gap( w,h,eps2,g, f )


clc
clear all;

%sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
sf = 1; 
w_ant = 0.01*sf; %depends on kind of antenna placed on top of HIS
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
% f=(100:50:600)*10^6;
f=300*10^6;
omega = 2*pi*f;

%% P-plate gap model from 
%"Young Ki Cho, "On the equivalent circuit representation of the slitted ....
% parallel-plate waveguide filled with a dielectric," in 
%IEEE Transactions on Antennas and Propagation, vol. 37, no. 9, pp. 1193-1200, Sep 1989.
"
%% inpots between to metal, thikness b
b=H_sub;
h1=b;

a1=gap/2;

eps1 = 2.2;
eps2 = 1;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
omega = 2*pi*f;
K1=omega*(mu0*eps0*eps1)^(.5);
K2=omega*(mu0*eps0*eps2)^(.5);
gab=2*a;
L1=2*pi*K1*a1;
L2=K1*b;



%% 

