function [ Rrad ] = uniformslotR( a, b)
%Calculates radiation resistance of a uniformly illuminated slot (like at
%the edge of a patch antenna) with extent a in the x direction and b in the
%y direction. E is assumed to point in the x direction.  (For sane antenna 
%setups, it makes sense if a is smaller than b.)
%This program uses the far-field vector potential technique in Balanis'
%Advanced Engineering Electromagnetics, Chapter 6.
%Specify a and b in wavelengths.

%assume the slot is in an infinite ground plane, so theta only goes from 0
%to pi/2
dtheta=pi/200;
dphi=pi/180;
theta = 0:dtheta:pi/2;
phi = 0:dphi:2*pi;
eta = 377;

Prad = trapz(theta, trapz(phi.', ((a*b)^2/(4*377)) * (sinc(a*kron(sin(theta),cos(phi.'))).^2) .*...
    (sinc(b*kron(sin(theta),sin(phi.'))).^2) .* (kron(ones(size(theta)),cos(phi.')).^2 +...
    kron(cos(theta),sin(phi.')).^2) .* kron(sin(theta),ones(size(phi.')))));

%Ex = -V/a, My = -2*Ex -> V = a*My/2


Rrad=(a^2/4)/Prad;
%something seems wrong with this, because now Rrad depends on length but 
% not width of slot.  Is it the open-end capacitance that makes it depend
% on height again?  It must be - my math is definitely right.

end

