classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        ip3 < rfdata.rfdata

%rfdata.ip3 class
%   rfdata.ip3 extends rfdata.rfdata.
%
%    rfdata.ip3 properties:
%       Name - Property is of type 'string' (read only)
%       Type - Property is of type 'IP3TypeDATATYPE enumeration:
%              {'OIP3','IIP3'}' 
%       Freq - Property is of type 'MATLAB array' 
%       Data - Property is of type 'MATLAB array' 
%
%    rfdata.ip3 methods:
%       checkproperty - Check the properties of the object.


    properties
        % TYPE Property is of type 'IP3TypeDATATYPE enumeration:
        % {'OIP3','IIP3'}' 
        Type = 'OIP3';
    end
    methods 
        function set.Type(obj,value)
            enum_list = {'OIP3','IIP3'};
            obj.Type = checkenum(obj, 'Type', value, enum_list);
         end
    end   % set function for Type

    properties
        % FREQ Property is of type 'MATLAB array' 
        Freq = [  ];
    end
    methods 
        function set.Freq(obj,value)
            if ~isequal(obj.Freq,value)
                % DataType = 'MATLAB array'
                obj.Freq = setpositivevector(obj,value,                 ...
                    'Freq',true,false,true);
            end
        end
    end   % set and get functions for Freq

    properties
        %DATA Property is of type 'MATLAB array' 
        Data = inf;
    end
    methods 
        function set.Data(obj,value)
            if ~isequal(obj.Data,value)
                % DataType = 'MATLAB array'
                obj.Data = setpositivevector(obj,value,                 ...
                    'Data',false,true,false);
            end
        end
    end   % set and get functions for Data

    properties (Hidden)
        %Z0 Property is of type 'MATLAB array' 
        Z0 = 50;
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplexvector(obj,value,'Z0',               ...
                    false,true,false);
            end
        end
    end   % set and get functions for Z0


    methods  % constructor block
        function h = ip3(varargin)
        %IP3 Data Object Constructor.
        %   H = RFDATA.IP3('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a data object for the frequency-dependent IP3 data, H,
        %   based on the properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfdata.ip3'. 
        %
        %   An IP3 data object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name          - Object name. (read only)
        %   Type          - Type of data. The choices are: 'OIP3' or 'IIP3'
        %   Freq          - Frequency (Hz)
        %   Data          - Frequency-dependent IP3 (W)
        % 
        %   Example:
        %
        %      % Create an IP3 data object
        %        h = rfdata.ip3('Type', 'OIP3', 'Freq', 2.1e9, 'Data', 8.45)
        %
        %   See also RFDATA, RFDATA.POWER, RFDATA.P2D, RFDATA.NETWORK,
        %   RFDATA.NOISE, RFDATA.NF, RFCKT
        
        %   Copyright 2004-2007 The MathWorks, Inc.
        
        % Create an RFDATA.IP3 object

        %UDD % h = rfdata.ip3;
        set(h, 'Name', '3rd order intercept');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % ip3
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h)
    end  % method signatures

end  % classdef