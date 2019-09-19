function [Ym] = approxMutualY(L1, L2, s1, s2, d, gnd, f)
%computes approximate mutual admittance between coaxial infinitesimal
%magnetic dipoles whose center-to-center separation is d.
% the lengths of the slots are L1, L2
% the slot widths are s1, s2
% the gnd flag indicates whether the image effect of an infinite PEC
% ground place should be included
eta=377;
c=3e8;
beta = 2*pi*f/c;

if d<(L1+L2)/2
    warn('Warning: You are trying to compute the mutual admittance between two slots that physically overlap. I do not think this is physically realizable.\n')
end

if gnd
    Ym = (-4*L1*L2/(2*pi*s1*s2*d^2)) * (1+1/(j*beta*d)) * exp(-j*beta*d);
    %factor of 4 is because of the image effect of a PEC ground plane -- is
    %this correct? should it only be a factor of 2?
else
    Ym = (-L1*L2/(2*pi*s1*s2*d^2)) * (1+1/(j*beta*d)) * exp(-j*beta*d);
    %this one has no factor of 4 bc assumed free space
end


