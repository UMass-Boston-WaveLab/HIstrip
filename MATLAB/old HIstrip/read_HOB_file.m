function [freq, out] = read_HOB_file(filename)
fid = fopen(filename);
test = fgetl(fid);
if ~isempty(strfind(test,'dB'))
    units = 'dB';
elseif ~isempty(strfind(test,'deg'))
    units = 'deg';
else
    units = '';
end
fgetl(fid);
fgetl(fid);

temp = textscan(fid, '%f %f');
out = temp{2};
freq = temp{1};
if strcmp(units,'dB')
    out = 10.^(out/10);
elseif strcmp(units,'deg')
    out = out*pi/180;
end
clear temp;
end