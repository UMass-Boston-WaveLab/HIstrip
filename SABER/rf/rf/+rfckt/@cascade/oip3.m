function result = oip3(h, freq)
%OIP3 Calculate the OIP3.
%   RESULT = OIP3(H, FREQ) calculates the OIP3 of the RFCKT object at the
%   specified frequencies FREQ. The first input is the handle to the RFCKT
%   object, the second input is a vector for the specified freqencies.
%
%   See also RFCKT.CASCADE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the data
if ~isa(get(h, 'SimData'), 'rfdata.network')
    nwa(h, freq);
end
simdata = get(h, 'SimData');

ckts = get(h, 'CKTS');
nckts = length(ckts);
budget = false;
cflag = get(h, 'Flag');
setflagindexes(h);
n = length(simdata.Freq)/nckts;
f(1:n) = simdata.Freq(1:n);
if (length(f) ~= length(freq)) || any(f(:) - freq(:)) ||                ...
        (length(simdata.Freq) ~= nckts * length(freq))
    nwa(h, freq);
end

% To see if the analysis is needed
if (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1) &&                  ...
        isa(get(h, 'BudgetData'), 'rfdata.data')
    budget = true;
    % Get the budget data
    budgetdata = get(h, 'BudgetData');
end

% Calc the oip3
if budget
    for ii=1:nckts
        temp = cascadedoip3(ii, ckts);
        updatebudgetdata(budgetdata, temp, (ii-1)*length(f));
    end
else
    temp = cascadedoip3(nckts, ckts);
end
result = temp2oip3(temp);


function updatebudgetdata(data, temp, k)
m = length(temp);
total_oip3 = get(data, 'OIP3');
oip3 = temp2oip3(temp);
total_oip3((k+1):(k+m), 1) = oip3(1:m, 1);
% Update the properties
total_oip3(total_oip3 <= 0) = eps;
set(data, 'OIP3', total_oip3);


function oip3 = temp2oip3(temp)
m = length(temp);
oip3 = zeros(m, 1);
for ii = 1:m
    if (temp(ii, 1) == 0);
        oip3(ii, 1) = inf;
    else
        oip3(ii, 1) = 1./temp(ii, 1);
    end
end

function temp = cascadedoip3(nckts, ckts)
ckt = ckts{nckts};
data = get(ckt, 'SimData');
pgain = gain(ckt, data);
if isa(ckt, 'rfckt.cascade')
    n = length(data.Freq)/length(ckt.Ckts);
    freq(1:n) = data.Freq(1:n);
else
    freq = data.Freq;
end
temp = 1 ./ oip3(ckt, freq);
for ii=(nckts-1):-1:1
    ckt = ckts{ii};
    data = get(ckt, 'SimData');
    if isa(ckt, 'rfckt.cascade')
        n = length(data.Freq)/length(ckt.Ckts);
        freq(1:n) = data.Freq(1:n);
    else
        freq = data.Freq;
    end
    temp = temp + 1 ./ oip3(ckt, freq) ./ pgain;
    % RF Circuit Design, p529
    pgain = pgain .* gain(ckt, data);
end


function result = gain(ckt, data)
% Set the default 
result = 1;
sparams = extract(data, 'S_PARAMETERS', 50);
if isa(ckt, 'rfckt.cascade')
    [n1, n2, m] = size(sparams);
    n = m/length(ckt.Ckts);
    smatrix(:,:,1:n) = sparams(:,:,m-n+1:m);
else
    smatrix = sparams;
end
if ~isempty(smatrix)
    gammas = 0;
    % Analysis and Design, p187
    gammaout = smatrix(2,2,:) + smatrix(1,2,:) .* smatrix(2,1,:) .*     ...
        gammas ./ (1 - smatrix(1,1,:) .* gammas);
    % Analysis and Design, p187
    temp = (abs(1 - smatrix(1,1,:) .* gammas) .^ 2) .*                  ...
        (1 - (abs(gammaout) .^ 2));
    temp(temp == 0) = eps;
    result = (1 - abs(gammas) .^ 2) .* (abs(smatrix(2,1,:)) .^ 2) ./ temp;
    result = result(:);
    % Analysis and Design, (3.2.4) p213
end