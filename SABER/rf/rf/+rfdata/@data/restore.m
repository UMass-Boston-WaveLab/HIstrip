function h = restore(h)
%RESTORE Restore the original data for plot.
%   H = RESTORE(H) restores the data from the data file. H is the handle to
%   the RFDATA.DATA object.
%
%   See also RFDATA.DATA, RFDATA.DATA/ANALYZE, RFDATA.DATA/READ

%   Copyright 2003-2009 The MathWorks, Inc.

% Get the Reference
freq = [];
refobj = getreference(h);
z0 = h.Z0;
if hasreference(h)
    % get the Networkdata
    netdata = get(refobj, 'NetworkData');
    nfdata = get(refobj, 'NFData');
    if isa(netdata, 'rfdata.network')
        if isempty(get(netdata, 'Data'))
            set(h, 'Freq', [], 'S_Parameters', [], 'NF', 0, 'OIP3', inf);
        else
            % Get the FREQ and extract S-parameters
            [sparams, freq] = extract(netdata, 'S_PARAMETERS');
            z0 = get(netdata, 'Z0');
            % Update the properties
            set(h, 'Freq', freq, 'S_Parameters', sparams, 'Z0', z0,     ...
                'NF', 0, 'OIP3', inf);
        end
    elseif isa(nfdata, 'rfdata.nf')
        if isempty(get(nfdata, 'Data'))
            set(h, 'Freq', [], 'S_Parameters', [], 'NF', 0, 'OIP3', inf);
        else
            % Update the properties
            set(h, 'Freq', nfdata.Freq, 'S_Parameters', [],             ...
                'NF', nfdata.Data, 'OIP3', inf);
        end
    else
        set(h, 'Freq', [], 'S_Parameters', [], 'Z0', 50, 'NF', 0,       ...
            'OIP3', inf);
    end
end
if ~isempty(freq)
    analyze(h, freq, z0, z0, z0);
end