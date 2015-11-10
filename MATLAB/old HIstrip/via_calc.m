function [L] = via_calc(h,r)
%uses Goldfarb and Pucel's 1991 result on modeling via holes in microstrip
mu = pi*4e-7;
if any(r>h)
    error('Equation does not apply for radius > substrate height');
end

L = (mu/(2*pi))*(h.*log((h+sqrt(r.^2+h.^2))./r)+1.5*(r-sqrt(r.^2+h.^2)));