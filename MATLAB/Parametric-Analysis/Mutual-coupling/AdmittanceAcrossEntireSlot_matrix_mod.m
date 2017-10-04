function [Admittance] = AdmittanceAcrossEntireSlot_matrix_mod(slot_2_x_dist, slot_1_x_dist, slot_1_y_dist, slot_2_y_dist, slot_seperation, frequency)
%Admittance from Magnetic Field due to aperture 2 (slot 2) across slot 1's
%dimensions versus slot seperation with a max seperation provided by the
%user. 

%THIS ACCEPTS PHYSICAL DIMENSIONS AND CONVERTS TO ELECTRICAL DIMENSIONS

%Note. Initial seperation/displacement in the x-direction is NOT taken into
%account for this function. Only seperation in the y-direction and
%co-planar. 
 
%% General Constants
lambda = 3E8/frequency;
u_0 =  (1.25663706E-6);
omega = 2*pi*frequency;
k = 2*pi;

%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%% Slot Dimensions: 
%Slot 2 dimensions in terms of inputs (in wavelengths)
slot_2_length_x_f = (slot_2_x_dist)/lambda; 
slot_2_width_y_f = (slot_2_y_dist)/lambda; 

%Slot 1 dimensions in terms of inputs (in wavelengths)
slot_1_length_x_f = (slot_1_x_dist)/lambda; 
slot_1_width_y_f = (slot_1_y_dist)/lambda; 

%% Interval in terms of wavelength.

dy_segments_max_slot1 = slot_1_width_y_f/2;
dy_segments_max_slot2 = slot_2_width_y_f/2; 

dy = slot_1_width_y_f/floor(slot_1_width_y_f/dy_segments_max_slot1);
dy_2 = slot_2_width_y_f/floor(slot_2_width_y_f/dy_segments_max_slot2);

dx_dist = (1/20)*lambda;
Ndx1 = ceil(slot_1_x_dist/dx_dist);
Ndx2 = ceil(slot_2_x_dist/dx_dist);

dx = slot_1_length_x_f/Ndx1;%floor(slot_1_length_x_f/dx_max);
dx_2 = slot_2_length_x_f/Ndx2;%floor(slot_2_length_x_f/dx_max_2);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

%% Magnetic Current Stuff. Rearrange for different electric field disbrutions. Or use HfieldIntegrandEquation function
%normal = [0,0,1]; **This was changed from Voltage/dy instead of what we
%have now. 
E_0_slot2 = V_2/slot_2_y_dist;
E_0_slot1 = V_1/slot_1_y_dist;
% electric_field_2 = [0,E_0_slot2*sin(pi*x_prime/(slot_2_length_x_f)),0];
% electric_field_1 = [0, E_0_slot1*sin(pi*x/(slot_1_length_x_f)),0];
%magnetic_current = 2*cross(-normal,electric_field_1)

%% Admittance Function

%Slot seperation in wavelengths.
y_sep = (slot_seperation)/lambda;

%Build matrix to store H-field values across all of slot 2's dimensions----
%Each index will have H-field at one y-point distance,and one x-distances.
XX_2 = length(dx_2:dx_2:slot_2_length_x_f); YY_2 = length(dy_2:dy_2:slot_2_width_y_f);
H_field_at_2 = zeros(YY_2,XX_2);

%Delta x and y (increments) for the primed space
delta_x_prime = dx_2;
delta_y_prime = dy_2;

%Matrix to hold H-field values at one y distance. Each index will hold
%admittance values at different seperation distances (intervals of dy)
XX_1 = length(dx:dx:slot_1_length_x_f); YY_1 = length(dy:dy:slot_1_width_y_f);
Temp_Matrix = zeros(YY_1, XX_1);

%Formula/For-Loops/Evaluation of equation provided by Balanis--------------
%Nested for-loops to eval H-field(at slot 2) with different values for 
%r' coord system. Then evaluated across dimensions of entire slot 1


Y_i = 1; 
for y = y_sep:dy:y_sep+slot_1_width_y_f
    X_i = 1;
    for x = 0:dx:slot_1_length_x_f
        Y_prime_i = 1;
        for y_prime = dy_2:dy_2:slot_2_width_y_f
            X_prime_i = 1;
            for x_prime = 0:dx_2:slot_2_length_x_f                
               H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*sin((pi*x_prime)/slot_2_length_x_f)*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*sin((pi*x_prime)/slot_2_length_x_f))/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
               %H_field_at_2(Y_prime_i,X_prime_i) = - E_0_slot2*sin((pi*x_prime)/slot_2_length_x_f)*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*sin((pi*x_prime)/slot_2_length_x_f))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
                %H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (2*E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
                X_prime_i = X_prime_i + 1;
            end
            Y_prime_i = Y_prime_i + 1;            
        end
       Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1*sin(pi*x/(slot_1_length_x_f))))/(omega*u_0*1i));
       % Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((E_0_slot1*sin(pi*x/(slot_1_length_x_f))))/(omega*u_0*1j));
       % Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1))/(omega*u_0*1j));
       X_i = X_i + 1;
    end
    Y_prime_i = Y_prime_i + 1;
end
Admittance = sum(sum(Temp_Matrix*dy*dx)*(-1/(V_1*V_2)));

%% -------------------------------------------------------

%% Change Log
%- dx and dy terms now different from dx_prime and dy_prime
%- End of for loops no longer multipled by dx_prime and dy_prime both times
%  at sum. Now individually mutlplied by respective discrete terms. 
%- Electric field new defintion, no longer V/dy; 
%- Conversion between wavelengths. MAKe sure to change back.
end