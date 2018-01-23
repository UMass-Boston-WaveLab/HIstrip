function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.DATA

%   Copyright 2003-2007 The MathWorks, Inc.

% Check the properties
refobj = getreference(h);
if hasreference(h)
    [~,fname,ext] = fileparts(h.Reference.Name);
    isamp = isequal(lower(ext),'.amp');
    checkproperty(refobj);
    if ~isa(h, 'rfbbequiv.data')
        if isa(refobj.NetworkData, 'rfdata.network')   &&               ...
                isa(refobj .PowerData, 'rfdata.power') &&               ...
                numel(refobj.PowerData.Freq)>=1
            fc = refobj.PowerData.Freq;
            z0 = h.Z0;
            [type, netparameters, own_z0] = nwa(h, fc);
            if strncmpi(type,'S',1)
                smatrix = s2s(netparameters, own_z0, z0);
            else
                smatrix = convertmatrix(h, netparameters, type,         ...
                    'S_PARAMETERS', z0);
            end
            nfc = numel(fc);
            for ii=1:nfc
                abslineargain = max(eps,abs(smatrix(2,1,ii)));
                pout = get(refobj.PowerData, 'Pout');
                pin = get(refobj.PowerData, 'Pin');
                if ~isempty(pout) && ~isempty(pout{ii})
                    delta_P = abs(20*log10(abslineargain) -             ...
                        10*log10(pout{ii}(1)) + 10*log10(pin{ii}(1)));
                    if isamp && (abslineargain~=1) && (delta_P > 0.4)
                        warning(message('rf:rfdata:data:checkproperty:PoutNotConsistentWithNetworkData', ...
                                     h.Name,sprintf('%d',fc(ii)),sprintf('%d',delta_P),horzcat(fname,ext)));
                        return;
                    end
                end
            end
        end
    end
elseif ~isempty(get(h, 'S_Parameters'))
 
    data = get(h, 'S_Parameters');
    freq = get(h, 'Freq');
    z0 = get(h, 'Z0');
    n = numel(freq);
    [~,~,m3] = size(data);
    k = numel(z0);
    if n~=0 && n~=m3
        rferrhole = '';
        if isempty(h.Block)
            rferrhole = [h.Name, ': '];
        end
        error(message('rf:rfdata:data:checkproperty:WrongFrequency',    ...
            rferrhole));
    end
    if k~=1 && k~=m3
        rferrhole = '';
        if isempty(h.Block)
            rferrhole = [h.Name, ': '];
        end
        error(message('rf:rfdata:data:checkproperty:WrongImpedance',    ...
            rferrhole));
    end
    if n~=0
        [freq, index] = sort(freq);
        data(:,:,:) = data(:,:,index);
        if k == m3
            z0 = z0(index);
        end
    end
    set(h, 'Freq', freq, 'S_Parameters', data, 'Z0', z0);
end