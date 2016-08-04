function [ Y ] = HISantYmat(w_ant, h_ant, L_ant,eps1, w_sub, h_sub, L_sub,eps2, freq, s, Kb)
%% HISANTYMAT computes 4x4 mutual admittance matrix of equivalent radiating 
%   slots at ends of antenna and edges of substrate.
%   Assumes antenna is centered on substrate so dist between same-side ant
%   and sub slots is (L_sub-L_ant)/2.
%   Follows mutual admittance calculation technique outlined in technical 
%   report referenced by Pues and Van de Capelle 1984 (paper assumes
%   equal-size slots, which these are not)

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
% Ys = Gs + jBs
% Bs = Yc*tan(beta*delta*deltaL

deltaL1 = microstripdeltaL(w_ant,h_ant,eps1);
deltaL2 = microstripdeltaL(w_sub, h_sub, eps2);


beta1 = 2*pi*freq*sqrt(eps1)/(3e8);
beta2 = 2*pi*freq*sqrt(eps2)/(3e8);

%characteristic addmittance of line
Yc1 = 1/microstripZ0_pozar(w_ant, h_ant, eps1);
Yc2 = 1/microstripZ0_pozar(w_sub, h_sub, eps2);

Bs1 = Yc1*tan(beta1*deltaL1);
Bs2 = Yc2*tan(beta2*deltaL2);

Gs1 = Gs(k0*w_ant, k0*deltaL1);
Gs2 = Gs(k0*w_sub, k0*deltaL2);

Ys_ant = Gs1+1i*Bs1;
Ys_sub = Gs2+1i*Bs2;

%% MUTUAL ADMITTANCES
%same-size slots have mutual coupling given by the expression in Pues and
%Van de Capelle 1984
Kg1 = 1; %check this because it's outside the range where their approximation was checked
Gm_ant = Gs1*Kg1*Fg(k0*L_ant,k0*deltaL1);
Ym_ant = Gm_ant;

Kg2 = 1;
Gm_sub = Gs2*Kg2*Fg(k0*L_sub, k0*deltaL2);
Ym_sub = Gm_sub;

%different-size slots have different mutual coupling and can't be computed
%from the Pues/Van de Capelle equation... but we can wildly estimate!
%Wherever the Gm above used single-slot quantities, I've used a geometric
%mean.

%Gm_near = sqrt(Gs1*Gs2)*Kg1*Fg(k0*(L_sub-L_ant)/2, k0*sqrt(deltaL1*deltaL2));
%Gm_far = sqrt(Gs1*Gs2)*Kg1*Fg(k0*((L_sub-L_ant)/2+L_ant), k0*sqrt(deltaL1*deltaL2));
%Bm1 = Bs1*Fb*Kb;
%Bm2 = Bs2*Fb*Kb;

Ym_near = 0 + 0*i;
Ym_far = 0 + 0*i;
%% MATRIX CONSTRUCTION

Yii = [Ys_ant Ym_near; Ym_near Ys_sub];
Yio = [Ym_ant Ym_far; Ym_far Ym_sub];
Yoi = Yio;
Yoo = Yii;

Y = [Yii Yio; Yoi Yoo];


end

