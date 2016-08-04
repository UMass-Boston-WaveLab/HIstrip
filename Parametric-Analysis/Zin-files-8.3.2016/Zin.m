function [Z]  = Zin(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L_ant, startpos, L_sub, W_sub, viaflag)
%% Uses a dipole or probe fed relationship to enforce boundary conditions on

%% Antenna/HIS geometries

sf = .05;        %scale factor from 300Mhz to 6Ghz
w_ant = 0.01*sf; %depends on kind of antenna placed on top of HIS
h_ant = 0.02*sf; %antenna height above substrate
L_ant = .48*sf;  %based on length of dipole at 6ghz which is .48lamba

H_sub = 0.04*sf; %ground to patch
L_sub = 1.12*sf;
W_sub = 1.12*sf;
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a =.14*sf;       %edge to edge patch length
len =.14*sf;     %length of microstrip ((a) for MTL section) segment above patches 

f = 6e9;
omega = 2*pi*f;

%% Constants
eps1 = 1;
eps2 = 2.2;
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);
startpos = 0;

%% Symbolic Variables

   % Vin = sym ('Vin');
   % Iin = sym ('Iin');
   % Zin = sym ('Zin');
   % V1b = sym ('V1b');
   % V2b = sym ('V2b');
   % I1b = sym ('I1b');
   % I2b = sym ('I2b');

%% Cascaded ABCD Matrix equations


[Y] = HISantYmat_1(f, w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
[ABCDt] = HISlayerABCD(f, w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);

% Components of 2x2 Transmission matrix through the HIS.
A = ABCDt(1,1);
B = ABCDt(1,2);
C = ABCDt(2,1);
D = ABCDt(2,2);

% Coupled Addmittance Matricies 
Pi = Yeq(Y, A, B, C, D);
Qi = Yeq(Y, A, B, C, D);
P = Y4toABCD4(Pi);

%Q = Y4toABCD4(Qi);
%Qii = inv(Q);

MTL_R = UnitCells_antR(f, w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
MTL_L = UnitCells_antL(f, w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
MTL_Li = inv(MTL_L);
ABCDz = (MTL_R)*(P)*(MTL_Li);
Zt = ABCD4toZ(ABCDz);

%% Symbolic Zin solution

    % K = [V1b; V2b; Iin; I2b];
    % Vi = [Vin; 0; 0; 0];
    % ZIN = sym('Z',[4 4])
    % ZIN1 = ZIN-E;
    % ZINi = inv(ZIN1);
    % Vi = (ZINi)*K
    % K = ZINi*Vi
 
 
    % A = sym( 'A', [2 2]);
    % B = sym( 'B', [2 2]);
    % C = sym( 'C', [2 2]);
    % D = sym( 'D', [2 2]);
    % 
    % ABCDv = [ A B; C D];
    % G = inv(ABCDv)

%% Solving for Zin with MTL matricies
    
%     ABCDz2 = ABCDz - E;
%     G2 = inv(ABCDz2);
%     K = G2*Vi;
%     F11 = K(1,1);
%     F21 = K(2,1);
%     F31 = K(3,1)/Vin;
%     F41 = K(4,1);
%     Z = 1/F31;

%% Find Z matrix From cascade of ABCD matricies (A different approach using Z matrix)
%%Convert ABCDz to Z matrix
    

    Z11 = Zt(1,1);
    Z12 = Zt(1,2);
    Z13 = Zt(1,3);
    Z14 = Zt(1,4);
    
    Z21 = Zt(2,1);
    Z22 = Zt(2,2);
    Z23 = Zt(2,3);
    Z24 = Zt(2,4);

    Z31 = Zt(3,1);
    Z32 = Zt(3,2);
    Z33 = Zt(3,3);
    Z34 = Zt(3,4);

    Z41 = Zt(4,1);
    Z42 = Zt(4,2);
    Z43 = Zt(4,3);
    Z44 = Zt(4,4);
 

    
%% Solution for Zin - Dipole    
%Zd = (Z21-Z23-Z41+Z43/(Z42-Z44-Z22+Z24)) + Z11-Z13 -(Z32-Z34)*(Z21-Z23-Z41+Z43/(Z42-Z44-Z22+Z24))+ Z31-Z33;


Zd = Z11 - Z13 + Z31 - Z33 + (1-Z32-Z34)*((Z21+Z43-Z23-Z41)/(Z24+Z42-Z22-Z44))

%% Patch
    
%%Patch Term Simplification    
%X = Y22 + Y24 + Y42 + Y44;

% Solution for Zin - Probe
%Zp = X/(X*(Y21+Y23+Y31+Y33) - (Y12+Y14-Y32-Y34)*(Y21+Y23-Y43-Y41))
end 