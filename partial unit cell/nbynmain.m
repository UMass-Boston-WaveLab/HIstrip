clc
clear all;
%% DEFINE PARAMETERS

M=5; %minimum 2 - total number of non-GND conductors in multiconductor line including antenna layer
     % this is up to the user - don't have to include all the HIS rows if
     % only some are important to the results.

sf = 1/20; %scale factor
w_ant = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
w1=w_ant;
H_sub = 0.04*sf; %ground to patch distance
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

%% slot spacing description

% % % |<--------Lsub----------->|
% % % |                         | 
% % % |        |<-Lant>|        |
% % % |        |       |        |
% % % |        |       |        |
% % % |        2       3        | 
% % % |                         |
% % % |                         | 
% % % 1                         4           
sep_12=L_sub/2-L_ant/2;
sep_13=L_sub/2+L_ant/2;
sep_14=L_sub;
sep_23=L_ant;
sep_24=L_sub/2+L_ant/2;
sep_34=L_sub/2-L_ant/2;
slot_1_x=w_ant;
slot_2_x=w_slot;
slot_3_x=w_ant;
slot_4_x=w_slot;

%% input impedance calculation steps
for ii = 1:length(f)
    %% Assemble equivalent slot termination
    Y(:,:) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f(ii),...
                w_ant, h_ant, L_ant,eps1, w_sub, H_sub, L_sub,eps2, f(ii));  
 
    Z=inv(Y);
    
    %% Assemble bare HIS ABCDs
    [ABCD, ABCDgaphalfsp,ABCDline,ABCDL,ABCDgaphalfps]=nbynHISABCD(HIScap, HIScap0, a, g, h_sub, rad, viaflag, f(ii));
    
    %% Assemble unit slice ABCD and covered partial cell ABCDs
    if viaflag
        Lmat = nbynviaABCD(h2, via_rad, f(ii), N);
    else
        Lmat = eye(2*N);
    end
    
    [Cseries, Cshunt] = nbyncapABCD(h2, w2, eps2, gap, N, f(ii));
    
    MTL = nbynMTL(cap, cap0, f(ii), a/2);
    
    unitslice=nbynunitcell(cap, cap0, a, w2, h2, via_rad, eps2, f(ii), N, viaflag);   
    
    
    %% calculate input impedance of HIS-only section
    %HIS is terminated by admittance of HIS-edge slots. We ignore mutual
    %coupling because the cross terms in this matrix are really small. If
    %we needed to include mutual coupling, the Y matrix would have to
    %include all the slots.
    
    ZLtemp=Z(1,1)*eye(N);
    ZRtemp=Z(4,4)*eye(N);
    
    temp={ABCDgaphalfsp,ABCDline,ABCDL,ABCDline};
    
    for jj=length(temp):-1:1
        ZLtemp = unitcellMultiply(ZLtemp, temp{jj}, 1);%  last HIS connection from ground side to load
    end
    ZinL_HIS = unitcellMultiply(ZLtemp, ABCD, botn);% HIS from antenna edge to last HIS connection from ground side
    
    for jj=length(temp):-1:1
        ZRtemp = unitcellMultiply(ZRtemp, temp{jj}, 1);% RIGHT
    end
    ZinR_HIS = unitcellMultiply(ZRtemp, ABCD(:,:,ii), botn);
    
    %% deal with partial unit cells
    
    ZinR = nbynpartialcells(ZinR_HIS, Z(3,3), cap, cap0, HIScap, HIScap0, f(ii), a, gap, remainder, Lvia, Cseries, Cshunt, ABCDL, ABCDgaphalfsp, ABCDgaphalfps);
    ZinL = nbynpartialcells(ZinL_HIS, Z(2,2), cap, cap0, HIScap, HIScap0, f(ii), a, gap, remainder, Lvia, Cseries, Cshunt, ABCDL, ABCDgaphalfsp, ABCDgaphalfps);
    %% calculate input impedance of covered section
    ZinR = unitcellMultiply(ZinR, unitslice, N);
    ZinL = unitcellMultiply(ZinL, unitslice, N);
    %% calculate final input impedance
end
%% make plots
