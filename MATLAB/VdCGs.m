function [G] = VdCGs(w, s)
%self admittance of a slot from van de capelle, dimensions in wavelengths.
G = (1/(pi*377))*((w*sinint(w)+sin(w)/w+cos(w)-2)*(1-s^2/24) + ...
    (s^2/12)*(1/3+cos(w)/w^2-sin(w)/w^3));
end


