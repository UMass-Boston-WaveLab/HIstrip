function plot_matrix_admittance_O(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, frequency) 
%This function ONLY plots the mutual admittance WRT to slot separation for
%different orders of the closed expression. The user must define the
%various orders they wish to use in the Order_matrix, and uses
%Admittance_Order_only function. 


lambda = 3E8/frequency;

max_seperation = 1.3*lambda; 
dy = slot_1_2_y_dist/floor(slot_1_2_y_dist/(slot_1_2_y_dist/2));
%This is basically the closest we can get without the two slots overlapping
initial_starting = 4*dy; %previousl 2*dy

%Matrix of different seperation_distances. Used ONLY for plotting----------
%Seperation Matrix's first data point is 2*dy

Seperation_distance_matrix = zeros(1,length(initial_starting:dy:max_seperation));
indice_1 = 1;
for s = initial_starting:dy:max_seperation
    Seperation_distance_matrix(indice_1) = s;
    indice_1 = indice_1 + 1;
end

%Place the orders of the expression you wish to use here.
Order_matrix = [4,8,12];

Real_WRT_orders = zeros(length(Order_matrix), length(Seperation_distance_matrix));
Imag_WRT_orders = zeros(length(Order_matrix), length(Seperation_distance_matrix));


index_order = 1;
for ii = 1:length(Order_matrix)
    index_seperation = 1;
    for slot_seperation = initial_starting:dy:max_seperation
        Admittance_WRT_Orders = Admittance_Order_only(slot_2_x_dist, slot_1_x_dist, slot_1_2_y_dist, slot_seperation,frequency, Order_matrix(ii));
        Real_WRT_orders(index_order,index_seperation) = real(Admittance_WRT_Orders);
        Imag_WRT_orders(index_order,index_seperation) = imag(Admittance_WRT_Orders);
        index_seperation = index_seperation + 1;
    end
    index_order = index_order + 1;
end

assignin('base', 'real_closed', Real_WRT_orders);
assignin('base', 'imag_closed', Imag_WRT_orders);

hold on
for i= 1:length(Order_matrix)
    %plot(Seperation_distance_matrix, Real_WRT_orders(i,:), '--')%, 'Color', colorVec(i,:))
    plot(Seperation_distance_matrix, Imag_WRT_orders(i,:), '-o')%,'Color', colorVec(i,:))
    legend(strcat(num2str(Order_matrix(1)),'th Order'), strcat(num2str(Order_matrix(2)),'th Order'), strcat(num2str(Order_matrix(3)),'th Order'))%, strcat(num2str(Order_matrix(4)),'th Order'))%, num2str(Order_matrix(5)))%, num2str(Order_matrix(6)), num2str(Order_matrix(7)))%,num2str(Order_matrix(8))); 

end
hold off; 

xlabel('Slot Seperation (Wavelengths)')
ylabel('Admittance(S)')
%title('Expression #1 (Real)')

end