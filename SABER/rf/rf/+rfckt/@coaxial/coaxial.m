classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        coaxial < rfckt.basetxline
%rfckt.coaxial class
%   rfckt.coaxial extends rfckt.basetxline.
%
%    rfckt.coaxial properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property is of type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%       OuterRadius - Property is of type 'MATLAB array' 
%       InnerRadius - Property is of type 'MATLAB array' 
%       MuR - Property is of type 'MATLAB array' 
%       EpsilonR - Property is of type 'MATLAB array' 
%       LossTangent - Property is of type 'MATLAB array' 
%       SigmaCond - Property is of type 'MATLAB array' 
%
%    rfckt.coaxial methods:
%       calckl - H, FREQ) returns e^(-kl)
%       checkproperty - Check the properties of the object.


    properties
        %OUTERRADIUS Property is of type 'MATLAB array' 
        OuterRadius = 2.57e-3;
    end
    methods 
        function set.OuterRadius(obj,value)
            if ~isequal(obj.OuterRadius,value)
                % DataType = 'MATLAB array'
                obj.OuterRadius = setpositive(obj,value,'OuterRadius',  ...
                    false,false,false);
            end
        end
    end   % set and get functions for OuterRadius

    properties
        %INNERRADIUS Property is of type 'MATLAB array' 
        InnerRadius = 0.725e-3;
    end
    methods 
        function set.InnerRadius(obj,value)
            if ~isequal(obj.InnerRadius,value)
                % DataType = 'MATLAB array'
                obj.InnerRadius = setpositive(obj,value,'InnerRadius',  ...
                    false,false,false);
            end
        end
    end   % set and get functions for InnerRadius

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
                obj.LossTangent = setpositive(obj,value,'LossTangent'   ...
                    ,true,false,false);
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
        function h = coaxial(varargin)
        %COAXIAL Constructor.
        %   H = RFCKT.COAXIAL('PROPERTY1', VALUE1, 'PROPERTY2',
        %   VALUE2, ...) returns a coaxial transmission line object, H,
        %   based on the properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.coaxial'. 
        %
        %   A coaxial object has the following properties. All the
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
        %   OuterRadius    - Outer radius (m)
        %   InnerRadius    - Inner radius (m)
        %   MuR            - Relative permeability constant
        %   EpsilonR       - Relative permittivity constant
        %   LossTangent    - Loss tangent of dielectric
        %   SigmaCond      - Conductivity of conductor (S/m)
        %
        %   rfckt.coaxial methods:   
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
        %       polar      - Plot the specified parameters on a polar plane
        %                    chart
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
        %   'help rfckt.coaxial/<METHOD>', where METHOD is one of the
        %   methods listed above. For instance, 'help rfckt.coaxial/plot'.
        %
        %   Example:
        %
        %      % Create a coaxial transmission line
        %        h = rfckt.coaxial('OuterRadius', 0.0045)
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
        %   See also RFCKT, RFCKT.TXLINE, RFCKT.RLCGLINE, RFCKT.TWOWIRE,
        %   RFCKT.PARALLELPLATE, RFCKT.MICROSTRIP, RFCKT.CPW, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.

        %UDD % h = rfckt.coaxial;
        set(h, 'Name', 'Coaxial Transmission Line');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult', 'Z0', 'PV', 'Loss'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % coaxial
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        checkproperty(h)
    end  % method signatures

end  % classdef