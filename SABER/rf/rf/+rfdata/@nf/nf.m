classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        nf < rfdata.rfdata
%rfdata.nf class
%   rfdata.nf extends rfdata.rfdata.
%
%    rfdata.nf properties:
%       Name - Property is of type 'string' (read only)
%       Freq - Property is of type 'MATLAB array' 
%       Data - Property is of type 'MATLAB array' 
%
%    rfdata.nf methods:
%       checkproperty - Check the properties of the object.


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
        Data = 0;
    end
    methods 
        function set.Data(obj,value)
            if ~isequal(obj.Data,value)
                % DataType = 'MATLAB array'
                obj.Data = setnoisefigure(obj,value,'Data',true);
            end
        end
    end   % set and get functions for Data

    properties (Hidden)
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplex(obj,value,'Z0',false,true,false);
            end
        end
    end   % set and get functions for Z0


    methods  % constructor block
        function h = nf(varargin)
        %NF Data Object Constructor.
        %   H = RFDATA.NF('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a data object for the frequency-dependent noise figure,
        %   H, based on the properties specified by the input arguments in
        %   the PROPERTY/VALUE pairs. Any properties you do not specify
        %   retain their default values, which can be viewed by typing
        %   'h = rfdata.nf'. 
        % 
        %   A NF data object has the following properties. All the
        %   properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Freq           - Frequency (Hz)
        %   Data           - Frequency-dependent noise figure (dB)
        % 
        %   Example:
        %
        %      % Create a NF data object
        %        h = rfdata.nf('Freq', 2.1e9, 'Data', 13.3244)
        %
        %   See also RFDATA, RFDATA.NOISE, RFDATA.NETWORK, RFDATA.POWER,
        %   RFDATA.IP3, RFDATA.P2D, RFCKT
        
        %   Copyright 2004-2007 The MathWorks, Inc.
        
        % Create an RFDATA.NF object
        
        %UDD % h = rfdata.nf;
        set(h, 'Name', 'Noise figure');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % nf
        
    end  % constructor block

    methods  % method signatures
        checkproperty(h)
    end  % method signatures

end  % classdef