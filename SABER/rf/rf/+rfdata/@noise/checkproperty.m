function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.NOISE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
freq = get(h, 'Freq');
fmin = get(h, 'FMIN');
gammaopt = get(h, 'GAMMAOPT');
rn = get(h, 'RN');
n = numel(freq);
m1 = numel(fmin);
m2 = numel(gammaopt);
m3 = numel(rn);
if ((n ==0) && ~((m1 == 1) && (m2 == 1) && (m3==1))) || ...
        (~(n ==0) && ~((n==m1) && (n==m2) && (n==m3)))
    error(message('rf:rfdata:noise:checkproperty:WrongDataSize'));
end
if n~= 0
    [freq, index] = sort(freq);
    fmin = fmin(index);
    gammaopt = gammaopt(index);
    rn = rn(index);
end
set(h, 'Freq', freq, 'Fmin', fmin, 'GammaOPT', gammaopt, 'RN', rn);