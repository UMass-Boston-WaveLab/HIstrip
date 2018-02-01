% function [Z]  = Zin(f, w_ant, w2, h_ant, h_sub, rad, eps1,eps2, g, L_ant, startpos, L_sub, w_sub, viaflag)
%% Uses a dipole or probe fed relationship to enforce boundary conditions on
clc
clear all;
%% 
sf = 1; 
w_ant = 0.01*sf; %depends on kind of antenna placed on top of HIS
h_ant = 0.02*sf; %antenna height above substrate
L_ant = .48*sf;  %based on length of dipole at 6ghz which is .48lamba

h_sub = 0.04*sf; %ground to patch distance
L_sub = 1.12*sf;
w_sub = 1.12*sf;
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a =.14*sf;       %edge to edge patch length
len =.14*sf;     %length of microstrip ((a) for MTL section) segment above patches 

%f = 2e9:250e6:10e9; %f vector sweep for 6ghz
f = 3e9:100e6:6.5e9;
omega = 2*pi*f;

eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);
startpos = 0;


omega = 2*pi*f;

%% Constants
mu0 = pi*4e-7;
eps0 = 8.854e-12;
E = eye(4);


%% Symbolic Variables

   % Vin = sym ('Vin');
   % Iin = sym ('Iin');
   % Zin = sym ('Zin');
   % V1b = sym ('V1b');
   % V2b = sym ('V2b');
   % I1b = sym ('I1b');
   % I2b = sym ('I2b');

%% Cascaded ABCD Matrix equations

for ii = 1:length(f)
    
Y(:,:,ii) = HISantYmat_SS(w_ant, h_ant, L_ant, eps1, w_sub, h_sub, L_sub, eps2, f(ii));
ABCDt(:,:,ii) = HISlayerABCD(w2, g, h_sub, rad, eps2, f(ii), viaflag, eps1, mu0, eps0, L_sub, w_ant);
% Components of 2x2 Transmission matrix through the HIS.
A = ABCDt(1,1,ii);
B = ABCDt(1,2,ii);
C = ABCDt(2,1,ii);
D = ABCDt(2,2,ii);


% Coupled Addmittance Matricies P and Q - Right and Left respectivley 

Pi(:,:,ii) = Yeq(Y(ii), A, B, C, D);
P(:,:,ii) = Y4toABCD4(Pi);

Qi(:,:,ii) = Yeq(Y(ii), A, B, C, D);
Q = Y4toABCD4(Qi);
Qii(:,:,ii) = 1\Q;


%Cascade of 4x4 unit cells for left and right of source voltage. 
MTL_R(:,:,ii) = UnitCells_antR(f(ii), w_ant, w2, h_ant, h_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, w_sub, viaflag);
MTL_L(:,:,ii) = UnitCells_antL(f(ii), w_ant, w2, h_ant, h_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, w_sub, viaflag);
MTL_Li(:,:,ii) = 1\(MTL_L(:,:,ii));


%Total cascaded ABCD matrix
%ABCDz(:,:,ii) = MTL_R(:,:,ii)*MTL_Li(:,:,ii)
ABCDz(:,:,ii) = MTL_R(:,:,ii).*P(:,:,ii).*MTL_L(:,:,ii);

%Convert total ABCD to Z matrix for solutions for the input impedance
Zt(:,:,ii) = ABCD4toZ(ABCDz);



%% Components of Z matrix

    Z11 = Zt(1,1,ii);
    Z12 = Zt(1,2,ii);
    Z13 = Zt(1,3,ii);
    Z14 = Zt(1,4,ii);

    Z21 = Zt(2,1,ii);
    Z22 = Zt(2,2,ii);
    Z23 = Zt(2,3,ii);
    Z24 = Zt(2,4,ii);

    Z31 = Zt(3,1,ii);
    Z32 = Zt(3,2,ii);
    Z33 = Zt(3,3,ii);
    Z34 = Zt(3,4,ii);

    Z41 = Zt(4,1,ii);
    Z42 = Zt(4,2,ii);
    Z43 = Zt(4,3,ii);
    Z44 = Zt(4,4,ii);
 
    
%% Solution for Zin - dipole

%Zd(ii,:,:) = Z11 - Z13 + Z31 - Z33 + (1-Z32-Z34)*((Z21+Z43-Z23-Z41)/(Z24+Z42-Z22-Z44))
Zd(ii,:,:) = Z11 - Z13 + Z31 - Z33 + (Z21-Z23-Z41+Z43)/(Z42-Z44-Z22+Z24)-(Z32-Z34)*((Z21-Z23-Z41+Z43)/(Z42-Z44-Z22+Z24))

%% Solution for Zin - Patch

                %%Patch Term Simplification    
                %X = Y22 + Y24 + Y42 + Y44;

                % Solution for Zin - Probe
                %Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))


end 


%% Zin Geometric Parametric sweep

    %still need to write this code.
     


% end 
