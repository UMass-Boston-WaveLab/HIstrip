function [freq, out, legstrings] = read_HFSS_file_S(filename)
[a, b, c] = xlsread(filename);
n_variations = (length(b)-1)/2;
if ~isempty(strfind(b{2},'deg'))
    phaseunits = 'deg';
else
    phaseunits = '';
end
if ~isempty(strfind(b{2+n_variations},'dB'))
    magunits = 'dB';
else
    magunits = '';
end
if ~isempty(strfind(b{1},'GHz'))
    fmult = 1000;
else
    fmult = 1;
end
freq = a(1:end,1)*fmult;
if isempty(phaseunits)
phase = a(:, 2:(n_variations+1));
else
    phase = a(:, 2:(n_variations+1))*pi/180;
end
if isempty(magunits)
    mag = a(:,(n_variations+2):end);
else
    mag = 10.^(a(:,(n_variations+2):end)/20);
end
out = mag.*exp(i*phase);
for ii = 2:length(b)
    test = b{ii};
    index = strfind(test, ' - ');
    legstrings{ii-1} = test((index+3):end);
end
end