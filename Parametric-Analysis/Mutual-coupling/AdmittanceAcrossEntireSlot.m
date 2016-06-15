function AdmittanceAcrossEntireSlot( slot_2_x_dist, slot_1_x_dist, max_seperation_in_y)
%Admittance from Magnetic Field due to aperture 2 (slot 2) across slot 1's
%dimensions versus slot seperation with a max seperation provided by the
%user. 

%Note. Initial seperation/displacement in the x-direction is NOT taken into
%account for this function. Only seperation in the y-direction and
%co-planar. 

%General Constants
frequency = 6E9;
lambda = 3E8/frequency;
u_0 =  1.25663706E-6;
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%Interval in terms of wavelength. 
dx = (1/10)*lambda; dy = (1/10)*lambda;

%Slot 2 dimensions in terms of inputs (in wavelengths)
slot_2_length_x_f = (slot_2_x_dist)*lambda; slot_2_width_y_f = (dy);

%dy = width due to approximation: E-field being constant along short width. 

%Slot 1 dimensions in terms of inputs (in wavelengths)
slot_1_length_x_f = (slot_1_x_dist)*lambda; slot_1_width_y_f = (dy);

%Maximum slot seperation. Requires user input
y_sep = (max_seperation_in_y)*lambda;

%Build matrix to store H-field values across all of slot 1's dimensions----
% YY unecessary b/c H-field values don't change across width. Each index
% will have H-field at one y-point distance,and different x-distances.
XX = length(dx:dx:slot_1_length_x_f); %YY = length(0:dy:slot_1_width_y_f);
H_field_1 = zeros(1,XX);

%Matrix of different seperation_distances----------------------------------
%Seperation Matrix's first data point is dy, and last point is not 0
Seperation_distance_matrix = zeros(1,length(dy:dy:y_sep));
indice_1 = 1;
for s = dy:dy:y_sep
    Seperation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Matrix of mutual admittance to fill w/ respect to seperation distances----
Admittance_WRT_distance = zeros(1, length(Seperation_distance_matrix));

%Matrix to hold H-field values at one y distance. Each index will hold
%admittance values of different seperation distances (intervals of dy)
Temp_Matrix = zeros(1, XX);

%Formula/For-Loops/Evaluation of equation provided by Balanis--------------
%Nested for-loops to eval H-field(at slot 2) with different values for 
%r' coord system. Then evaluated across dimensions of entire slot 1

A_index = 1;
for y = 2*dy:dy:y_sep+dy
    T_index = 1;
    for x = dx:dx:slot_1_length_x_f
        index1 = 1;
        for x_prime = dx:dx:slot_2_length_x_f
            y_prime = dy;         
            H_field_1(1,index1) =  (exp(-k*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*1i)*(k^2*y^4 + k^2*y_prime^4 - 4*x*x_prime + 2*y*y_prime - k*((x - x_prime)^2 + (y - y_prime)^2)^(3/2)*1i + 2*x^2 + 2*x_prime^2 - y^2 - y_prime^2 - 4*k^2*y*y_prime^3 - 4*k^2*y^3*y_prime + k*x^2*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*3i + k*x_prime^2*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*3i + k^2*x^2*y^2 + k^2*x^2*y_prime^2 + k^2*x_prime^2*y^2 + k^2*x_prime^2*y_prime^2 + 6*k^2*y^2*y_prime^2 - k*x*x_prime*((x - x_prime)^2 + (y - y_prime)^2)^(1/2)*6i - 2*k^2*x*x_prime*y^2 - 2*k^2*x*x_prime*y_prime^2 - 2*k^2*x^2*y*y_prime - 2*k^2*x_prime^2*y*y_prime + 4*k^2*x*x_prime*y*y_prime))/(4*pi*((x - x_prime)^2 + (y - y_prime)^2)^(5/2));
            index1 = index1 + 1;
        end
        Temp_Matrix(1, T_index) = sum(sum(H_field_1));
        T_index = T_index + 1;
    end
    Admittance_WRT_distance(1,A_index) = sum(sum((-1)*Temp_Matrix*(1/(1i*omega*u_0*V_1*V_2))));
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

plot(Seperation_distance_matrix,Real_matrix, Seperation_distance_matrix, Imaginary_matrix)
legend('Real Part', 'Imaginary Part')
xlabel('Slot Separation')
ylabel('Mutual Admittance')

end

