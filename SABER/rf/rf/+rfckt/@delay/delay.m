classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        delay < rfckt.rfckt
%rfckt.delay class
%   rfckt.delay extends rfckt.rfckt.
%
%    rfckt.delay properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       Z0 - Property is of type 'MATLAB array' 
%       Loss - Property is of type 'MATLAB array' 
%       TimeDelay - Property is of type 'MATLAB array' 
%
%    rfckt.delay methods:
%       calckl - H, FREQ) return e^(-k)
%       nwa - Calculate the network parameters.


    properties
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplex(obj,value,'Z0',false);
            end
        end
    end   % set and get functions for Z0

    properties
        %LOSS Property is of type 'MATLAB array' 
        Loss = 0;
    end
    methods 
        function set.Loss(obj,value)
            if ~isequal(obj.Loss,value)
                % DataType = 'MATLAB array'
                obj.Loss = setpositive(obj,value,'Loss',true,false,false);
            end
        end
    end   % set and get functions for Loss

    properties
        %TIMEDELAY Property is of type 'MATLAB array' 
        TimeDelay = 1e-12;
    end
    methods 
        function set.TimeDelay(obj,value)
            if ~isequal(obj.TimeDelay,value)
                % DataType = 'MATLAB array'
                obj.TimeDelay = setpositive(obj,value,'TimeDelay',      ...
                    true,false,false);
            end
        end
    end   % set and get functions for TimeDelay


    methods  % constructor block
        function h = delay(varargin)
        %DELAY Constructor.
        %   H = RFCKT.DELAY('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a delay line object, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing 
        %   'h = rfckt.delay'. 
        %
        %   A delay line object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is generated during
        %                    analysis (read only)
        %   Z0             - Characteristic impedance (ohms)
        %   Loss           - Line loss (dB)
        %   TimeDelay      - Time delay (s)
        %
        %   rfckt.delay methods:   
        %
        %     Analysis
        %       analyze    - Analyze an RFCKT object in frequency domain
        %
        %     Plots and Charts   
        %       circle     - Draw circles on a Smith chart
        %       loglog     - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scales for both the
        %                    X- and Y- axes
        %       plot       - Plot the specified parameters on the X-Y plane
        %       plotyy     - Plot the specified parameters on the X-Y plane
        %                    with y tick labels on the left and right
        %       polar      - Plot the specified parameters on a
        %                    polar plane chart
        %       semilogx   - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scale for the X-axis
        %       semilogy   - Plot the specified parameters on the X-Y plane
        %                    with logarithmic scale for the Y-axis
        %       smith      - Plot the specified parameters on a Smith chart
        %       table      - Display the specified parameters in a table
        %
        %     Parameters and Formats   
        %       listformat - List the valid formats for a parameter
        %       listparam  - List the valid parameters that can be
        %                    visualized
        %
        %     Data Access and Restoration  
        %       calculate  - Calculate the specified parameters
        %       extract    - Extract the specified network parameters  
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.delay/<METHOD>', where METHOD is one of the methods
        %   listed above. For instance, 'help rfckt.delay/plot'.
        %
        %   Example:
        %
        %      % Create a delay line
        %        h = rfckt.delay('TimeDelay',1e-11)
        %      % Do frequency domain analysis at the given frequency
        %        f = .9e9:1e8:3e9;             % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % List valid parameters and formats for visualization
        %        listparam(h)            
        %        listformat(h, 'S21') 
        %      % Visualize the analyzed results
        %        figure(1)
        %        plot(h, 'S21', 'Angle');      % Plot S21 in Angle on the
        %                                        X-Y plane
        %
        %   See also RFCKT, RFCKT.TXLINE, RFCKT.RLCGLINE, RFDATA 
        
        %   Copyright 2004-2010 The MathWorks, Inc.

        %UDD % h = rfckt.delay;
        set(h, 'Name', 'Delay Line');
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % delay
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        [type,netparameters,z0] = nwa(h,freq)
    end  % method signatures

    methods
        function checkproperty(h)  % Turns class from abstract to concrete
        end
    end

end  % classdef