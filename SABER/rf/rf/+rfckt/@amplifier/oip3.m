function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIP3(H, FREQ) calculates the OIP3 of the RFCKT object at the
%   specified frequencies FREQ. The first input is the handle to the RFCKT
%   object, the second input is a vector for the specified freqencies.
%
%   See also RFCKT.AMPLIFIER

%   Copyright 2003-2007 The MathWorks, Inc.

result = inf * ones(length(freq), 1);
% Get the data
data = get(h, 'AnalyzedResult');
if isa(data, 'rfdata.data') 
    result = oip3(data, freq);
end

% Calc oip3
if all(isinf(result))
    if ~(h.OIP3 == inf)
        temp = h.OIP3;
    elseif ~(h.IIP3 == inf)
        iip3 = get(h, 'IIP3');
        if isa(data, 'rfdata.data')
            smatrix = get(data, 'S_Parameters');
            if ~isempty(smatrix)
                gain = sqrt(ga(data, freq));
            end
        end
        temp = iip3 + 20.*log10(gain);
    else
        temp = inf;
    end
    result(1:length(freq), 1) = 0.001.*10.^(temp/10);
end