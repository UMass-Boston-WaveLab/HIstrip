slot_2_x_dist = .33;
slot_1_x_dist = .33;
slot_1_2_y_dist = (1/10);
frequency = 300E6;
lambda = 3E8/frequency;

max_seperation = 2*lambda; 
dy = slot_1_2_y_dist/4;
initial_starting = slot_1_2_y_dist+dy;

%Matrix of different seperation_distances. Used ONLY for plotting----------
%Seperation Matrix's first data point is 2*dy
Seperation_distance_matrix = zeros(1,length(initial_starting:dy:max_seperation));
indice_1 = 1;
for s = initial_starting:dy:max_seperation
    Seperation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Matrix of mutual admittance to fill w/ respect to seperation distances----
Admittance_WRT_distance = zeros(1, length(Seperation_distance_matrix));

index = 1;
for slot_seperation = initial_starting:dy:max_seperation
    Admittance_WRT_distance(1,index) = AdmittanceAcrossEntireSlot_matrix(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation, frequency);
    index = index + 1;
end

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(Admittance_WRT_distance));
%Imaginary_matrix = zeros(1, length(Admittance_WRT_distance));

for r = 1:length(Admittance_WRT_distance)
    Real_matrix(1,r) = real(Admittance_WRT_distance(r));
    %Imaginary_matrix(1,r) = imag(Admittance_WRT_distance(r));
end

plot(Seperation_distance_matrix, Real_matrix)
xlabel('Slot Seperation (wavelengths)')
ylabel('Admittance')
title('Mutual Coupling for 1/3 Wavelength slots; Frequency = 300E6 Hz; E-Field Distribution = Sinusoidal')