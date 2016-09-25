function [ IntegrandEquation] = HfieldIntegrandEquations(frequency, slot_width)
%Function accepts frequency and provides user with integrand equation.
%These equations can then be placed in Hfield functions. Electric field is
%always in the -y-direction

%% General Constants
lambda = 3E8/frequency;
u_0 =  (1.25663706E-6);
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%Interval in terms of wavelength. 
dx = (1/20)*lambda;
dy = (1/20)*lambda; %width of slot 1

%% ----------|r - r_prime|---------------------------------------------------
syms x y x_prime y_prime k;
R = sqrt(((x-x_prime)^2) + ((y-y_prime)^2));

%----------G function-----------------------------------------------------
G = (exp(-1i*k*R))./(4*pi*R);

%----------Magnetic Current Stuff------------------------------------------
normal = [0,0,1];
E_0_slot1 = V_1/dy;
electric_field_1 = [0,E_0_slot1,0];
%electric_field_1 = [0,E_0_slot1*sin(pi*x_prime/(slot_width*lambda)),0];
magnetic_current = 2*cross(-normal,electric_field_1);

%---------DEL on G---------------------------------------------------------
%Magnetic Current dot Del = partial wrt to x_prime. See below: 
% PartialX_Del_G = [diff(G, x_prime,x_prime), diff(G, y_prime,x_prime),0]
% -This is the correct version, however the Y-term goes away once it is
% dotted with magnetic current in the final mutual admittance equation. 

IntegrandEquation = magnetic_current(1)*diff(G,x_prime, x_prime) + (k^2)*(magnetic_current(1))*G; %Instead use this equation for simplicity purposes. 


end

