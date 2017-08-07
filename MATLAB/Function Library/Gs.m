function [G] = Gs(w, s)

%% equation for self conductunace found in Pues and Vandecapel eq (11)

w = k0*w_ant;
s = k0*h_ant;




G = (1/(pi*377))*((w*sinint(w)+sin(w)/w+cos(w)-2)*(1-s^2/24) + ...
    (s^2/12)*(1/3+cos(w)/w^2-sin(w)/w^3));
end

