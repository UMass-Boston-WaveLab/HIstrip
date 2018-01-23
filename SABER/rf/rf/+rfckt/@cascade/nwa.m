function [type, netparameters, z0] = nwa(h,freq,varargin)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of this circuit at the specified frequencies FREQ. The first
%   input is the handle to the circuit object, the second input is a vector
%   for the specified freqencies.
%
%   See also RFCKT.CASCADE

%   Copyright 2003-2007 The MathWorks, Inc.

p = inputParser;
addParameter(p,'isspurcalc',false);
parse(p,varargin{:});
spurbool = p.Results.isspurcalc;

% Get the properties
ckts = get(h, 'CKTS');
nckts = length(ckts);
budget = false;
cflag = get(h, 'Flag');
setflagindexes(h);
% To see if the analysis is needed
if (bitget(cflag, indexOfTheBudgetAnalysisOn) == 1)
    budget = true;
    % Get the budget data
    if ~isa(h.BudgetData, 'rfdata.data')
        set(h, 'BudgetData', rfdata.data);
    end
    budgetdata = get(h, 'BudgetData');
    n = nckts * length(freq);
    sparams = zeros(2,2,n);
    nf = zeros(n, 1);
    oip3(1:n, 1) = inf;
    set(budgetdata, 'S_Parameters', sparams, 'Freq', freq, 'NF', nf, ...
        'OIP3', oip3, 'nCkts', nckts);
else
    set(h, 'BudgetData', []);
end
if ~isa(h.SimData, 'rfdata.network')
    set(h, 'SimData', rfdata.network);
end
simdata = get(h, 'SimData');

% Calculate the network parameters
if (nckts == 1)
    ckt = ckts{1};
    ckt_simdata = getcktsimdata(ckt);
    [type, netparameters, z0] = spurnwa(ckt,freq,'isSpurCalc',spurbool);
    if isa(ckt_simdata, 'rfdata.network')
        set(ckt_simdata, 'Type', type,  'Data', netparameters,          ...
            'Freq', freq, 'Z0', z0);
    end
    set(simdata, 'Type', type);
    updatesimdata(simdata, netparameters, type, freq, z0, 0);
    if budget
        updatebudgetdata(budgetdata, netparameters, type, freq, z0, 0);
    end
else 
    % Calculate the ABCD-parameters
    type = 'ABCD_PARAMETERS';
    z0 = 50;
    ckt = ckts{1};
    ckt_simdata = getcktsimdata(ckt);
    [ckt_type,ckt_params,ckt_z0] = spurnwa(ckt,freq,'isSpurCalc',spurbool);
    netparameters = convertmatrix(simdata, ckt_params, ckt_type, type,  ...
        ckt_z0, z0);
    if isa(ckt_simdata, 'rfdata.network')
        set(ckt_simdata, 'Type', type, 'Data', netparameters,           ...
            'Freq', freq, 'Z0', z0);
    end
    set(simdata, 'Type', type);
    updatesimdata(simdata, netparameters, type, freq, z0, 0);
    if budget
        updatebudgetdata(budgetdata, netparameters, type, freq, z0, 0);
    end
    
    freq = convertfreq(ckt,freq,'isSpurCalc',spurbool);
    
    nfreq = size(netparameters,3);
    for ii=2:nckts
        ckt = ckts{ii};
        ckt_simdata = getcktsimdata(ckt);
        [ckt_type,ckt_params,ckt_z0] = spurnwa(ckt,freq,'isSpurCalc',spurbool);
        ckt_params = convertmatrix(simdata, ckt_params, ckt_type, type, ...
            ckt_z0, z0);
        if isa(ckt_simdata, 'rfdata.network')
            set(ckt_simdata, 'Type', type,  'Data', ckt_params,         ...
                'Freq', freq, 'Z0', z0);
        end
        for k=1:nfreq
            netparameters(:,:,k) = netparameters(:,:,k)*ckt_params(:,:,k);
        end
        updatesimdata(simdata, netparameters, type, freq, z0,           ...
            (ii-1)*length(freq));
        if budget
            updatebudgetdata(budgetdata, netparameters, type, freq, z0, ...
                (ii-1)*length(freq));
        end
        
        freq = convertfreq(ckt,freq,'isSpurCalc',spurbool);
    end
end


function updatebudgetdata(data, netparameters, type, freq, ckt_z0, k)
% Calculate the S-parameters
z0 = get(data, 'Z0');
if strncmpi(type,'S',1)
    sparams = s2s(netparameters, ckt_z0, z0);
else
    sparams = convertmatrix(data, netparameters, type, 'S_PARAMETERS', z0);
end

[~,~,m] = size(netparameters);
total_sparames = get(data, 'S_Parameters');
total_sparames(:,:,(k+1):(k+m)) = sparams(:,:,1:m);
total_freg = get(data, 'Freq');
total_freg((k+1):(k+m)) = freq(1:m);
% Update the properties
set(data, 'S_Parameters', total_sparames, 'Freq', total_freg);


function updatesimdata(data, netparameters, nettype, freq, ckt_z0, k)
% Calculate the S-parameters
type = get(data, 'Type');
z0 = get(data, 'Z0');
if strncmpi(nettype,'S',1)
    netparameters = convertmatrix(data, netparameters, nettype, type,   ...
        ckt_z0, z0);
else
    netparameters = convertmatrix(data, netparameters, nettype, type, z0);
end
[~,~,m] = size(netparameters);
total_netparames = get(data, 'Data');
total_netparames(:,:,(k+1):(k+m)) = netparameters(:,:,1:m);
total_netparames = total_netparames(:,:,1:k+m);
total_freq = get(data, 'Freq');
total_freq((k+1):(k+m)) = freq(1:m);
total_freq = total_freq(1:k+m);
% Update the properties
set(data, 'Data', total_netparames, 'Freq', total_freq);


function ckt_simdata = getcktsimdata(ckt)
ckt_simdata = [];
if isa(ckt, 'rfckt.rfckt') && ~isa(ckt, 'rfckt.cascade')
    if ~isa(ckt.SimData, 'rfdata.network')
        set(ckt, 'SimData', rfdata.network);
    end
    ckt_simdata = get(ckt, 'SimData');
end
