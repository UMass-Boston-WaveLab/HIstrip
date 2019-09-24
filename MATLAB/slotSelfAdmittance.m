function [ Yself ] = slotSelfAdmittance(slotL, subh, eps, freq)
%HISANTYMAT computes 4x4 mutual admittance matrix of equivalent radiating 
% slots at ends of antenna and edges of substrate.
%   Assumes antenna is centered on substrate so dist between same-side ant
%   and sub slots is (L_sub-L_ant)/2.
%   Follows mutual admittance calculation technique outlined in technical 
%   report referenced by Pues and Van de Capelle 1984 (paper assumes
%   equal-size slots, which these are not)


k0 = 2*pi*freq/(3e8);

%% SELF ADMITTANCES
deltaL1 = microstripdeltaL(slotL,subh,eps);

beta1 = sqrt(eps)*k0;

Yc1 = 1/microstripZ0_pozar(slotL, subh, eps);

Bs1 = Yc1*tan(beta1*deltaL1);

Gs1 = Gs(slotL*k0, deltaL1*k0);

Yself = Gs1+j*Bs1;

end
