function [ Admittance ] = MutualAdmittancevsSeperation( max_seperation_in_y, slot_2_x_distance, slot_2_y_distance )
%Plots mutual admittance vs slot seperation. Slot seperation is co-planar,
%and offset only in terms of y-direction. 

%Magnetic Field from Aperture 2 ( slot 2 )

%General Constants
frequency = 300E9;
lambda = 3E8/frequency;
u_0 =  1.25663706E-6;
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Slot dimensions
%slot_1_length_x_f = (slot_1_x_distance)*lambda; 
slot_2_length_x_f = (slot_2_x_distance)*lambda;
%slot_1_width_y_f = (slot_1_y_distance)*lambda; 
slot_2_width_y_f = (slot_2_y_distance)*lambda;

%----------Magnetic Current Stuff------------------------------------------
normal = [0,0,1];
E_0 = 1;
electric_field_1 = [0, -E_0, 0];
magnetic_current = cross(-normal,electric_field_1);

%Interval
dx = (1/10)*lambda; dy = (1/10)*lambda;

%Building the empty H-field Matrix in terms of the dimensions of slot 2----
X = length(0:dx:slot_2_length_x_f); Y = length(0:dy:slot_2_width_y_f);
H_slot_2 = zeros(X, Y);

%Observation Point distance from Origin
x = 0; yy = (max_seperation_in_y)*lambda;

%Matrix of different seperation_distances----------------------------------
Seperation_distance_matrix = zeros(1,length((0:dy:(max_seperation_in_y*lambda))));
indice_1 = 1;
for s = 0:dy:max_seperation_in_y*lambda
    Seperation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Empty Matrix of H-field to fill wrt to seperation distances---------------
H_field_WRT_distance = zeros(1, length(Seperation_distance_matrix));

index2 = 0;
index_test = 1;

%Nested for-loops to eval H-field with different values for r` coord.
%system. The first loop sets the y (non-primed) seperation w.r.t to origin
%point.Initiail distance in x-direction is 0, while the y-distance changes
%via the first for loop. 
for y = 0:dy:yy
    H_field_WRT_distance(1,index_test) = (sum(nansum(H_slot_2)))*(1/(1j*omega*u_0));
    index_test = index_test+ 1;    
    for bb = 0:dy:slot_2_width_y_f
        index2 = index2+ 1;
        index1 = 1;
        for aa = 0:dx:slot_2_length_x_f
            x_prime = aa;
            y_prime = bb;
            H_slot_2(index1,index2) = (exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((2*log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^3 - (log(abs(x + y))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 + (log(abs(x + y)^(x_prime + y_prime))*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)^2 - log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(1/(x_prime + y_prime) - 1)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 2)))/(x_prime + y_prime) + (log(abs(x + y))^2*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))*1000i)/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)) - (5298703515892057*exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i))/(536870912*pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*(log(abs(x + y))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (2*log(abs(x + y)^(x_prime + y_prime)))/((x_prime + y_prime)^3*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) + (log(abs(x + y)^(x_prime + y_prime))*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1))))/(x_prime + y_prime)^2 - (log(abs(x + y))^2*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(1/(x_prime + y_prime) + 1))/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 2)))/(x_prime + y_prime) + (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1))))/(2*pi) - exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)))*2000i + (2000000*pi*exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))^2)/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime));
            index1 = index1 + 1;
        end
    end
end

%Voltage at slot 1 and slot 2
V_1 = 1; V_2 = 1;

Admittance = H_field_WRT_distance*(1/(V_1*V_2));


%Plotting Stuff: H_field vs Seperation Distance----------------------------

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(H_field_WRT_distance));
Imaginary_matrix = zeros(1, length(H_field_WRT_distance));

for r = 1:length(H_field_WRT_distance)
    Real_matrix(1,r) = real(H_field_WRT_distance(r));
    Imaginary_matrix(1,r) = imag(H_field_WRT_distance(r));
end

plot(Seperation_distance_matrix,Real_matrix, Seperation_distance_matrix, Imaginary_matrix)
end
