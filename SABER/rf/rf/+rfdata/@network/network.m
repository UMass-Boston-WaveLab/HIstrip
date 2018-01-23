classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        network < rfdata.rfdata & rf.internal.netparams.Interface
%rfdata.network class
%   rfdata.network extends rfdata.rfdata.
%
%    rfdata.network properties:
%       Name - Property is of type 'string' (read only)
%       Type - Property is of type 'MATLAB array' 
%       Freq - Property is of type 'MATLAB array' 
%       Data - Property is of type 'MATLAB array' 
%       Z0 - Property is of type 'MATLAB array' 
%
%    rfdata.network methods:
%       calculate - Calculate the required power parameter.
%       checkproperty - Check the properties of the object.
%       extract - Extract the specified network parameters.
%       getnport - Get the port number.


    properties
        %TYPE Property is of type 'MATLAB array' 
        Type = 'S-Parameters';
    end
    methods 
        function set.Type(obj,value)
            if ~isequal(obj.Type,value)
                % DataType = 'MATLAB array'
                obj.Type = setnetworkparametertype(obj,value,           ...
                    'Type',false);
            end
        end
    end   % set and get functions for Type

    properties
        %FREQ Property is of type 'MATLAB array' 
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
        Data = [ 0, 0; 1, 0 ];
    end
    methods 
        function set.Data(obj,value)
            if ~isequal(obj.Data,value)
                % DataType = 'MATLAB array'
                obj.Data = setcomplexmatrix(obj,value,'Data',true);
            end
        end
    end   % set and get functions for Data

    properties
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
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
        function h = network(varargin)
        %NETWORK Data Object Constructor.
        %   H = RFDATA.NETWORK('Type', VALUE1, 'Freq', VALUE2, 'Data',
        %   VALUE3, ...) returns a data object for the frequency-dependent
        %   network parameters,H, based on the properties specified by the
        %   input arguments in the PROPERTY/VALUE pairs. Any properties you
        %   do not specify retain their default values, which can be viewed
        %   by typing 'h = rfdata.network'. 
        %
        %   A NETWORK data object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Type           - Type of data. The choices are: 'S', 'Y', "Z',
        %                    'H', 'G', 'ABCD' or 'T'
        %   Freq           - Frequency (Hz)
        %   Data           - Frequency-dependent network parameters
        %   Z0             - Reference impedance (for S-Parameters only)
        %
        %   rfdata.network methods:   
        %     extract      - Extract the specified network parameters  
        %
        %   Example:
        %
        %      % Create a NETWORK data object
        %        f = [2.08 2.10 2.15]*1.0e9;
        %        y(:,:,1) = [-.0090-.0104i, .0013+.0018i; ...
        %                    -.2947+.2961i, .0252+.0075i];
        %        y(:,:,2) = [-.0086-.0047i, .0014+.0019i; ...
        %                    -.3047+.3083i, .0251+.0086i];
        %        y(:,:,3) = [-.0051+.0130i, .0017+.0020i; ...
        %                     -.3335+.3861i, .0282+.0110i];
        %        h = rfdata.network('Type','Y_PARAMETERS','Freq',f,
        %            'Data',y)
        %
        %   See also RFDATA, RFDATA.NOISE, RFDATA.NF, RFDATA.POWER,
        %   RFDATA.IP3,RFDATA.P2D, RFCKT
         
        %   Copyright 2003-2007 The MathWorks, Inc.
        
        % Create an RFDATA.NETWORK object

        %UDD % h = rfdata.network;
        set(h, 'Name', 'Network parameters');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');

        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % network
        
    end  % constructor block

    methods  % method signatures
        [data,param,freq] = calculate(h,parameter,z0,zl,zs)
        checkproperty(h)
        [outmatrix,freq] = extract(h,outtype,z0)
        nport = getnport(h)
    end  % method signatures
    
    % definitions for rf.internal.netparams.Interface
    properties(Constant,Hidden)
        NetworkParameterNarginchkInputs = [1 1]
    end
    
    methods(Access = protected)
        function [str,data,freq,z0] = networkParameterInfo(obj,varargin)
            validateattributes(obj.Freq,{'numeric'},{'nonempty'}, ...
                '','Freq')
            validateattributes(obj.Data,{'numeric'},{'nonempty'}, ...
                '','Data field')
            
            str = obj.Type(1);
            data = obj.Data;
            freq = obj.Freq;
            z0 = obj.Z0;
        end
    end
end  % classdef