function [ Zin ] = nbynHIStripZin(w1, h1, L_ant,eps1, w2, h2, L_sub, eps2, a, g, rad, cap, cap0, HIScap, HIScap0, f)
%NBYNHISTRIPZIN does the bulk of the work to calculate the input impedance
%to a HIS-backed microstrip antenna.  It calls many other functions and
%puts all the input together.  It accounts for more than one HIS row below
%the antenna layer, which is why it has nbyn in the name.  Assumes
%differential feed.



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
slot_1_x=w1;
slot_2_x=w2;
slot_3_x=w1;
slot_4_x=w2;

L_ant_eff = L_ant+microstripdeltaL(w1, h1, eps1);
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA HALF
remainder = 0.5*L_ant_eff-N*a; %partial unit cell distance under antenna
botn = floor((L_sub-L_ant_eff)/(2*a))-1; % Number of compelete unit cell not under antenna===HIS

%% Constants
viaflag = 1;

%% Assemble equivalent slot termination
    Y(:,:) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f,...
                w2, h1, L_ant,eps1, w_slot, h2, L_sub,eps2);  
 
    Z=inv(Y);
    
    %% Assemble bare HIS ABCDs
    [ABCD, ABCDgaphalfsp,ABCDline,ABCDL,ABCDgaphalfps]=nbynHISABCD(HIScap, HIScap0, a, g, h2, rad, viaflag, f);
    
    %% Assemble unit slice ABCD and covered partial cell ABCDs
    if viaflag
        Lmat = nbynviaABCD(h2, via_rad, f, N);
    else
        Lmat = eye(2*N);
    end
    
    [Cseries, Cshunt] = nbyncapABCD(h2, w2, eps2, gap, N, f);
    
    unitslice=nbynunitcell(cap, cap0, a, w2, h2, via_rad, eps2, f, N, viaflag);   
    
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

    Yin = inv(ZinR+ZinL);
    Zin = 1/Yin(1,1);

end

