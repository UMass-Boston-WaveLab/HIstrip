classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        basetxline < rfckt.rfckt
%rfckt.basetxline class
%   rfckt.basetxline extends rfckt.rfckt.
%
%    rfckt.basetxline properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%
%    rfckt.basetxline methods:
%       calczin - Z_IN = CALCZIN(H, FREQ, ZTERM) calculate the input
%                 impedance of a
%       checkstubmode - Check the StubMode and Termination of object.
%       getz0 - Get characteristic impedance
%       nwa - Calculate the network parameters.
%       setsigmadiel - set function for sigmadiel.


    properties (SetAccess=protected, Hidden)
        %Z0 Property is of type 'MATLAB array' (read only)
        Z0 = [  ];
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplexvector(obj,value,'Z0',true);
            end
        end
    end   % set and get functions for Z0

    properties (SetAccess=protected, Hidden)
        %PV Property is of type 'MATLAB array' (read only)
        PV = [  ];
    end
    methods 
        function set.PV(obj,value)
            if ~isequal(obj.PV,value)
                % DataType = 'MATLAB array'
                obj.PV = setpositivevector(obj,value,'PV',              ...
                    false,false,true);
            end
        end
    end   % set and get functions for PV

    properties (SetAccess=protected, Hidden)
        %LOSS Property is of type 'MATLAB array' (read only)
        Loss = [  ];
    end
    methods 
        function set.Loss(obj,value)
            if ~isequal(obj.Loss,value)
                % DataType = 'MATLAB array'
                obj.Loss = setpositivevector(obj,value,'Loss',          ...
                    true,false,true);
            end
        end
    end   % set and get functions for Loss

    properties
        %LINELENGTH Property is of type 'MATLAB array' 
        LineLength = 0.01;
    end
    methods 
        function set.LineLength(obj,value)
            if ~isequal(obj.LineLength,value)
                % DataType = 'MATLAB array'
                obj.LineLength = setpositive(obj,value,'LineLength',    ...
                    false,false,false);
            end
        end
    end   % set and get functions for LineLength

    properties
        % STUBMODE Property is of type 'StubModeTypeDATATYPE enumeration:
        % {'NotAStub','Series','Shunt','None'}' 
        StubMode = 'NotAStub';
    end
    methods 
        function set.StubMode(obj,value)
            enum_list = {'NotAStub','Series','Shunt','None'}';
            alias_list = {'NotAStub', 'None'};
            obj.StubMode = checkenum(obj, 'StubMode', value,            ...
                enum_list, alias_list);
        end
    end   % set for StubMode

    properties
        % TERMINATION Property is of type 'TerminationTypeDATATYPE
        % enumeration: {'NotApplicable','Open','Short','None'}' 
        Termination = 'NotApplicable';
    end
    methods 
        function set.Termination(obj,value)
            enum_list = {'NotApplicable','Open','Short','None'};
            alias_list = {'NotApplicable', 'None'};
            obj.Termination = checkenum(obj, 'Termination', value,      ...
                enum_list, alias_list);
         end
    end   % set function for Termination

    methods  % method signatures
        Z_in = calczin(h,freq,zterm)
        checkstubmode(h)
        z0 = getz0(h)
        [type,netparameters,z0] = nwa(h,freq)
        out = setsigmadiel(h,out,prop)
    end  % method signatures

    methods (Abstract)  % method signatures
        checkproperty(h)
    end

end  % classdef