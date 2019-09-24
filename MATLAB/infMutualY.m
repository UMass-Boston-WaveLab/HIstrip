function [Ym] = infMutualY(L1, L2, d, theta, gnd, f)
%computes approximate mutual admittance between parallel non-coaxial infinitesimal
%magnetic dipoles whose center-to-center separation is d.
% the lengths of the slots are L1, L2
% the slot widths are s1, s2
% the gnd flag indicates whether the image effect of an infinite PEC
% ground plane should be included
% theta is the angle that the vector connecting the two slot midpoints
% makes with the slot axis
% WLOG we assume the magnetic current is z directed, so we only include Y
% terms associated with z directed H fields.
eta=377;
c=3e8;
beta = 2*pi*f/c;


%issue: how much does the value of theta actually change over this
%integral? it's not nothing

if gnd
    Ym = (-2*L1*L2*cos(theta)^2/(pi*d^2)) * (1+1/(j*beta*d)) * exp(-j*beta*d)+...
        (j*beta*L1*L2*sin(theta)^2/(pi*d)) * (1+1/(j*beta*d)-1/(beta^2*d^2)) * exp(-j*beta*d);
else
    Ym =  (-2*L1*L2*cos(theta)^2/(4*pi*d^2)) * (1+1/(j*beta*d)) * exp(-j*beta*d)+...
        (j*beta*L1*L2*sin(theta)^2/(4*pi*d)) * (1+1/(j*beta*d)-1/(beta^2*d^2)) * exp(-j*beta*d);
    %this one has no factor of 4 bc assumed free space
end


