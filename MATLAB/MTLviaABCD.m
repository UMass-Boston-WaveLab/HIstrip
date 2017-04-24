function [ Lmat ] = MTLviaABCD( h2, via_rad, f )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

L_via = via_calc(h2, via_rad);

omega=2*pi*f;
Lmat = [1 0 0 0; 
    0 1 0 0; 
    0 0 1 0; 
    0 (1/(j*omega*L_via)) 0 1];


end

