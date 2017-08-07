function [Fg] = Fg(l, s)
%% Fg is a coupling function expressing the ratio between the per-unit-length mutual admittance and the per unit length self admittance.

Fg = besselj(0,l)+s^2*besselj(2,l)/(24-s^2);
end

