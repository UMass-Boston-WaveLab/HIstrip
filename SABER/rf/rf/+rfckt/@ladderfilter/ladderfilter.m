classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        ladderfilter < rfckt.rfckt
%rfckt.ladderfilter class
%   rfckt.ladderfilter extends rfckt.rfckt.
%
%    rfckt.ladderfilter properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       L - Property is of type 'MATLAB array' 
%       C - Property is of type 'MATLAB array' 
%
%    rfckt.ladderfilter methods:
%       destroy - Destroy this object
%       nwa - Calculate the network parameters.


    properties
        %L Property is of type 'MATLAB array' 
        L = [  ];
    end
    methods 
        function set.L(obj,value)
            if ~isequal(obj.L,value)
                % DataType = 'MATLAB array'
                obj.L = setpositivevector(obj,value,'L',false,false,true);
            end
        end
    end   % set and get functions for L

    properties
        %C Property is of type 'MATLAB array' 
        C = [  ];
    end
    methods 
        function set.C(obj,value)
            if ~isequal(obj.C,value)
                % DataType = 'MATLAB array'
                obj.C = setpositivevector(obj,value,'C',false,false,true);
            end
        end
    end   % set and get functions for C

    properties (SetAccess = public,Hidden)
        %CKTS Property is of type 'MATLAB array' (read only)
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
        [type,netparameters,z0] = nwa(h,freq)
        [cmatrix,ctype] = noise(h,freq)
    end  % method signatures

    methods (Abstract)  % method signatures
        h = createntwk(varargin)
    end

    methods (Access = protected)
        copyObj = copyElement(h)
    end

end  % classdef

function out = setckts(h,in,prop_name)
if isempty(in)
    out = in;
    return
end

if ~isa(in,'cell')
    if isempty(h.Block)
        rferrhole1 = h.Name;
        rferrhole2 = prop_name;
    else
        rferrhole1 = upper(class(h));
        rferrhole2 = prop_name;
    end
    error(message('rf:rfckt:ladderfilter:schema:NotACKTCell', ...
        rferrhole1,rferrhole2))
end
nckts = length(in);
for ii = 1:nckts
    ckt = in{ii};
    if ~isa(ckt,'rfckt.rfckt') 
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:ladderfilter:schema:NotACKTObj', ...
            rferrhole1,rferrhole2))

    elseif get(ckt,'nPort') ~= 2
        if isempty(h.Block)
            rferrhole1 = h.Name;
            rferrhole2 = prop_name;
        else
            rferrhole1 = upper(class(h));
            rferrhole2 = prop_name;
        end
        error(message('rf:rfckt:ladderfilter:schema:NotATwoPort', ...
            rferrhole1,rferrhole2))

    end
    if h.CopyPropertyObj
        out{ii} = copy(ckt); %#ok<AGROW>
    else
        out{ii} = ckt; %#ok<AGROW>
    end
end
end   % setckts