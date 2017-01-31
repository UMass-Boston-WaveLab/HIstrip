function [Admittance] = AdmittanceAcrossEntireSlot_matrix(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation,frequency)
%Admittance from Magnetic Field due to aperture 2 (slot 2) across slot 1's
%dimensions versus slot seperation with a max seperation provided by the
%user. 

%Note. Initial seperation/displacement in the x-direction is NOT taken into
%account for this function. Only seperation in the y-direction and
%co-planar. 
 
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
E_0_slot2 = V_2/dy;
E_0_slot1 = V_1/dy;
% electric_field_2 = [0,E_0_slot2*sin(pi*x_prime/(slot_2_length_x_f)),0];
% electric_field_1 = [0, E_0_slot1*sin(pi*x/(slot_1_length_x_f)),0];
%magnetic_current = 2*cross(-normal,electric_field_1)

%% Admittance Function

%Slot seperation in wavelengths.KEEEPPP
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

%Formula/For-Loops/Evaluation of equation provided by Balanis--------------
%Nested for-loops to eval H-field(at slot 2) with different values for 
%r' coord system. Then evaluated across dimensions of entire slot 1
%  for y = y_sep  %Seperation distance values. 2dy used b/c 1dy causes weird graphing issues. 
%      T_index = 1;
%      for x = dx:dx:slot_1_length_x_f        %Non-Primed values
%          index1 = 1;
%          for x_prime = dx:dx:slot_2_length_x_f          %Primed space
%              y_prime = delta_y_prime;         
%              H_field_1(1,index1) = - 40*sin((100*pi*x_prime)/33)*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (10*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*sin((100*pi*x_prime)/33))/(pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
%                                  %- (10*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*10i)/(pi*((x - x_prime)^2 + (y - y_prime)^2)) + (15*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (10*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)) - (5*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*15i)/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^2);
%               index1 = index1 + 1; 
%          end
%          Temp_Matrix(1, T_index) = sum(sum(H_field_1*delta_x_prime*delta_y_prime)*((40*sin((100*pi*x)/33))/(omega*u_0*1j)));
%          T_index = T_index + 1;
%      end
%      Admittance_WRT_distance(1,1) = sum(sum(Temp_Matrix*delta_x_prime*delta_y_prime)*(-1/(V_1*V_2))); 
%  end

%>>>>>>
% A = 0:dy_2:slot_2_width_y_f;
% B = y_sep:dy:y_sep+slot_1_width_y_f;
% y_sep

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
Admittance = sum(sum(Temp_Matrix*delta_x_prime*delta_y_prime)*(-1/(V_1*V_2)));

%% -------------------------------------------------------
% max_seperation = 2*lambda;
% initial_starting = dy;
% 
% Seperation_distance_matrix = zeros(1,length(initial_starting:dy:max_seperation));
% indice_1 = 1;
% for s = initial_starting:dy:max_seperation
%     Seperation_distance_matrix(indice_1) = s;
%     indice_1 = indice_1 + 1;
% end

% Matrix of mutual admittance to fill w/ respect to seperation distances----
% Admittance_WRT_distance = zeros(1, length(Seperation_distance_matrix));
% 
% a_index = 1;
% for distance = dy:dy:max_seperation
%     Y_i = 1;
%     for y = distance:dy:distance+slot_1_width_y_f
%         X_i = 1;
%         for x = dx:dx:slot_1_length_x_f
%             Y_prime_i = 1;
%             for y_prime = dy_2:dy_2:slot_2_width_y_f
%                 X_prime_i = 1;
%                 for x_prime = dx_2:dx_2:slot_2_length_x_f
%                     H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*sin(pi*x_prime/(slot_2_width_y_f))*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (2*E_0_slot2*sin(pi*x_prime/(slot_2_width_y_f))*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(2*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
%                     H_field_at_2(Y_prime_i,X_prime_i) = - 2*E_0_slot2*(exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) - (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) + (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(2*x - 2*x_prime)^2*3i)/(16*pi*((x - x_prime)^2 + (y - y_prime)^2)^2)) + (2*E_0_slot2*k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2));
%                     X_prime_i = X_prime_i + 1;
%                 end
%                 Y_prime_i = Y_prime_i + 1;
%             end
%             Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1*sin(pi*x/(slot_1_width_y_f))))/(omega*u_0*1j));
%             Temp_Matrix(Y_i, X_i) = sum(sum(H_field_at_2*delta_x_prime*delta_y_prime)*((2*E_0_slot1))/(omega*u_0*1j));
%             X_i = X_i + 1;
%         end
%         Y_prime_i = Y_prime_i + 1;
%     end
%     Admittance_WRT_distance(1,a_index) = sum(sum(Temp_Matrix*delta_x_prime*delta_y_prime)*(-1/(V_1*V_2)));
%     a_index = a_index + 1;
% end

%%
% %% ----------------------Plot-Stuff--------------------------------------
% 
% %Take: real and imaginary part of H_field sum and place in their own matrix
% Real_matrix = zeros(1, length(Admittance_WRT_distance));
% Imaginary_matrix = zeros(1, length(Admittance_WRT_distance));
% 
% for r = 1:length(Admittance_WRT_distance)
%     Real_matrix(1,r) = real(Admittance_WRT_distance(r));
%     Imaginary_matrix(1,r) = imag(Admittance_WRT_distance(r));
% end
% 
% % %% KC's Code
% % lam = 3e8/frequency;
% % s = lam/20;
% % l = slot_2_x_dist;
% % maxd = max_seperation_in_y;
% % mind = s*lam;
% % 
% % d = (mind:(dy/lam):maxd)*lam;
% % for ii = 1:length(d)
% %     VdCYm(ii) = VdCmutualY(l*lam, s*lam, d(ii), frequency);
% % end
% % 
% % 
% %  assignin('base', 'VdCYm', VdCYm)
%   assignin('base', 'MyCode_sin', Real_matrix)
%   assignin('base', 'Seperation', Seperation_distance_matrix)
% 
% 
% 
% 
% %% Both Plots
% plot(Seperation_distance_matrix, Real_matrix)%, Seperation_distance_matrix, MyCode_sin);
% %Seperation_distance_matrix, Balanis2(slot_2_x_dist, slot_1_x_dist, max_seperation_in_y, frequency))%
% legend('Constant E')%, 'Sinusoidal')
% xlabel('Slot Separation (Wavelengths)')
% ylabel('Mutual Admittance')
% title('1/3-wavelength slots @ 300E6; dy = 1/20')
% % hold on
% %  %% Net stuff
% % for ii = 1:length(Real_matrix)
% %     Net(ii) = Balanis(ii) - Real_matrix(ii);
% % end
% % assignin('base', 'Net', Net)

end