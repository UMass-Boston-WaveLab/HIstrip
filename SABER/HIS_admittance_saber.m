function [Y_12, Y_13, Y_14, Y_23, Y_24, Y_34] = HIS_admittance_saber(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, frequency)

%% inputs
% No.1 and 4 for antenna slots and 2,3 for HIS slots
% arrangmet 1234
% s=20; %scale factor
% n=4; % number of unit cells in model
% % frequency = (100:2.5:400)*1e6*s;
% frequency = 100*1e6*s;
% 
% sep_12=4;
% sep_13=4.5;
% sep_14=8.5;
% sep_23=.5;
% sep_24=4.5;
% sep_34=4;
% slot_1_x=4;
% slot_2_x=.5;
% slot_3_x=.5;
% slot_4_x=4;



%% Mutual admitance
Y_12 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_2_x, slot_1_x, sep_12, frequency)
Y_13 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_1_x, slot_3_x, sep_13, frequency)
Y_14 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_4_x, slot_1_x, sep_14, frequency)
Y_23 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_2_x, slot_3_x, sep_23, frequency)
Y_24 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_2_x, slot_4_x, sep_24, frequency)
Y_34 = AdmittanceAcrossEntireSlot_matrix_mod_saber(slot_3_x, slot_4_x, sep_34, frequency)


%% 
%self Admitance

%HISANTYMAT computes 4x4 mutual admittance matrix of equivalent radiating 
% slots at ends of antenna and edges of substrate.
%   Assumes antenna is centered on substrate so dist between same-side ant
%   and sub slots is (L_sub-L_ant)/2.
%   Follows mutual admittance calculation technique outlined in technical 
%   report referenced by Pues and Van de Capelle 1984 (paper assumes
%   equal-size slots, which these are not)

%% 
w_ant = .01;
h_ant = .02;
L_ant = .48; 
w_sub = 1.12;
h_sub = 0.04;
L_sub = 1.12;
eps1 = 1;
eps2 = 2.2;
freq = 300e6;
k0 = 2*pi*freq/(3e8);
w = k0*w_ant;
l = k0*L_ant;
s = k0*h_ant;
E = exp(-0.0021);
Kb = 1 - E;




%% SELF ADMITTANCES
deltaL1 = microstripdeltaL(w_ant,h_ant,eps1);
deltaL2 = microstripdeltaL(w_sub, h_sub, eps2);

k0=2*pi*freq/(3e8);
beta1 = 2*pi*freq*sqrt(eps1)/(3e8);
beta2 = 2*pi*freq*sqrt(eps2)/(3e8);

Yc1 = 1/microstripZ0_pozar(w_ant, h_ant, eps1);
Yc2 = 1/microstripZ0_pozar(w_sub, h_sub, eps2);

Bs1 = Yc1*tan(beta1*deltaL1);
Bs2 = Yc2*tan(beta2*deltaL2);

Gs1 = Gs(k0*w_ant, k0*deltaL1);
Gs2 = Gs(k0*w_sub, k0*deltaL2);

Ys_ant = Gs1+j*Bs1;
Ys_sub = Gs2+j*Bs2;

%% 

%% MATRIX CONSTRUCTION

Y = [Ys_sub Y_12 Y_13 Y_14;
    Y_12 Ys_ant Y_23 Y_24;
    Y_13 Y_23 Ys_ant Y_34;
    Y_14 Y_24 Y_34 Ys_sub];

end