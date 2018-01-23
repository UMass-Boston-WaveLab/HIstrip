function [type, netparameters, z0] = nwa(h, freq)
%NWA Calculate the network parameters.
%   [TYPE, NETWORKPARAMS, Z0] = NWA(H, FREQ) calculates the network
%   parameters of the data at the specified frequencies FREQ. The first
%   input is the handle to the RFDATA.DATA object, the second input is a
%   vector for the specified freqencies.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the original frequency and S_Parameters
refobj = getreference(h);
z0 = h.Z0;
if hasreference(h)
    netobj = get(refobj, 'NetworkData');
    if isa(netobj, 'rfdata.network')
        z0 = netobj.Z0;
        if strncmpi(netobj.Type,'S',1)
            original_freq = netobj.Freq;
            original_sparams = netobj.Data;
        else
            [original_sparams, original_freq] =                         ...
                extract(netobj,'S_Parameters', z0);
        end
    else
        original_freq = [];
        original_sparams = [];
    end
else
    original_freq = get(h, 'Freq');
    original_sparams = get(h, 'S_Parameters');
end
method = lower(get(h, 'IntpType'));
if strcmpi(method,'cubic') % g914673
    method = 'pchip';
end
N = numel(freq);

if isempty(original_sparams)
    type = 'S_PARAMETERS';
    [netparameters(1,1,1:N), netparameters(1,2,1:N),                    ...
        netparameters(2,1,1:N), netparameters(2,2,1:N)] = deal(0, 0, 1, 0);
    return;
end
if isempty(original_freq) 
    type = 'S_PARAMETERS';
    [netparameters(1,1,1:N), netparameters(1,2,1:N), ...
        netparameters(2,1,1:N), netparameters(2,2,1:N)] =               ...
        deal(original_sparams(1,1,1), original_sparams(1,2,1),          ...
        original_sparams(2,1,1), original_sparams(2,2,1));
    return;
end
    
% Check Freq and S-parameters 
nport = size(original_sparams, 1);

% Check the data to determine if an interpolation is needed
M = numel(original_freq);
if M == 1 
    % No need interpolation
    for k1=1:nport
        for k2=1:nport
            sdata = original_sparams(k1,k2,:);
            sparams(k1,k2,:) = sdata;
            sparams(k1,k2,1:N) = deal(original_sparams(k1,k2,1));
        end
    end
elseif (numel(freq) == numel(original_freq)) && all(original_freq == freq)
    % No need interpolation
    sparams = original_sparams;
else
    % Sort the data 
    [original_freq, freqindex] = sort(original_freq);
    original_sparams(:,:,:) = original_sparams(:,:,freqindex);

    % Interpolate
    for k1=1:nport
        for k2=1:nport
            sdata = original_sparams(k1,k2,:);
            sdata = interp1(original_freq, sdata(:), freq, method, NaN);
            sparams(k1,k2,:) = sdata;
        end
    end
    
    % Extrapolate
    index = find(freq < original_freq(1));
    if ~isempty(index)
        sparams(:,:,index) = repmat(original_sparams(:,:,1),            ...
            [1 1 numel(index)]);
    end
    
    index = find(freq > original_freq(end));
    if ~isempty(index)
         sparams(:,:,index) = repmat(original_sparams(:,:,end),         ...
             [1 1 numel(index)]);
    end    
end

type = 'S_PARAMETERS';
netparameters = sparams;
