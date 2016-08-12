% Function takes in  S-parameters formatted as rectangular complex numbers
% from HFSS in a .csv format and reads them into Matlab. 
% You need to strip the whitespace from the HFSS data first (use find and 
% replace in Excel, find spaces and replace them with nothing.)

function [M,frequency_sweep,depth,dimension] = readin_HFSS(filename)

input = csvread(filename,1,0);
M = input(:,2:end);
frequency_sweep = input(1:end,1);
[m,n] = size(M);
dimension = sqrt(n);
depth = m;

end





   
