function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIP3(H, FREQ) calculates the OIP3 of the RFCKT object at the
%   specified frequencies FREQ. The first input is the handle to the RFCKT
%   object, the second input is a vector for the specified freqencies.
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

narginchk(2,2)

result = inf * ones(length(freq), 1);
% Get the data
data = get(h, 'AnalyzedResult');
if isa(data, 'rfdata.data') 
    result = oip3(data, freq);
end