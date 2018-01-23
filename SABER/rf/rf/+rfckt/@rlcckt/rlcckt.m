classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rlcckt < rfckt.rfckt
%rfckt.rlcckt class
%   rfckt.rlcckt extends rfckt.rfckt.
%
%    rfckt.rlcckt properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       R - Property is of type 'MATLAB array' 
%       L - Property is of type 'MATLAB array' 
%       C - Property is of type 'MATLAB array' 


    properties
        %R Property is of type 'MATLAB array' 
        R = 0;
    end
    methods 
        function set.R(obj,value)
            if ~isequal(obj.R,value)
                % DataType = 'MATLAB array'
                obj.R = setpositive(obj,value,'R',true,true,false);
            end
        end
    end   % set and get functions for R

    properties
        %L Property is of type 'MATLAB array' 
        L = 0;
    end
    methods 
        function set.L(obj,value)
            if ~isequal(obj.L,value)
                % DataType = 'MATLAB array'
                obj.L = setpositive(obj,value,'L',true,true,false);
            end
        end
    end   % set and get functions for L

    properties
        %C Property is of type 'MATLAB array' 
        C = 0;
    end
    methods 
        function set.C(obj,value)
            if ~isequal(obj.C,value)
                % DataType = 'MATLAB array'
                obj.C = setpositive(obj,value,'C',true,true,false);
            end
        end
    end   % set and get functions for C

end  % classdef


