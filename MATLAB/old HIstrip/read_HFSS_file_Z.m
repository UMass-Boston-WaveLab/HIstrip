function [freq, out, legstrings] = read_HFSS_file_Z(filename)
[a, b, c] = xlsread(filename);
n_variations = (length(b)-1)/2;
if ~isempty(strfind(b{2},'im')) || ~isempty(strfind(b{3},'im'))
    type = 'reim';
else
    type = 'magphase';
    if ~isempty(strfind(b{2},'deg'))
        phasemult = pi/180;
    else
        phasemult = 1;
    end
end
if ~isempty(strfind(b{1},'GHz'))
    fmult = 1000;
else
    fmult = 1;
end
freq = a(:,1)*fmult;
if strcmp(type, 'reim')
    if ~isempty(strfind(b{2},'re'))
        out = a(:, 2:(n_variations+1))+j*a(:, (n_variations+2):end);
    else
        out = j*a(:, 2:(n_variations+1))+a(:, (n_variations+2):end);
    end
    
else
    out = exp(j*a(:, 2:(n_variations+1))*phasemult).*a(:, (n_variations+2):end);
end
for ii = 2:(n_variations+1)
    test = b{ii};
    index = strfind(test, ' - ');
    legstrings{ii-1} = test((index+3):end);
end
end