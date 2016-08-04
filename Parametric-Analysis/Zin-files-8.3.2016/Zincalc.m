function [ Zin ] = Zincalc( Z0,ZL,arg )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Zin = Z0.*(ZL+j.*Z0.*tan(arg))./(Z0+j.*ZL.*tan(arg));


end

