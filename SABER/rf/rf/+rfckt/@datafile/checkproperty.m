function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.DATAFILE

%   Copyright 2003-2015 The MathWorks, Inc.

data = get(h,'AnalyzedResult');
file = get(h,'File');

% Check the file name
if isempty(file) && (~isa(data,'rfdata.data') || ~hasreference(data))
    rferrhole1 = '';
    if isempty(h.Block)
        rferrhole1 = [h.Name,': '];
    end
    rferrhole2 = upper(class(h));
    error(message('rf:rfckt:datafile:checkproperty:EmptyFile',rferrhole1,rferrhole2))
end
if ~isempty(file)
    read(h,file);
    data = get(h,'AnalyzedResult');
end

% Check the property of data object
checkproperty(data);
setnport(h,getnport(data));
% Set the flag for nonlinear
setflagindexes(h);
updateflag(h,indexOfNonLinear,0,MaxNumberOfFlags);
if isa(data,'rfdata.data')
    refobj = getreference(data);
    if hasreference(data)
        netdata = get(refobj,'NetworkData'); 
        powerdata = get(refobj,'PowerData'); 
        ip3data = get(refobj,'IP3Data'); 
        if ~isempty(refobj.MixerSpurData)
            if isempty(h.Block)
                rferrhole1 = [h.Name,': ',h.File];
                rferrhole2 = 'RFCKT.MIXER';
            else
                rferrhole1 = h.File;
                rferrhole2 = 'General Mixer block';
            end
            error(message('rf:rfckt:datafile:checkproperty:MIXERSPURDataForDATAFILE',rferrhole1,rferrhole2))
        end
        if isa(netdata,'rfdata.network')
            z0 = netdata.Z0;
            sparam = extract(netdata,'S-Parameters',z0);
            if h.nPort == 2 && ~ispassive(sparam,'Impedance',z0) && ...
                    isempty(refobj.NoiseData) && isempty(refobj.NFData)
                if isempty(h.Block)
                    rferrhole = [h.Name,': ',h.File];
                else
                    rferrhole = h.File;
                end
                warning(message('rf:rfckt:datafile:checkproperty:NeedNoiseDataInDATAFILE',rferrhole))
            end
        end
    else
        powerdata = [];
        ip3data = [];
    end
    if isa(powerdata,'rfdata.power') || isa(ip3data,'rfdata.ip3')
        updateflag(h,indexOfNonLinear,1,MaxNumberOfFlags);
    end
end