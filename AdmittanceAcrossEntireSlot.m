function [ Y_12 ] = AdmittanceAcrossEntireSlot( slot_2_x_dist, slot_2_y_dist, slot_seperation_y, slot_seperation_x, slot_1_x_dist, slot_1_y_dist)
%Admittance from Hfield from Aperture 2 across slot 1's dimensions

%Inputs are slot 2s dimensions in x direction (wavelengths) , slot2's dimensions
% in y direction (wavelengths) , slot 1's seperation from slot 2 in x-direction
%(in wavlengths), slot 1's seperation from slot 2 in
%y-direction(wavelengths). Followed by the dimensions of slot 1
%(wavelengths)

%Note that integrant was dervived using symbolic partial deriviates. Then
%the equation that was spit out was placed here and symbolic variables
%(x,y,x_prime, y_prime) were assigned values. 

%General Constants
frequency = 300E9;
lambda = 3E8/frequency;
u_0 =  1.25663706E-6;
omega = 2*pi*frequency;
k = 2*pi/lambda;

%Interval
dx = (1/10)*lambda; dy = (1/10)*lambda;

%Slot dimensions
slot_2_length_x_f = (slot_2_x_dist)*lambda; slot_2_width_y_f = (slot_2_y_dist)*lambda;

%Observation Point distance from Origin
x_sep = (slot_seperation_x)*lambda; y_sep = (slot_seperation_y)*lambda;

%Slot 1 dimensions in terms of inputs (in wavelengths)
slot_1_length_x_f = (slot_1_x_dist)*lambda; slot_1_width_y_f = (slot_1_y_dist)*lambda;

%Build matrix to store H-field values across all of slot 1-----------------
XX = length(0:dx:slot_1_length_x_f); YY = length(0:dy:slot_1_width_y_f);
H_field_1 = zeros(XX,YY);

%Nested for-loops to eval H-field(at slot 2) with different values for 
%r` coord system. Then evaluated across dimensions of entire slot 1

index_slot_1_y = 0;
index1 = 0;
for cc = y_sep: dy: y_sep+slot_1_width_y_f       %these next 2 for-loops go from OP to dimensions of slot 1
    index_slot_1_y = index_slot_1_y + 1;    
    for dd = x_sep:dx:x_sep+slot_1_length_x_f
        index1 = index1 + 1;
        y = cc;
        x = dd;
        for bb = 0:dy:slot_2_width_y_f %H-field in primed system is evaluated here.
            for aa = 0:dx:slot_2_length_x_f
                x_prime = aa;
                y_prime = bb;
                H_field_1(index1,index_slot_1_y) = (exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((2*log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^3 - (log(abs(x + y))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 + (log(abs(x + y)^(x_prime + y_prime))*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime)^2 - log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(1/(x_prime + y_prime) - 1)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 2)))/(x_prime + y_prime) + (log(abs(x + y))^2*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))*1000i)/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)) - (5298703515892057*exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i))/(536870912*pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*(log(abs(x + y))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (2*log(abs(x + y)^(x_prime + y_prime)))/((x_prime + y_prime)^3*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) + (log(abs(x + y)^(x_prime + y_prime))*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1))))/(x_prime + y_prime)^2 - (log(abs(x + y))^2*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(1/(x_prime + y_prime) + 1))/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 2)))/(x_prime + y_prime) + (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1))))/(2*pi) - exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))*(log(abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)^2*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))) - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime))/((x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) + 1)))*2000i + (2000000*pi*exp(-pi*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime))*2000i)*((log(abs(x + y)^(x_prime + y_prime))*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime)))/(x_prime + y_prime)^2 - (log(abs(x + y))*abs(x + y)^(x_prime + y_prime)*(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime) - 1))/(x_prime + y_prime))^2)/(abs(x + y)^(x_prime + y_prime))^(1/(x_prime + y_prime));
            end
        end
    end
end


%Inital Voltages at slot 1 and slot 2
V_1 = 1;
V_2 = 1; 

%Final admittance output
Y_12 = (1/(V_1*V_2))*(sum(nansum(H_field_1)))*(1/(1j*omega*u_0));

end

