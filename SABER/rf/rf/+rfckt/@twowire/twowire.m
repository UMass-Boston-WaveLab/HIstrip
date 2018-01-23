classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        twowire < rfckt.basetxline
%rfckt.twowire class
%   rfckt.twowire extends rfckt.basetxline.
%
%    rfckt.twowire properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property is of type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%       Radius - Property is of type 'MATLAB array' 
%       Separation - Property is of type 'MATLAB array' 
%       MuR - Property is of type 'MATLAB array' 
%       EpsilonR - Property is of type 'MATLAB array' 
%       LossTangent - Property is of type 'MATLAB array' 
%       SigmaCond - Property is of type 'MATLAB array' 
%
%    rfckt.twowire methods:
%       calckl - H, FREQ) returns e^(-kl)
%       checkproperty - Check the properties of the object.


    properties
        %RADIUS Property is of type 'MATLAB array' 
        Radius = 0.67e-3;
    end
    methods 
        function set.Radius(obj,value)
            if ~isequal(obj.Radius,value)
                % DataType = 'MATLAB array'
                obj.Radius = setpositive(obj,value,'Radius',            ...
                    false,false,false);
            end
        end
    end   % set and get functions for Radius

    properties
        %SEPARATION Property is of type 'MATLAB array' 
        Separation = 1.62e-3;
    end
    methods 
        function set.Separation(obj,value)
            if ~isequal(obj.Separation,value)
                % DataType = 'MATLAB array'
                obj.Separation = setpositive(obj,value,'Separation',    ...
                    false,false,false);
            end
        end
    end   % set and get functions for Separation

    properties
        %MUR Property is of type 'MATLAB array' 
        MuR = 1;
    end
    methods 
        function set.MuR(obj,value)
            if ~isequal(obj.MuR,value)
                % DataType = 'MATLAB array'
                obj.MuR = setpositive(obj,value,'MuR',                  ...
                    false,false,false);
            end
        end
    end   % set and get functions for MuR

    properties
        %EPSILONR Property is of type 'MATLAB array' 
        EpsilonR = 2.3;
    end
    methods 
        function set.EpsilonR(obj,value)
            if ~isequal(obj.EpsilonR,value)
                % DataType = 'MATLAB array'
                obj.EpsilonR = setpositive(obj,value,'EpsilonR',        ...
                    false,false,false);
            end
        end
    end   % set and get functions for EpsilonR

    properties
        %LOSSTANGENT Property is of type 'MATLAB array' 
        LossTangent = 0;
    end
    methods 
        function set.LossTangent(obj,value)
            if ~isequal(obj.LossTangent,value)
                % DataType = 'MATLAB array'
                obj.LossTangent = setpositive(obj,value,'LossTangent',  ...
                    true,false,false);
            end
        end
    end   % set and get functions for LossTangent

    properties
        %SIGMACOND Property is of type 'MATLAB array' 
        SigmaCond = inf;
    end
    methods 
        function set.SigmaCond(obj,value)
            if ~isequal(obj.SigmaCond,value)
                % DataType = 'MATLAB array'
                obj.SigmaCond = setpositive(obj,value,'SigmaCond',      ...
                    false,true,false);
            end
        end
    end   % set and get functions for SigmaCond

    properties (Hidden)
        %SIGMADIEL Property is of type 'MATLAB array' 
        SigmaDiel = 0;
    end
    methods 
        function set.SigmaDiel(obj,value)
            if ~isequal(obj.SigmaDiel,value)
                % DataType = 'MATLAB array'
                obj.SigmaDiel = setsigmadiel(obj,value,'SigmaDiel');
            end
        end
    end   % set and get functions for SigmaDiel

    properties (Hidden)
        %ISSUEWARNINGFORNONZEROSIGMADIEL Property is of type 'bool' 
        IssueWarningforNonzeroSigmaDiel = true;
    end


    methods  % constructor block
        function h = twowire(varargin)
        %TWOWIRE Constructor.
        %   H = RFCKT.TWOWIRE('PROPERTY1', VALUE1, 'PROPERTY2',         ...
        %       VALUE2, ...)
        %   returns a two-wire transmission line object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.twowire'. 
        %
        %   A two-wire object has the following properties. All the
        %   properties are writable except for the ones explicitly noted
        %   otherwise.
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
        %   Radius         - Wire radius (m)
        %   Separation     - Wire separation (m)
        %   MuR            - Relative permeability constant
        %   EpsilonR       - Relative permittivity constant
        %   LossTangent    - Loss tangent of dielectric
        %   SigmaCond      - Conductivity of conductor (S/m)
        %
        %   rfckt.twowire methods:   
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
        %   'help rfckt.twowire/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.twowire/plot'.
        %
        %   Example:
        %
        %     % Create a two-wire transmission line
        %       h = rfckt.twowire('StubMode','Series','Termination','Open')
        %     % Do frequency domain analysis at the given frequency
        %       f = .9e9:1e8:3e9;             % Simulation frequency
        %       analyze(h,f);                 % Do frequency domain
        %                                       analysis
        %     % List valid parameters and formats for visualization
        %       listparam(h)       
        %       listformat(h, 'S21') 
        %     % Get the txline characteristic impedance
        %       z0 = getz0(h)
        %     % Plot GAMMAIN on a ZY Smith chart
        %       figure(1)
        %       smith(h, 'GammaIN', 'zy'); 
        %     % Plot phase of S21 and group delay
        %       figure(2)
        %       plotyy(h, 'S21', 'Angle', 'GroupDelay', 'ns'); 
        %
        %   See also RFCKT, RFCKT.TXLINE, RFCKT.RLCGLINE,
        %   RFCKT.PARALLELPLATE, RFCKT.CPW, RFCKT.COAXIAL,
        %   RFCKT.MICROSTRIP, RFDATA 
        
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.twowire;
        set(h, 'Name', 'Two-Wire Transmission Line');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult', 'Z0', 'PV', 'Loss'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % twowire
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        checkproperty(h)
    end  % method signatures

end  % classdef