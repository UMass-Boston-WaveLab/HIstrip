function [Admittance_Closed] = Admittance_Order_only(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation,frequency, order)
%This function is used to calculate the mutual admittance using various
%parts of the closed form expression. i.e. only certain expressions (1-6)
%can be used and calculated for various orders. 

%Used only with plot_matrix_admttance_O.m function
 
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
%normal = [0,0,1];
E_0_slot2 = V_2/(2*dy);
E_0_slot1 = V_1/(2*dy);

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

%% Closed Form Expression Stuff

L1 = slot_1_length_x_f;
L2 = slot_2_length_x_f;
d = y_sep;

%% Expression #6 
% H6_total = H_6_xOrder(L2, L1, d, frequency, order_6);

%Expression #4
H4_total = H_4_xOrder(L2, L1, d, frequency, order);

%Expression #3
%H3_total = H_3_xOrder(L2, L1, d, frequency, order);

% %% Expression #5
% order_5 = 14;
% H5_total = H_5_xOrder(L2, L1, d, frequency, order);

% %Expression #2
% H2_total = H_2_xOrder(L2, L1, d, frequency, order);

% %Expression #1 
 %H1_total = H_1_xOrder(L2, L1, d, frequency, order);
 
%% Total Sum: THe user must include the Hx_total value in the they wish to use/include in the final value for the admittance. 

Admittance_Closed = ((-2*E_0_slot2*(H4_total) + (2*E_0_slot2*0))*2*E_0_slot1)*dy*dy_2*(-1/(V_1*V_2))*(1/(omega*u_0*1j));
%width of the slots 
end