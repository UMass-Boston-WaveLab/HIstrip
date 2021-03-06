function Plotting_VandeCapelle( max_seperation, freq)
%Plot of Van de Capelle Code for Mutual Admittance

lambda = 3E8/freq;
dy = (1/50)*lambda;
Max_sep = max_seperation*lambda;

%Constants that are untouched
w_sub = 1.12;
h_sub = 0.04;
L_sub = 1.12;
eps1 = 1;
eps2 = 2.2;


%Matrix of different seperation_distances----------------------------------
%Seperation Matrix's first data point is dy, and last point is not 0
Separation_distance_matrix = zeros(1,length(dy:dy:Max_sep));
indice_1 = 1;
for s = 2*dy:dy:Max_sep+dy
    Separation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Matrix to fill with mutual admittance values------------------------------
Admittance_Matrix = zeros(1, length(Separation_distance_matrix));
index = 1;
for L_ant1 = 2*dy:dy:Max_sep+dy
    Admittance_Matrix(1,index) = HISantYmat_SS(.333, dy, L_ant1,eps1, w_sub, h_sub, L_sub,eps2, freq);
    index = index + 1;
end

assignin('base', 'Admittance', Admittance_Matrix);

%--------------------------Plot-Stuff--------------------------------------

%Take: real and imaginary part of H_field sum and place in their own matrix
Real_matrix = zeros(1, length(Admittance_Matrix));
%Imaginary_matrix = zeros(1, length(Admittance_Matrix));

for r = 1:length(Admittance_Matrix)
    Real_matrix(1,r) = real(Admittance_Matrix(r));
    %Imaginary_matrix(1,r) = imag(Admittance_Matrix(r));
end

plot(Separation_distance_matrix,Real_matrix)%, Separation_distance_matrix, Imaginary_matrix)
legend('Real Part')%, 'Imaginary Part')
xlabel('Slot Separation')
ylabel('Mutual Admittance')
