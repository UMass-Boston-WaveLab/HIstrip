function plot_matrix_admittance(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, frequency) 
%The following function plots the mutual addmittance from both the closed
%form expression, and the numerical calculator

lambda = 3E8/frequency;

%Here you can change the value for the slot separation 
max_seperation = 1.5*lambda; 
dy = slot_1_2_y_dist/floor(slot_1_2_y_dist/(slot_1_2_y_dist/2));
%This is basically the closest we can get without the two slots overlapping
initial_starting =  4*dy; % (or 2-slot widths, originally 2/10);

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

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(Admittance_WRT_distance));
Imaginary_matrix = zeros(1, length(Admittance_WRT_distance));

%Closed-Form
Real_closed = zeros(1, length(Admittance_WRT_distance));
Imag_closed = zeros(1, length(Admittance_WRT_distance));

index = 1;
r = 1; 
for slot_seperation = initial_starting:dy:max_seperation
    [exact, closed] = Admittance_Test(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation,frequency);
    Real_matrix(1,r) = real(exact);    
    Imaginary_matrix(1,r) = imag(exact);
    %
    Real_closed(1,r) = real(closed);
    Imag_closed(1,r) = imag(closed);
    %
    r = r + 1;
    index = index + 1;
end

%This just assigns the values from the previous calculations to a workspace
assignin('base', 'real_matlab', Real_matrix);
assignin('base', 'imag_matlab', Imaginary_matrix);
assignin('base', 'sep_matlab', Seperation_distance_matrix);
%
assignin('base', 'real_closed', Real_closed);
assignin('base', 'imag_closed', Imag_closed);
%

%% Plotting Coode: Uncomment and comment as needed

%plot(Seperation_distance_matrix, Real_matrix, 'x', Seperation_distance_matrix, Imaginary_matrix)
plot( Seperation_distance_matrix, Real_closed, 'x', Seperation_distance_matrix, Imag_closed)
%plot(Seperation_distance_matrix, Real_matrix, 'x', Seperation_distance_matrix, Imaginary_matrix, Seperation_distance_matrix, Real_closed, 'o', Seperation_distance_matrix, Imag_closed)
xlabel('Slot Seperation (Wavelengths)')
ylabel('Admittance (S) ')
%legend('Real-Numerical', 'Imaginary-Numerical', 'Real-Closed Form', 'Imaginary-Closed Form')
legend('Real-closed', 'Imaginary-closed')%_, 'Real', 'Imaginary',
%title('Mutual Admittance for Two Radiating Slots')
end