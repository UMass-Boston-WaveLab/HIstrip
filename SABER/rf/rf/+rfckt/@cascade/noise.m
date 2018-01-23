function [cmatrix, ctype] = noise(h, freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX, CTYPE] = NOISE(H, FREQ) calculates the noise correlation
%   matrix of the RFCKT object at the specified frequencies FREQ. The first
%   input is the handle to the RFCKT object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.CASCADE

%   Copyright 2003-2007 The MathWorks, Inc.

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
    simdata = get(h, 'SimData');
end
nfreq = length(freq);
% To see if the analysis is needed
if (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1) &&                  ...
        isa(get(h, 'BudgetData'), 'rfdata.data')
    budget = true;
    % Get the budget data
    budgetdata = get(h, 'BudgetData');
end

% Calculate noise correlation matrix
if (nckts == 1)
    ckt = ckts{1};
    ckt_simdata = ckt.SimData;
    [cmatrix, ctype] = noise(ckt, freq);
    if budget
        updatebudgetdata(budgetdata, cmatrix, ctype, ckt_simdata.Data,  ...
            ckt_simdata.Type, ckt_simdata.Z0, 0);
    end
else 
    ctype = 'ABCD CORRELATION MATRIX';
    ckt = ckts{1};
    ckt_simdata = ckt.SimData;
    [ckt_cmatrix, ckt_ctype] = noise(ckt, freq);
    cmatrix = convertcorrelationmatrix(simdata, ckt_cmatrix, ckt_ctype, ...
        ctype, ckt_simdata.Data,ckt_simdata.Type,ckt_simdata.Z0);
    abcd = getsimdata(simdata, 0, nfreq);
    if budget
        updatebudgetdata(budgetdata, cmatrix, ctype, ckt_simdata.Data,  ...
            ckt_simdata.Type, ckt_simdata.Z0, 0);
    end
    for ii=2:nckts
        ckt = ckts{ii};
        ckt_simdata = ckt.SimData;
        [ckt_cmatrix, ckt_ctype] = noise(ckt, freq);
        ckt_cmatrix = convertcorrelationmatrix(simdata, ckt_cmatrix,    ...
            ckt_ctype, ctype, ckt_simdata.Data,ckt_simdata.Type,        ...
            ckt_simdata.Z0);
        for k=1:nfreq
            cmatrix(:,:,k) = abcd(:,:,k)*ckt_cmatrix(:,:,k)*            ...
                abcd(:,:,k)' + cmatrix(:,:,k);
        end
        [abcd, type, f, z0] = getsimdata(simdata, (ii-1)*nfreq, nfreq);
        if budget
            updatebudgetdata(budgetdata, cmatrix, ctype, abcd, type,    ...
                z0, (ii-1)*length(f));
        end
        freq = convertfreq(ckt, freq);
    end
end


function updatebudgetdata(data, cmatrix, ctype, netparameters, type, z0, k)
cmatrix = convertcorrelationmatrix(data, cmatrix, ctype,                ...
    'ABCD CORRELATION MATRIX', netparameters, type, z0);
nf = noisefigure(data, cmatrix);
m = length(nf);
total_nf = get(data, 'NF');
total_nf((k+1):(k+m), 1) = nf(1:m, 1);
% Update the properties
set(data, 'NF', total_nf);


function [netparameters, type, freq, z0] = getsimdata(data, k, m)
type = get(data, 'Type');
z0 = get(data, 'Z0');
total_netparames = get(data, 'Data');
netparameters(:,:,1:m) = total_netparames(:,:,(k+1):(k+m));
total_freq = get(data, 'Freq');
freq(1:m) = total_freq((k+1):(k+m));
