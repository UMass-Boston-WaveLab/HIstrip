clc;
clear all;
close all;
%% Data selection and zoom from HFSS
% This needs to resize HFSS data to fit MATLAB vectors
% Also should enable finer resolutions of MATLAB than HFSS

%% HISTRIP Vectors
sf = 1;
f_step = 2; %this just makes it easy to scale model resolution uniformly
f = (250:f_step:450)*10^6/sf;
%% HFSS data Import
%~~~~S11~~~~~~~~~~~
S11data = csvread('MagS11_Cu2.csv',1,0); 
f_HFSS = S11data(:,1)*10^6;
S11_HFSS = S11data(:,2);
f_HFSS_step = abs(S11data(2,1)-S11data(1,1));
f_HFSS_scaled = zeros(size(f(:)));
S11_HFSS_scaled = zeros(size(f(:)));
S11data_NoVias = csvread('MagS11NoVias.csv',1,0); 
%~~~~Zin~~~~~~~~~~~~
ZinData = csvread('MagZinCu.csv',1,0);
for ii = 1:length(f_HFSS)
   if f(1,1) == f_HFSS(ii)
       f_HFSS_scaled(1,1) = f_HFSS(ii);
       S11_HFSS_scaled(1,1) = S11_HFSS(ii);
       break;
   end
end% this finds the first data point where matlab and HFSS intersect and
% stores it as the initial value in new matrix
% this fills in the remaining data starting from the first shared data point
nn = ii+f_step/f_HFSS_step; %count vector based on the difference in step sizes between the model & HFSS
for n = 1:length(f)-1
        f_HFSS_scaled(n+1,1) = f_HFSS(nn);
        S11_HFSS_scaled(n+1,1) = S11_HFSS(nn);
 nn = nn+f_step/f_HFSS_step;
end %stores rest of HFSS data into resized array