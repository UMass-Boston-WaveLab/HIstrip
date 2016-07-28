function [  ] = plotYm(mind, maxd, l, f)
%makes plots of mutual admittance vs. separation distance using the VdC
%expression and Steven's numerical calculator.  s and l are specified in
%wavelengths, and so are min and max d.

lam = 3e8/f;
s = lam/50;

d = (mind:(maxd-mind)/100:maxd)*lam;
for ii = 1:length(d)
    VdCYm(ii) = VdCmutualY(l*lam, s*lam, d(ii), f);
end

AdmittanceAcrossEntireSlot_SS(l, l, maxd, f);

figure;
plot(d, VdCYm)
xlabel('Slot Separation (Wavelengths)')
ylabel('Mutual Admittance')
title(sprintf('Pues and Van de Capelle: %.2f lambda slots @ %.2f MHz; dy = lambda/50',l, f*10^-6))
end

