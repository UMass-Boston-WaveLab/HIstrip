function [G] = Gs(w, s)

%% equation for self conductunace found in Pues and Vandecapel eq (11)

% w_ant = .01;
% h_ant = .02;
% L_ant = .48; 
% w_sub = 1.12;
% h_sub = 0.04;
% L_sub = 1.12;
% eps1 = 1;
% eps2 = 2.2;
% freq = 300e6;
% k0 = 2*pi*freq/(3e8);
% w = k0*w_ant;
% s = k0*h_ant;
% E = exp(-0.21*w);
% Kb = 1 - E;

% w = k0*w_ant;
% s = k0*h_ant;

G = (1/(pi*377))*((w*sinint(w)+sin(w)/w+cos(w)-2)*(1-s^2/24) + ...
    (s^2/12)*(1/3+cos(w)/w^2-sin(w)/w^3));
end

