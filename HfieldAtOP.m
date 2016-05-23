function [ H_at_slot_2] = HfieldAtOP( slot_2_x_dist, slot_2_y_dist, slot_seperation_y, slot_seperation_x)
%Magnetic Field from Aperture 2 at ONE Observation Point

%Inputs are slots dimensions in x direction (wavelengths) , slot's dimensions
% in y direction (wavelengths) , slot 1's seperation from slot 2 in x-direction
%(in wavlengths), slot 1's seperation from slot 2 in
%y-direction(wavelengths). 

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

%Building the empty H-field Matrix(s) in terms of the dimensions of slot 2-
X = length(0:dx:slot_2_length_x_f); Y = length(0:dy:slot_2_width_y_f);
H_part1 = zeros(X, Y);
H_part2 = zeros(X,Y);

%Observation Point distance from Origin
x = (slot_seperation_x)*lambda; y = (slot_seperation_y)*lambda;

%Nested for-loops to eval H-field(at slot 2) with different values for 
%r` coord system. Broken up into 2 b/c equation (integral) consists of the
%sum of two functions. 
index2 = 0;
for bb = 0:dy:slot_2_width_y_f
    index2 = index2+ 1;
    index1 = 1;
    for aa = 0:dx:slot_2_length_x_f
        x_prime = aa;
        y_prime = bb;
        H_part1(index1,index2) = (sign(x - x_prime)^2*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i)*500i)/(abs(x - x_prime)^2 + abs(y - y_prime)^2) - (abs(x - x_prime)^2*sign(x - x_prime)^2*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i)*1500i)/(abs(x - x_prime)^2 + abs(y - y_prime)^2)^2 + (abs(x - x_prime)*dirac(x - x_prime)*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i)*1000i)/(abs(x - x_prime)^2 + abs(y - y_prime)^2) + (sign(x - x_prime)^2*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(4*pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(3/2)) - (3*abs(x - x_prime)^2*sign(x - x_prime)^2*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(4*pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(5/2)) + (abs(x - x_prime)*dirac(x - x_prime)*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(2*pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(3/2)) + (1000000*pi*abs(x - x_prime)^2*sign(x - x_prime)^2*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(3/2) - (abs(x - x_prime)*abs(y - y_prime)*sign(x - x_prime)*sign(y - y_prime)*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i)*1500i)/(abs(x - x_prime)^2 + abs(y - y_prime)^2)^2 + (1000000*pi*abs(x - x_prime)*abs(y - y_prime)*sign(x - x_prime)*sign(y - y_prime)*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(3/2) - (3*abs(x - x_prime)*abs(y - y_prime)*sign(x - x_prime)*sign(y - y_prime)*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(4*pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(5/2));
        H_part2(index1,index2) = -(5298703515892057*exp(-pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2)*2000i))/(536870912*pi*(abs(x - x_prime)^2 + abs(y - y_prime)^2)^(1/2));
        index1 = index1 + 1;
    end
end

H_at_slot_2 = (sum(nansum(H_part1)) + sum(sum(H_part2)))*(1/(1j*omega*u_0));

end