function [Admittance, Admittance_Closed] = Admittance_Test(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation,frequency)
%Admittance Test deals with BOTH the numerical calculator and the closed
%form expression. The code for the Numerical Calculator is the same from
%AdmittanceAcrossEntireSlot_matrix. 
 
%% General Constants
lambda = 3E8/frequency;
u_0 =  (1.25663706E-6);
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%% Slot Dimensions: 
%Slot 2 dimensions in terms of inputs (in wavelengths)
slot_2_length_x_f = (slot_2_x_dist)*lambda; slot_2_width_y_f = (slot_1_2_y_dist)*lambda; 

%Slot 1 dimensions in terms of inputs (in wavelengths)
slot_1_length_x_f = (slot_1_x_dist)*lambda; slot_1_width_y_f = (slot_1_2_y_dist)*lambda; 

%% Interval in terms of wavelength.

dy_segments_max_slot1 = slot_1_width_y_f/2;

dy = slot_1_width_y_f/floor(slot_1_width_y_f/dy_segments_max_slot1);
dy_2 = dy;
 
dx_max = (1/10)*lambda;
dx_max_2 = (1/10)*lambda;

dx = slot_1_length_x_f/floor(slot_1_length_x_f/dx_max);
dx_2 = slot_2_length_x_f/floor(slot_2_length_x_f/dx_max_2);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

%% Magnetic Current Stuff. Rearrange for different electric field disbrutions. Or use HfieldIntegrandEquation function

E_0_slot2 = V_2/(2*dy);
E_0_slot1 = V_1/(2*dy);

E_0_slot2_c =V_2/dy;
E_0_slot1_c = V_1/dy;

%% Admittance Function

%Slot seperation in wavelengths.
y_sep = (slot_seperation)*lambda;

%Build matrix to store H-field values across all of slot 2's dimensions----
%Each index will have H-field at one y-point distance,and one x-distances.
XX_2 = length(dx_2:dx_2:slot_2_length_x_f); YY_2 = length(dy_2:dy_2:slot_2_width_y_f);
H_field_at_2 = zeros(YY_2,XX_2);

%Delta x and y (increments) for the primed space
delta_x_prime = dx;
delta_y_prime = dy;

%Matrix to hold H-field values at one y distance. Each index will hold
%admittance values at different seperation distances (intervals of dy)
XX_1 = length(dx:dx:slot_1_length_x_f); YY_1 = length(dy:dy:slot_1_width_y_f);
Temp_Matrix = zeros(YY_1, XX_1);

%The 3 (THREE) different forms for H_Field_at_2 represent: sinusoidal
%E-field and no ground plane, sinusoidal with ground plane, and constant
%e-field w/o GP
Y_i = 1; 
for y = y_sep:dy:y_sep+slot_1_width_y_f
    X_i = 1;
    for x = 0:dx:slot_1_length_x_f
        Y_prime_i = 1;
        for y_prime = dy_2:dy_2:slot_2_width_y_f
            X_prime_i = 1;
            for x_prime = 0:dx_2:slot_2_length_x_f
                %H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*sin((pi*x_prime)/slot_2_length_x_f)*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*sin((pi*x_prime)/slot_2_length_x_f))/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
                %H_field_at_2(Y_prime_i,X_prime_i) = - E_0_slot2*sin((pi*x_prime)/slot_2_length_x_f)*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*sin((pi*x_prime)/slot_2_length_x_f))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
                H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)));
                X_prime_i = X_prime_i + 1;
            end
            Y_prime_i = Y_prime_i + 1;            
        end
       %Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1*sin(pi*x/(slot_1_length_x_f))))/(omega*u_0*1i));
       %Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((E_0_slot1*sin(pi*x/(slot_1_length_x_f))))/(omega*u_0*1j));
       Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1))/(omega*u_0*1j));
       X_i = X_i + 1;
    end
    Y_prime_i = Y_prime_i + 1;
end
Admittance = sum(sum(Temp_Matrix*delta_x_prime*delta_y_prime)*(-1/(V_1*V_2)));

%% Closed Form Expression Stuff

L1 = slot_1_length_x_f;
L2 = slot_2_length_x_f;
d = y_sep;

%% Expression #6 
order_6 = 10;
H6_total = H_6_xOrder(L2, L1, d, frequency, order_6);

%Expression #4
order_4 = 6;
H4_total = H_4_xOrder(L2, L1, d, frequency, order_4);

%Expression #3
order_3 = 3;
H3_total = H_3_xOrder(L2, L1, d, frequency, order_3);

%% Expression #5
order_5 = 14;
H5_total = H_5_xOrder(L2, L1, d, frequency, order_5);

%Expression #2
order_2 = 15;
H2_total = H_2_xOrder(L2, L1, d, frequency, order_2);

%Expression #1 
order_1 = 20;
H1_total = H_1_xOrder(L2, L1, d, frequency, order_1);
 
%% Total Sum: HERE you can add all of the Hx_total components of the magnetic field. 
Admittance_Closed = ((-2*E_0_slot2*(H6_total+ H5_total + H3_total + H2_total + H4_total) + (2*E_0_slot2*H1_total))*(2*E_0_slot1))*dy*dy_2*(-1/(V_1*V_2))*(1/(omega*u_0*1j));

end