function [ IntegrandEquation ] = HfieldIntegrandEquations
%Function accepts frequency and provides user with integrand equation.
%These equations can then be placed in Hfield functions. Electric field is
%always in the -y-direction

%General Constants
% frequency = frequency_input;
% lambda = 3E8/frequency;

%----------|r - r_prime|---------------------------------------------------
syms x y x_prime y_prime k E_0;
R = sqrt(((x-x_prime)^2) + ((y-y_prime)^2));

%----------G function-----------------------------------------------------
G = (exp(-1i*k*R))./(4*pi*R);

%----------Magnetic Current Stuff------------------------------------------
normal = [0,0,1];
%E_0 = 1;
electric_field_1 = [0,-E_0,0];
magnetic_current = cross(-normal,electric_field_1);

%---------DEL on G---------------------------------------------------------
Del_Del_G = [diff(G, x_prime,x_prime), diff(G, y_prime,y_prime),0];

%--------Magnetic Current dot DEL`) on (DEL on G)--------------------------
IntegrandEquation =  simplify(dot(magnetic_current, Del_Del_G) - (k^2)*magnetic_current(1)*G);

end

