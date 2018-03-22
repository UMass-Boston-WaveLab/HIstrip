% function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)

%% Uses a dipole or probe fed relationship to enforce boundary conditions on

%% Antenna/HIS geometries
close all;
clc
clear all;

%sf = .05; %scale factor from 300Mhz to 6Ghz,,, ==Lamda
% the best/hanna antenna is actually a 0.005m radius dipole
%"the equivalent strip width for a cylindrical wire is almost twice (~1.89)
%the wire diameter"
% (see "Equivalent Strip Width for Cylindrical Wire for Mesh Reflector
% Antennas: Experiments, Waveguide, and Plane-Wave Simulations")
sf = 1; 
% <<<<<<< HEAD
w_ant = 0.0189*sf; %depends on kind of antenna placed on top of HIS
% =======
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
% >>>>>>> 0d731aa100612fd3954213f7e003831151dc5ee2
w1=w_ant;
H_sub = 0.04*sf; %ground to patch distance
h2=H_sub;
h_ant = 0.02*sf; %antenna height above substrate
h1=h_ant+h2;
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
gap=g;
a =w2+g;       %unit cell size

L_sub = 8*a;
w_sub = 1*a;
% <<<<<<< HEAD
% w_sub = 2*a;

% L_ant = 0.48; 
% =======
L_ant = 0.48*a; 
% >>>>>>> 0d731aa100612fd3954213f7e003831151dc5ee2
%f = 2e9:250e6:10e9; %f vector sweep for 6ghz
%f = 1e9:500e6:6.5e9;
f=(100:1:600)*10^6/sf;
% omega = 2*pi*f;
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






mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);

cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric

 figure(1); 
plot(f*1e-9, f*1e-9*abs(C120)./(f*1e-9*10^(-12)),'linewidth',2);
hold on
plot(f*1e-9, f*1e-9*abs(C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
hold on
plot(f*1e-9, f*1e-9*abs(C120+C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
legend('C120','C2G0','C120+C2G0');


% ylim([-400 800])


cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric

%alternative option for calculating PUL capacitance - also not so hot
%really
% cap = SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[eps1 eps2]);
% cap0=SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[1 1]);
% len=L_ant;
% [ Zw, ABCD] = nbynMTL1(cap, cap0, f, len);


ind = mu0*eps0*inv(cap0); %symmetric
Zw11=ones(1,length(f));
Zw12=ones(1,length(f));
Zw22=ones(1,length(f));
Zw21=ones(1,length(f));

for ii = 1:length(f)
omega = 2*pi*f(ii);
% [ Zw, ABCD ] = nbynMTL1(cap, cap0, f, len);
Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = sqrt(diag(gamsq));

Zw = Gam\Z; %symmetric
Zw11(1,ii)=Zw(1,1);
Zw12(1,ii)=Zw(1,2);
Zw21(1,ii)=Zw(2,1);
Zw22(1,ii)=Zw(2,2);

% Yw(ii)= Y/Gam; %symmetric


end
figure(2);
plot(f*1e-9, Zw11,'linewidth',2);
hold on
plot(f*1e-9, Zw12,'linewidth',2);
hold on
plot(f*1e-9, Zw22,'linewidth',2);
legend('Z11','Z12','Z22');


% figure(1); 
% hold on
% plot(f*1e-9, f*1e-9*abs(C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
% hold on
% plot(f*1e-9, f*1e-9*abs(C120+C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
% legend('C120','C2G0','C120+C2G0');
% 
% 
% 
% 
% figure(2); 
% % hold on
% % plot(f*1e-9, f*1e-9*abs(C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
% % hold on
% % plot(f*1e-9, f*1e-9*abs(C120+C2G0)./(f*1e-9*10^(-12)),'linewidth',2);
% % legend('C120','C2G0','C120+C2G0');
% 
% 
% MTL = [T*diag(cosh(gameig*len))/T, (T*diag(sinh(gameig*len))/T)*Zw; 
%         Yw*T*diag(sinh(gameig*len))/T, Yw*T*diag(cosh(gameig*len))/T*Zw];
% 
