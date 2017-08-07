function [ f, Z ] = importHFSSZ( filename)
%IMPORTHFSSZ imports impedance data that has been exported from a
%report/plot in HFSS.  Each line is assumed to list f, Re{Z}, Im{Z} in that
%order.

fid = fopen(filename,'r');
data = textscan(fid, '%f,%f,%f','headerlines',1);
fclose(fid);

f = data{1};
Z = data{2}+j*data{3};
end

