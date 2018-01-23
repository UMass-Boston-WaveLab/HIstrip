classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        network < rfckt.rfckt
%rfckt.network class
%   rfckt.network extends rfckt.rfckt.
%
%    rfckt.network properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       Ckts - Property is of type 'MATLAB array' 
%
%    rfckt.network methods:
%       destroy - Destroy this object
%       findimpedance - Find reference impedance.
%       refinedeltafreq - Refine the delta frequencies.
%       setop - Set operating conditions.
%       updateflag - Update the Flag.


    properties
        %CKTS Property is of type 'MATLAB array' 
        Ckts = {  };
    end
    methods 
        function set.Ckts(obj,value)
            % DataType = 'MATLAB array'
            obj.Ckts = setckts(obj,value,'Ckts');
        end
    end   % set and get functions for Ckts

    methods  % method signatures
        h = destroy(h,destroyData)
        [z0_1,z0_2] = findimpedance(h,z0_1,z0_2)
        [deltafreq_left,deltafreq_right] = refinedeltafreq(h,freq,      ...
            deltafreq_left,deltafreq_right,userspecified)
        varargout = setop(h,varargin)
        updateflag(h,index,iflag,nflags)
    end  % method signatures

    methods (Access = protected)
        copyObj = copyElement(h)
    end
    
    methods % JJW 4/24/2012
        function tf = isrfcktvalid(obj)
            tf = isrfcktvalid@rfckt.rfckt(obj);
            if tf
                for nn = 1:length(obj.Ckts)
                    tf = tf && isrfcktvalid(obj.Ckts{nn});
                end
            end
        end
    end

end  % classdef

function out = setckts(h, in, prop_name)
if isempty(in)
    out = in;
    return
end

if ~isa(in, 'cell')
    if isempty(h.Block)
        rferrhole1 = h.Name;
        rferrhole2 = prop_name;
    else
        rferrhole1 = upper(class(h));
        rferrhole2 = prop_name;
    end
    error(message('rf:rfckt:network:schema:NotACKTCell',                ...
        rferrhole1, rferrhole2));
end
nckts = length(in);
out = cell(1,nckts);
for ii = 1:nckts
    ckt = in{ii};
    if ~isa(ckt, 'rfckt.rfckt') || ~isvalid(ckt)
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:network:schema:NotACKTObj',             ...
            rferrhole1, rferrhole2));

    elseif get(ckt, 'nPort') ~= 2
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:network:schema:NotATwoPort',            ...
            rferrhole1, rferrhole2));

    end
    if h.CopyPropertyObj
        out{ii} = copy(ckt);
    else
        out{ii} = ckt;
    end
end
end   % setckts

