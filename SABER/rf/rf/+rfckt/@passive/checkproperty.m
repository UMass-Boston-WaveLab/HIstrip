function checkproperty(h, for_constructor)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.PASSIVE

%   Copyright 2003-2015 The MathWorks, Inc.

if nargin < 2
    for_constructor = false;
end

data = h.AnalyzedResult;
if isempty(data) && for_constructor
    return
end

% Check the properties
refobj = getreference(data);
if hasreference(data)
    set(refobj,'Block','h.Block')
    checkproperty(refobj);
end
setnport(h,getnport(data));

if isa(h.NetworkData,'rfdata.network')
    if (getnport(h.NetworkData) ~= 2)
        return
    end
    z0 = h.NetworkData.Z0;
    sparam = extract(h.NetworkData,'S-Parameters',z0);
    if ~ispassive(sparam,'Impedance',z0)
        if isempty(h.Block)
            hname = horzcat(h.Name,': ','RFCKT.PASSIVE');
            hrep = 'RFCKT.AMPLIFIER object';
        else
            hname = get_param(h.Block,'Name');
            hrep = 'General Amplifier block';
        end
        error(message('rf:rfckt:passive:checkproperty:WrongRFCKTObj',hname,hrep))
    end
else
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name,': '];
    end
    error(message('rf:rfckt:passive:checkproperty:NoNetworkData',rferrhole))
end