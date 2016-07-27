function AdmittanceAcrossEntireSlot_SS( slot_2_x_dist, slot_1_x_dist, max_seperation_in_y, frequency)
%Admittance from Magnetic Field due to aperture 2 (slot 2) across slot 1's
%dimensions versus slot seperation with a max seperation provided by the
%user. 

%Note. Initial seperation/displacement in the x-direction is NOT taken into
%account for this function. Only seperation in the y-direction and
%co-planar. 

%General Constants
lambda = 3E8/frequency;
u_0 =  (1.25663706E-6);
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%Interval in terms of wavelength. 
dx = (1/50)*lambda;
dy = (1/50)*lambda;
dx_prime = dx; dy_prime = dy;

%Slot 2 dimensions in terms of inputs (in wavelengths)
slot_2_length_x_f = (slot_2_x_dist)*lambda; slot_2_width_y_f = (dy); %width is dy due to approxmimation of E-field being constant

%Slot 1 dimensions in terms of inputs (in wavelengths)
slot_1_length_x_f = (slot_1_x_dist)*lambda; slot_1_width_y_f = (dy);

%Maximum slot seperation. Requires user input
y_sep = (max_seperation_in_y)*lambda;

%Build matrix to store H-field values across all of slot 1's dimensions----
% YY unecessary b/c H-field values don't change across width. Each index
% will have H-field at one y-point distance,and different x-distances.
XX = length(dx:dx:slot_1_length_x_f); %YY = length(0:dy:slot_1_width_y_f);
H_field_1 = zeros(1,XX);

%Test
delta_x_prime = slot_2_length_x_f/(length(dx:dx:slot_2_length_x_f));
delta_y_prime = dy;

delta_x1_prime = slot_1_length_x_f/XX;
delta_y1_prime = dy;

%Matrix of different seperation_distances. Used ONLY for plotting----------
%Seperation Matrix's first data point is 2*dy
Seperation_distance_matrix = zeros(1,length(dy:dy:y_sep));
indice_1 = 1;
for s = 2*dy:dy:y_sep+dy
    Seperation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Matrix of mutual admittance to fill w/ respect to seperation distances----
Admittance_WRT_distance = zeros(1, length(Seperation_distance_matrix));

%Matrix to hold H-field values at one y distance. Each index will hold
%admittance values at different seperation distances (intervals of dy)
Temp_Matrix = zeros(1, XX);

%Formula/For-Loops/Evaluation of equation provided by Balanis--------------
%Nested for-loops to eval H-field(at slot 2) with different values for 
%r' coord system. Then evaluated across dimensions of entire slot 1
A_index = 1;

for y = 2*dy:dy:y_sep+dy  %Seperation distance values. 2dy used b/c 1dy causes weird graphing issues. 
    T_index = 1;
    for x = dx:dx:slot_1_length_x_f        %Non-Primed values
        index1 = 1;
        for x_prime = dx:dx:slot_2_length_x_f          %Primed space
            y_prime = delta_y_prime;         
            H_field_1(1,index1) = -exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) - (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*1i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)) + (3*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(x - x_prime)^2)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2)) - (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)) - (k^2*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(x - x_prime)^2)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)) + (k*exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(x - x_prime)^2*3i)/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^2);
            index1 = index1 + 1;
        end
        Temp_Matrix(1, T_index) = sum(sum(H_field_1*delta_x_prime)*(1/(omega*u_0*1j)));
        T_index = T_index + 1;
    end
    Admittance_WRT_distance(1,A_index) = sum(sum(Temp_Matrix*delta_x_prime)*(1/(V_1*V_2))); %Magnetic current from slot 1 would be dotted here as well, thus providing another negative sign
    A_index = A_index + 1;
end

%--------------------------Plot-Stuff--------------------------------------

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(Admittance_WRT_distance));
Imaginary_matrix = zeros(1, length(Admittance_WRT_distance));

for r = 1:length(Admittance_WRT_distance)
    Real_matrix(1,r) = real(Admittance_WRT_distance(r));
    Imaginary_matrix(1,r) = imag(Admittance_WRT_distance(r));
end

plot(Seperation_distance_matrix, Real_matrix)%, Seperation_distance_matrix, Imaginary_matrix)
legend('Real Part')%, Imaginary Part')
xlabel('Slot Separation (Wavelengths)')
ylabel('Mutual Admittance')
title('MyCode: 1/3-wavelength slots @ 300E6; dy = 1/50-lambda')

end

