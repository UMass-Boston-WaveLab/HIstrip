classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        noise < rfdata.rfdata
%rfdata.noise class
%   rfdata.noise extends rfdata.rfdata.
%
%    rfdata.noise properties:
%       Name - Property is of type 'string' (read only)
%       Freq - Property is of type 'MATLAB array' 
%       Fmin - Property is of type 'MATLAB array' 
%       GammaOPT - Property is of type 'MATLAB array' 
%       RN - Property is of type 'MATLAB array' 
%
%    rfdata.noise methods:
%       calculate - Calculate the required power parameter.
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
        %FMIN Property is of type 'MATLAB array' 
        Fmin = 0;
    end
    methods 
        function set.Fmin(obj,value)
            if ~isequal(obj.Fmin,value)
                % DataType = 'MATLAB array'
                obj.Fmin = setnoisefigure(obj,value,'Fmin',true);
            end
        end
    end   % set and get functions for Fmin

    properties
        %GAMMAOPT Property is of type 'MATLAB array' 
        GammaOPT = 1;
    end
    methods 
        function set.GammaOPT(obj,value)
            if ~isequal(obj.GammaOPT,value)
                % DataType = 'MATLAB array'
                obj.GammaOPT = setcomplexvector(obj,value,              ...
                    'GammaOPT',false);
            end
        end
    end   % set and get functions for GammaOPT

    properties
        %RN Property is of type 'MATLAB array' 
        RN = 1;
    end
    methods 
        function set.RN(obj,value)
            if ~isequal(obj.RN,value)
                % DataType = 'MATLAB array'
                obj.RN = setpositivevector(obj,value,'RN',              ...
                    true,true,false);
            end
        end
    end   % set and get functions for RN

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
        function h = noise(varargin)
        %NOISE Data Object Constructor.
        %   H = RFDATA.NOISE('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a data object for the frequency-dependent spot noise
        %   data, H, based on the properties specified by the input
        %   arguments in the PROPERTY/VALUE pairs. Any properties you do
        %   not specify retain their default values, which can be viewed by
        %   typing 'h = rfdata.noise'. 
        % 
        %   A NOISE data object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   Freq           - Frequency (Hz)
        %   FMIN           - Frequency-dependent minimum noise figure (dB)
        %   GAMMAOPT       - Frequency-dependent source reflection
        %                    coefficient to realize minimum noise figure
        %   RN             - Frequency-dependent normalized effective noise
        %                    resistance
        % 
        %   Example:
        %
        %      % Create a NOISE data object
        %        f = [2.08 2.10]*1.0e9;
        %        fmin = [12.08 13.40];
        %        gopt = [0.2484-1.2102j 1.0999-0.9295j];
        %        rn = [0.26 0.45];
        %        h = rfdata.noise('Freq', f, 'FMIN', fmin, 'GAMMAOPT',  ...
        %            gopt, 'RN', rn)
        %
        %   See also RFDATA, RFDATA.NF, RFDATA.NETWORK, RFDATA.POWER,
        %   RFDATA.IP3, RFDATA.P2D, RFCKT
          
        %   Copyright 2003-2007 The MathWorks, Inc.
        
        
        % Create an RFDATA.NOISE object

        %UDD % h = rfdata.noise;
        set(h, 'Name', 'Spot noise data');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, 'Name');
        
        % Update the properties using the user-specified values
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % noise
        
    end  % constructor block

    methods  % method signatures
        [data,param,freq] = calculate(h,parameter,freq)
        checkproperty(h)
    end  % method signatures

end  % classdef