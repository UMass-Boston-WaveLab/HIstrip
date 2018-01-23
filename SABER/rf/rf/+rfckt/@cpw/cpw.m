classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        cpw < rfckt.basetxline
%rfckt.cpw class
%   rfckt.cpw extends rfckt.basetxline.
%
%    rfckt.cpw properties:
%       Name - Property is of type 'string' (read only)
%       nPort - Property is of type 'int32' (read only)
%       AnalyzedResult - Property is of type 'handle' (read only)
%       LineLength - Property is of type 'MATLAB array' 
%       StubMode - Property is of type 'StubModeTypeDATATYPE enumeration:
%                  {'NotAStub','Series','Shunt','None'}' 
%       Termination - Property is of type 'TerminationTypeDATATYPE
%                     enumeration: {'NotApplicable','Open','Short','None'}' 
%       ConductorWidth - Property is of type 'MATLAB array' 
%       SlotWidth - Property is of type 'MATLAB array' 
%       Height - Property is of type 'MATLAB array' 
%       Thickness - Property is of type 'MATLAB array' 
%       EpsilonR - Property is of type 'MATLAB array' 
%       LossTangent - Property is of type 'MATLAB array' 
%       SigmaCond - Property is of type 'MATLAB array' 
%
%    rfckt.cpw methods:
%       calckl - H, FREQ) return e^(-kl)
%       checkproperty - Check the properties of the object.


    properties
        %CONDUCTORWIDTH Property is of type 'MATLAB array' 
        ConductorWidth = 0.6e-3;
    end
    methods 
        function set.ConductorWidth(obj,value)
            if ~isequal(obj.ConductorWidth,value)
                % DataType = 'MATLAB array'
                obj.ConductorWidth = setpositive(obj,value,             ...
                    'ConductorWidth',false,false,false);
            end
        end
    end   % set and get functions for ConductorWidth

    properties
        %SLOTWIDTH Property is of type 'MATLAB array' 
        SlotWidth = 0.2e-3;
    end
    methods 
        function set.SlotWidth(obj,value)
            if ~isequal(obj.SlotWidth,value)
                % DataType = 'MATLAB array'
                obj.SlotWidth = setpositive(obj,value,'SlotWidth',      ...
                    false,false,false);
            end
        end
    end   % set and get functions for SlotWidth

    properties
        %HEIGHT Property is of type 'MATLAB array' 
        Height = 0.635e-3;
    end
    methods 
        function set.Height(obj,value)
            if ~isequal(obj.Height,value)
                % DataType = 'MATLAB array'
                obj.Height = setpositive(obj,value,'Height',            ...
                    false,false,false);
            end
        end
    end   % set and get functions for Height

    properties
        %THICKNESS Property is of type 'MATLAB array' 
        Thickness = 0.005e-3;
    end
    methods 
        function set.Thickness(obj,value)
            if ~isequal(obj.Thickness,value)
                % DataType = 'MATLAB array'
                obj.Thickness = setpositive(obj,value,'Thickness',      ...
                    false,false,false);
            end
        end
    end   % set and get functions for Thickness

    properties
        %EPSILONR Property is of type 'MATLAB array' 
        EpsilonR = 9.8;
    end
    methods 
        function set.EpsilonR(obj,value)
            if ~isequal(obj.EpsilonR,value)
                % DataType = 'MATLAB array'
                obj.EpsilonR = seter(obj,value,'EpsilonR',              ...
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


    methods  % constructor block
        function h = cpw(varargin)
        %CPW Constructor.
        %   H = RFCKT.CPW('PROPERTY1', VALUE1, 'PROPERTY2', VALUE2, ...)
        %   returns a CPW transmission line object, H, based on the
        %   properties specified by the input arguments in the
        %   PROPERTY/VALUE pairs. Any properties you do not specify retain
        %   their default values, which can be viewed by typing
        %   'h = rfckt.cpw'. 
        %
        %   A CPW object has the following properties. All the properties
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
        %   ConductorWidth - Conductor strip width (m)
        %   SlotWidth      - Slot width (m)
        %   Height         - Substrate height (m)
        %   Thickness      - Conductor strip thickness (m)
        %   EpsilonR       - Relative permittivity constant
        %   LossTangent    - Loss tangent of dielectric
        %   SigmaCond      - Conductivity of conductor (S/m)
        %
        %   rfckt.cpw methods:   
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
        %       semilogx   - Plot the specified parameters on the X-Y
        %                    plane with logarithmic scale for the X-axis
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
        %   'help rfckt.cpw/<METHOD>', where METHOD is one of the methods
        %   listed above. For instance, 'help rfckt.cpw/plot'.
        %
        %   Example:
        %
        %      % Create a CPW transmission line
        %        h = rfckt.cpw('Thickness',0.0075e-6)
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
        %   RFCKT.PARALLELPLATE, RFCKT.COAXIAL, RFCKT.MICROSTRIP, RFDATA 
        
        %   Copyright 2003-2010 The MathWorks, Inc.
        
        %UDD % h = rfckt.cpw;
        set(h, 'Name', 'Coplanar Waveguide Transmission Line');
        
        % Check the read only properties
        checkreadonlyproperty(h, varargin, {'Name', 'nPort', 'RFdata',  ...
            'AnalyzedResult', 'Z0', 'PV', 'Loss'});
        
        % Set the values for the properties
        if nargin    % If nargin is zero, next statement will print
            set(h, varargin{:});
        end
        checkproperty(h);
        end   % cpw
        
    end  % constructor block

    methods  % method signatures
        y = calckl(h,freq)
        checkproperty(h)
    end  % method signatures

end  % classdef


function out = seter(h, out, prop_name, incZero, incInf, incEmpty)
%SETER Set function for the relative permittivity constant.

out = setpositive(h, out, prop_name, incZero, incInf, incEmpty);

if (out <= 1)
    if isempty(h.Block)
        rferrhole = [h.Name, ': ', prop_name];
    else
        rferrhole = prop_name;
    end
    error(message('rf:rfckt:cpw:seter:LessThanOne', rferrhole));
end
end   % seter