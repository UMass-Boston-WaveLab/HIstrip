function [ IntegrandEquation ] = HfieldIntegrandEquations
%Function accepts frequency and provides user with integrand equation.
%These equations can then be placed in Hfield functions. Electric field is
%always in the -y-direction

%General Constants
% frequency = frequency_input;
% lambda = 3E8/frequency;

%----------|r - r_prime|---------------------------------------------------
syms x y x_prime y_prime k;% E_0;
R = sqrt(((x-x_prime)^2) + ((y-y_prime)^2));

%----------G function-----------------------------------------------------
G = (exp(-1i*k*R))./(R);

%----------Magnetic Current Stuff------------------------------------------
normal = [0,0,1];
E_0 = 1;
electric_field_1 = [0,-E_0,0];
magnetic_current = cross(-normal,electric_field_1);

%---------DEL on G---------------------------------------------------------
%Magnetic Current dot Del = partial wrt to x_prime. See below: 
% PartialX_Del_G = [diff(G, x_prime,x_prime), diff(G, y_prime,x_prime),0]
% -This is the correct version, however the Y-term goes away once it is
% dotted with magnetic current in the final mutual admittance equation. 

IntegrandEquation = diff(G,x_prime, x_prime) - (k^2)*magnetic_current*G; %Instead use this equation for simplicity purposes. 


end

