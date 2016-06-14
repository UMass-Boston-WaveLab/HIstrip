function [Z]  = Zin(Vin, Iin, dpflag, patchflag,f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L, startpos, Lsub, Wsub, viaflag, P, Q)
%% Uses a dipole or probe fed relationship to enforce boundary conditions on


w1 = 0.01; %depends on kind of antenna placed on top of HIS
h_ant = 0.02; %antenna height above substrate
w2 = .12; %patch width
h2 = 0.04; %ground to patch
g = 0.02; %patch spacing
rad = .0015875; %via radius
L = .24; %based on length of dipole at 300mHz which is .48lamba
Lsub = 1.12;
Wsub = 1.12;
startpos = 0;
eps1 = 1;
eps2 = 2.2;
f = 300e6;
len = .14; %length of microstrip ((a) for MTL section) segment above patches 
mu0 = pi*4e-7;
omega = 2*pi*f;
a = .14; %edge to edge patch length
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1; %1 if HIS contains vias 0 otherwise
Vin = 1;
Iin = 1;
dpflag = 1;
patchflag = 0;

%% Find Z matrix From cascade of ABCD matricies

P = Y4toABCD4(Yeq);
Q = Y4toABCD4(Yeq);
MTL_R = UnitCells_antR(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L, startpos, Lsub, Wsub, viaflag);
MTL_L = UnitCells_antL(f, w1, w2, h_ant, h2, rad, eps1,eps2, g, L, startpos, Lsub, Wsub, viaflag);

%ABCD matrix that relates voltage and currents on either side of the feed
%point
ABCDz = (MTL_R)*(P)*(Q^-1)*(MTL_L^-1)

%convert ABCDz to Z matrix
Zt = ABCD4toZ(ABCDz);

%% Feedrelations 
Fv = [v1a, v1b, v2a, v2b];
Fi = [i1a, i1b, i2a, i2b];

%create function that automatically uses these relationships 
%Probe fed
if patchflag 
    
  Fv(1,1) = Vin  
  Fv(1,2) = Vin
  Fv(1,3) - Fv(1,4) = 0  %v2a = v2b;
  Fi(1,2)- Fi(1,1) = 0 -   i1a + Iin = i1b;
    i2a = i2b; 
    
    else dpflag
    %Dipole/differential fed
        v1a = v1b + Vin;
        v2a = v2b; 
        i1a = Iin;
        i1b = Iin; 
        i2a = i2b; 
    elseif 
        error('Declare feed relation case dpflag/patchflag')
  
    end 



end 