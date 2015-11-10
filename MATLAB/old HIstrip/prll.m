function [Zout] = prll(Z1,Z2)
%parallel combination of two impedances
Zout = 1./(1./Z1+1./Z2);