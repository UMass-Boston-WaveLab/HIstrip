% function plot_matrix_admittance_vFrequency(slot_2_x_dist, slot_1_x_dist, slot_1_y_dist, slot_2_y_dist, slot_seperation, frequency_i, frequency_f) 


slot_2_x_dist=0.5;
slot_1_x_dist=.5;
slot_1_y_dist=0.01;
slot_2_y_dist=0.01;
slot_seperation=.3;
frequency_i=1e8;
frequency_f=6e8;












c = 3E8;
df = 50E6;
frequency_matrix = zeros(1, length(frequency_i:df:frequency_f));
indice_1 = 1; 
for frequency = frequency_i:df:frequency_f
    frequency_matrix(indice_1) = frequency;
    indice_1 = indice_1 + 1;
end


%Matrix of mutual admittance to fill w/ respect to seperation distances----
Admittance_WRT_frequency = zeros(1, length(frequency_matrix));

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(Admittance_WRT_frequency));
Imaginary_matrix = zeros(1, length(Admittance_WRT_frequency));

index = 1;
r = 1; 
for frequency_int = frequency_i:df:frequency_f
    Admittance_WRT_frequency(1,index) = AdmittanceAcrossEntireSlot_matrix_mod(slot_2_x_dist, slot_1_x_dist, slot_1_y_dist, slot_2_y_dist, slot_seperation, frequency_int);
    %Admittance_WRT_frequency(1,index) = AdmittanceAcrossEntireSlot_matrix(slot_2_x_dist/(c/frequency_int), slot_1_x_dist/(c/frequency_int), slot_1_y_dist/(c/frequency_int), slot_2_y_dist/(c/frequency_int), slot_seperation/(c/frequency_int), frequency_int);
    Real_matrix(1,r) = real(Admittance_WRT_frequency(1, index));
    Imaginary_matrix(1,r) = imag(Admittance_WRT_frequency(1, index));
    r = r + 1;
    index = index + 1;
end


assignin('base', 'real_matlab', Real_matrix);
assignin('base', 'imag_matlab', Imaginary_matrix);
assignin('base', 'freq_matlab', frequency_matrix);

subplot(2,1,1)
plot(frequency_matrix, Real_matrix)
xlabel('Frequency (Ghz)')
ylabel('Admittance(Real)')
legend('Real')
title(' Admittance(Real) vs Frequency')

subplot(2,1,2)
plot(frequency_matrix, Imaginary_matrix )
xlabel('Frequency (Ghz)')
ylabel('Admittance(Im)')
legend('Imaginary')
title(' Admittance(Imag) vs Frequency')


% end
