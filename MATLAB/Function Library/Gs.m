function [G] = Gs(w, s)
%% equation for self conductunace found in Pues and Van de Capelle eq (11)
%requires physical dimensions multiplied by wavenumber as input

G = (1/(pi*377))*((w*sinint(w)+sin(w)/w+cos(w)-2)*(1-s^2/24) + ...
    (s^2/12)*(1/3+cos(w)/w^2-sin(w)/w^3));
end

