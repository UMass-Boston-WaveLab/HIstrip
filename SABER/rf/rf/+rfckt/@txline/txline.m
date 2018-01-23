classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        txline < rfckt.rfckt
%rfckt.txline class
%   rfckt.txline extends rfckt.rfckt.
%
%    rfckt.txline properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property is of type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%       Freq - Property is of type 'MATLAB array' 
%       Z0 - Property is of type 'MATLAB array' 
%       PV - Property is of type 'MATLAB array' 
%       Loss - Property is of type 'MATLAB array' 
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%
%    rfckt.txline methods:
%       calckl - H, FREQ) return e^(-kl)
%       calczin - Z_IN = CALCZIN(H, FREQ, ZTERM) calculate the input
%                 impedance of a
%       checkproperty - Check the properties of the object.
%       getz0 - Get characteristic impedance
%       nwa - Calculate the network parameters.


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
            enum_list = {'NotAStub','Series','Shunt','None'};
            alias_list = {'NotAStub', 'None'};
            obj.StubMode = checkenum(obj, 'StubMode', value,            ...
                enum_list, alias_list);
         end
    end   % set function for StubMode

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

    properties
        %FREQ Property is of type 'MATLAB array' 
        Freq = 1.0e9;
    end
    methods 
        function set.Freq(obj,value)
            if ~isequal(obj.Freq,value)
                % DataType = 'MATLAB array'
                obj.Freq = setpositivevector(obj,value,'Freq',          ...
                    true,false,true);
            end
        end
    end   % set and get functions for Freq

    properties
        %Z0 Property is of type 'MATLAB array' 
        Z0 = complex(50,0);
    end
    methods 
        function set.Z0(obj,value)
            if ~isequal(obj.Z0,value)
                % DataType = 'MATLAB array'
                obj.Z0 = setcomplexvector(obj,value,'Z0',false);
            end
        end
    end   % set and get functions for Z0

    properties
        %PV Property is of type 'MATLAB array' 
        PV = 299792458;
    end
    methods 
        function set.PV(obj,value)
            if ~isequal(obj.PV,value)
                % DataType = 'MATLAB array'
                obj.PV = setpositivevector(obj,value,'PV',              ...
                    false,false,false);
            end
        end
    end   % set and get functions for PV

    properties
        %LOSS Property is of type 'MATLAB array' 
        Loss = 0;
    end
    methods 
        function set.Loss(obj,value)
            if ~isequal(obj.Loss,value)
                % DataType = 'MATLAB array'
                obj.Loss = setpositivevector(obj,value,'Loss',          ...
                    true,false,false);
            end
        end
    end   % set and get functions for Loss

    properties
        % INTPTYPE Property is of type 'InterpolationMethodDATATYPE
        % enumeration: {'Linear','Cubic','Spline'}' 
        IntpType = 'Linear';
    end
    methods 
        function set.IntpType(obj,value)
            enum_list = {'Linear','Cubic','Spline'};
            obj.IntpType = checkenum(obj, 'IntpType', value, enum_list);
         end
    end   % set function for IntpType

    methods  % constructor block
        function h = txline(varargin)
        %TXLINE Constructor.
        %   H = RFCKT.TXLINE('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a transmission line object, H, based on the properties
        %   specified by the input arguments in the PROPERTY/VALUE pairs.
        %   Any properties you do not specify retain their default values,
        %   which can be viewed by typing 'h = rfckt.txline'. 
        %
        %   A txline object has the following properties. All the
        %   properties are writable except for the ones explicitly
        %   noted otherwise.
        %
        %   Property Name    Description
        %   ---------------------------------------------------------------
        %   Name           - Object name. (read only)
        %   nPort          - Number of ports. (read only)
        %   AnalyzedResult - Analyzed result. It is generated during
        %                    analysis (read only)
        %   LineLength     - Line length (m)
        %   StubMode       - 'NotAStub', 'Series' or 'Shunt'
        %   Termination    - 'NotApplicable', 'Open' or 'Short'
        %   Freq           - Frequency (Hz)
        %   Z0             - Frequency-dependent characteristic
        %                    impedance (ohms)
        %   PV             - Frequency-dependent phase velocity (m/sec)
        %   Loss           - Frequency-dependent line loss (dB/m)
        %   IntpType       - Interpolation method. The choices are:
        %                    'Linear', 'Cubic' or 'Spline' 
        % 
        %   rfckt.txline methods:   
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
        %       getz0      - Get the characteristic impedance of
        %                    transmission line object
        %       extract    - Extract the specified network parameters  
        %
        %   To get detailed help on a method from the command line, type
        %   'help rfckt.txline/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.txline/plot'.
        %
        %   Example:
        %
        %      % Create a transmission line
        %        h = rfckt.txline('StubMode', 'Series', 'Termination',  ...
        %            'Short')
        %      % Do frequency domain analysis at the given frequency
        %        f = .9e9:1e8:3e9;             % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21') 
        %      % Visualize the analyzed results
        %        figure(1)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a ZY
        %                                        Smith chart
        %
        %   See also RFCKT, RFCKT.RLCGLINE, RFCKT.TWOWIRE,
        %   RFCKT.PARALLELPLATE, RFCKT.COAXIAL, RFCKT.MICROSTRIP,
        %   RFCKT.CPW, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.txline;
        set(h, 'Name', 'Transmission Line');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % txline
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        Z_in = calczin(h,freq,zterm)
        checkproperty(h)
        z0 = getz0(h)
        [type,netparameters,z0] = nwa(h,freq)
    end  % method signatures

end  % classdef