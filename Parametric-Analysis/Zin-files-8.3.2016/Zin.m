function [Z]  = Zin(f, w_ant, w2, h_ant, H_sub, rad, eps1,eps2, g, L_ant, startpos, L_sub, W_sub, viaflag)
%% Uses a dipole or probe fed relationship to enforce boundary conditions on

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
    
Y(:,:,ii) = HISantYmat_SS(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
ABCDt(:,:,ii) = HISlayerABCD(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);

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
MTL_R(:,:,ii) = UnitCells_antR(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
MTL_L(:,:,ii) = UnitCells_antL(f(ii), w_ant, w2, h_ant, H_sub, rad, eps1, eps2, g, L_ant, startpos, L_sub, W_sub, viaflag);
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
     


end 
