classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rlcgline < rfckt.basetxline
%rfckt.rlcgline class
%   rfckt.rlcgline extends rfckt.basetxline.
%
%    rfckt.rlcgline properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property is of type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%       Freq - Property is of type 'MATLAB array' 
%       R - Property is of type 'MATLAB array' 
%       L - Property is of type 'MATLAB array' 
%       C - Property is of type 'MATLAB array' 
%       G - Property is of type 'MATLAB array' 
%       IntpType - Property is of type 'InterpolationMethodDATATYPE
%                  enumeration: {'Linear','Cubic','Spline'}' 
%
%    rfckt.rlcgline methods:
%       calckl - H, FREQ) returns e^(-kl)
%       checkproperty - Check the properties of the object.
%       read - Read passive network parameters from a Touchstone data file.


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
        %R Property is of type 'MATLAB array' 
        R = 0;
    end
    methods 
        function set.R(obj,value)
            if ~isequal(obj.R,value)
                % DataType = 'MATLAB array'
                obj.R = setpositivevector(obj,value,'R',true,false,false);
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
                obj.L = setpositivevector(obj,value,'L',true,false,false);
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
                obj.C = setpositivevector(obj,value,'C',true,false,false);
            end
        end
    end   % set and get functions for C

    properties
        %G Property is of type 'MATLAB array' 
        G = 0;
    end
    methods 
        function set.G(obj,value)
            if ~isequal(obj.G,value)
                % DataType = 'MATLAB array'
                obj.G = setpositivevector(obj,value,'G',true,false,false);
            end
        end
    end   % set and get functions for G

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
        function h = rlcgline(varargin)
        %RLCGLINE Constructor.
        %   H = RFCKT.RLCGLINE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2, ...)
        %   returns an RLCG transmission line object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.rlcgline'. 
        %
        %   An RLCG object has the following properties. All the properties
        %   are writable except for the ones explicitly noted otherwise.
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
        %   R              - Frequency-dependent resistance per
        %                    length (ohms/m)
        %   L              - Frequency-dependent inductance per
        %                    length (henries/m)
        %   C              - Frequency-dependent capacitance per
        %                    length (farads/m)
        %   G              - Frequency-dependent conductance per
        %                    length (siemens/m)
        %   IntpType       - Interpolation method. The choices are:
        %                    'Linear', 'Cubic' or 'Spline' 
        % 
        %   rfckt.rlcgline methods:   
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
        %   'help rfckt.rlcgline/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.rlcgline/plot'.
        %
        %   Example:
        %
        %      % Create an RLCG transmission line
        %        h = rfckt.rlcgline('R', 0.002,'C', 8.8542e-012, 'L',   ...
        %            1.2566e-006, 'G', 0.002')
        %      % Do frequency domain analysis at the given frequency
        %        f = .9e9:1e8:3e9;             % Simulation frequency
        %        analyze(h,f);                 % Do frequency domain
        %                                        analysis
        %      % List valid parameters and formats for visualization
        %        listparam(h)       
        %        listformat(h, 'S21') 
        %      % Get the txline characteristic impedance
        %        z0 = getz0(h)
        %      % Visualize the analyzed results
        %        figure(1)
        %        plot(h, 'S21', 'dB');         % Plot S21 in dB on the
        %                                        X-Y plane
        %        figure(2)
        %        smith(h, 'GammaIN', 'zy');    % Plot GAMMAIN on a
        %                                        ZY Smith chart
        %
        %   See also RFCKT, RFCKT.TXLINE, RFCKT.COAXIAL, RFCKT.TWOWIRE,
        %   RFCKT.PARALLELPLATE, RFCKT.MICROSTRIP, RFCKT.CPW, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.rlcgline;
        set(h, 'Name', 'RLCG Transmission Line');

        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult', 'Z0', 'PV', 'Loss'});

        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:})
        end
        checkproperty(h);
        end   % rlcgline
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        checkproperty(h)
        h = read(h,filename)
    end  % method signatures

end  % classdef