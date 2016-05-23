function [ IntegrandEquation ] = HfieldIntegrandEquations( frequency_input, electric_field_magnitute )
%Function accepts frequency and provides user with integrand equation.
%These equations can then be placed in Hfield functions. Electric field is
%always in the -y-direction

%General Constants
frequency = frequency_input;
lambda = 3E8/frequency;
k = 2*pi/lambda;

%----------First Half of Full Integral-------------------------------------

%----------|r - r_prime|---------------------------------------------------
syms x y x_prime y_prime;
r = x + y;
r_prime = x_prime + y_prime;
R = norm(r,r_prime);

%----------G function-----------------------------------------------------
G = (exp(-1i*k*R))/(4*pi*R);

%----------Magnetic Current Stuff------------------------------------------
normal = [0,0,1];
E_0 = electric_field_magnitute;
electric_field_1 = [0,-E_0,0];
magnetic_current = cross(-normal,electric_field_1);

%---------DEL on G---------------------------------------------------------
Del_G = diff(G, x_prime) + diff(G, y_prime);

%--------Magnetic Current dot DEL`) on (DEL on G)--------------------------
IntegrandEquation = magnetic_current(1)*diff(Del_G, x_prime) + magnetic_current(2)*diff(Del_G, y_prime)+(k^2)*magnetic_current(1)*G;

end

