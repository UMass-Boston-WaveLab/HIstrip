classdef nport < rf.internal.rfbudget.Element
%NPORT Create a Linear N-port Circuit Element
%
%The NPORT function creates an nport object (defined by N-port
%S-parameters) that can be added into an RF Toolbox circuit.
%
%   OBJ = NPORT(FILENAME) creates an NPORT object OBJ from the file
%   specified by FILENAME.  FILENAME must describe a Touchstone (*.snp,
%   *.ynp, etc) file. If the file stores the data in some other type (Y, Z,
%   etc...) then the data will be converted to S-parameters.
%
%   OBJ = NPORT(SPARAM_OBJ) creates an NPORT object from an sparameters
%   data object.
%
%PROPERTIES:
%   NumPorts - The number of ports of the object.
%
%   NetworkData - The linear S-parameter data that defines the NPORT
%   object.
%
%   Name - The name of the NPORT object (Default = 'sparams').
%
%   NumPorts - The number of ports the NPORT object has.
%
%   Terminals - A cell vector containing the names of the terminals of the
%   NPORT object.  There are two terminals per port.  The positive terminal
%   names are listed first ('p1+', 'p2+', ...) followed by the negative
%   terminal names ('p1-', 'p2-', ...).
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the NPORT.  Note
%   that "ParentNodes" is only displayed after the NPORT has been added
%   into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   NPORT belongs to. Note that "ParentPath" is only displayed after the
%   NPORT has been added into a circuit.
%
%EXAMPLES:
%   % Create an NPORT object using the data in 'passive.s2p' and display it
%   Npass = nport('passive.s2p');
%   disp(Npass)
%
%   % Add "Npass" to a circuit between nodes 1 and 2 and display it
%   ckt = circuit('example');
%   add(ckt,[1 2],Npass)
%   disp(Npass)
%
% See also sparameters, circuit, circuit/add, lcladder
    
    properties
        NetworkData
    end
    
    properties (SetObservable, Hidden, Dependent)
        FileName % for exportRFBlockset into S-parameters block
    end
    
    properties (Access = {?nport,?rf.internal.apps.budget.S2PFile})
        PrivateFileName = '';
    end
    
    properties (Hidden)
        NoiseData = []
    end
    
    properties (Constant, Access = protected)
        HeaderDescription = 'N-port'
        DefaultName = 'Sparams'
    end
    
    % constructor
    methods
        function obj = nport(varargin)
            narginchk(1,2)
            % This is the only call to Element with args
            obj@rf.internal.rfbudget.Element(varargin{:}) % sets Name
            if nargin >= 1 && ischar(varargin{1})
                obj.FileName = varargin{1};
            end
            
            % If first argument isn't a filename, assume it's network data
            if ~ischar(varargin{1})
                obj.NetworkData = varargin{1};
            end
        end
    end
    
    % set
    methods
        function set.NetworkData(obj,newNetData)
            % Validate type and size
            validateattributes(newNetData, ...
                {'sparameters','yparameters','zparameters', ...
                'tparameters','abcdparameters','hparameters', ...
                'gparameters'},{'scalar'},'','NetworkData')
            
            % If in a circuit already, cannot change NumPorts
            if ~isempty(obj.Parent) && obj.NumPorts ~= newNetData.NumPorts
                error(message('rf:shared:NPortCannotChangeNumPorts'))
            end
            
            if isa(newNetData,'sparameters')
                obj.NetworkData = newNetData;
            else
                obj.NetworkData = sparameters(newNetData);
            end
            if isempty(obj.Parent)
                updateTerminalsAndPorts(obj)
            end
        end
        
        function set.FileName(obj,value)
            validateattributes(value,{'char'},{'nonempty','row'},'','FileName')
            % read Touchstone like rf.internal.netparams.AllParameters
            tf = readRFFile(sparameters(1,1),value); % Hidden method
            obj.NetworkData = sparameters(tf);
            obj.NoiseData = rf.internal.NoiseParameters(tf);
            obj.PrivateFileName = value;
        end
        
        function value = get.FileName(obj)
            value = obj.PrivateFileName;
        end
    end
    
    % utility
    methods(Access = private)
        function updateTerminalsAndPorts(obj)
            % Update Terminal and Port names from NetworkData
            % Must be called only after NetworkData is set
            numports = obj.NetworkData.NumPorts;
            p = cell(1,numports);
            t = cell(1,2*numports);
            for n = 1:numports
                p{n} = sprintf('p%d',n);
                t{n} = sprintf('%s+',p{n});
                t{n+numports} = sprintf('%s-',p{n});
            end
            obj.Ports = p;
            obj.Terminals = t;
        end
    end
    
    methods (Hidden)
        function exportScript(obj,sw,vn)
            if strcmp(obj.Name,obj.DefaultName)
                addcr(sw,'%s = %s(''%s'');',vn,class(obj),obj.FileName)
            else
                addcr(sw,'%s = %s(''%s'',''%s'');', ...
                    vn,class(obj),obj.FileName,obj.Name)
            end
        end
    end
    
    % Abstract from rf.internal.rfbudget.Element
    
    methods (Hidden)
        function Ca = getCa(obj,freq,stageS)
            z0 = stageS.Impedance;
            if ~isempty(obj.NoiseData) && ...
                    ~isempty(obj.NoiseData.Frequencies)
                % Calculate noise correlation matrix at frequency freq.
                nd = obj.NoiseData;
                Fm = 10.^(nd.interpolate(nd.Frequencies,nd.Fmin,freq)/10);
                gammaopt = ...
                    nd.interpolate(nd.Frequencies,nd.GammaOpt,freq);
                Rn = z0 * nd.interpolate(nd.Frequencies,nd.Rn,freq);
                y0 = (1-gammaopt) ./ (1+gammaopt) / z0;
                Ca = 2*rfbudget.kT*[Rn, (Fm-1)/2-Rn*conj(y0);
                    (Fm-1)/2-Rn*y0, Rn*abs(y0)^2];
            elseif ispassive(stageS)
                % There's no noise data.  If the S-parameters are passive,
                % calculate the Ca from first principles.
                % xxx only tested passivity at a slice
                S = stageS.Parameters;
                Cs = rfbudget.kT*(eye(2)-S*S');
                PR = [S(1,1)-1, z0*(1+S(1,1)); S(2,1), z0*S(2,1)];
                Ca = 2*z0 * (PR \ Cs / PR'); % (7.34) Dobrowolski
            else
                Ca = zeros(2,2);
            end
        end
        
        function gain = getGain(obj,stageS) %#ok<INUSL>
            % return the Available Power Gain determined by the S slice
            S = stageS.Parameters;
            gain = 10*log10(abs(S(2,1))^2/(1-abs(S(2,2))^2));
        end
        
        function NF = getNF(obj,Ca) %#ok<INUSL>
            % Compute NF from the noise correlation matrix Ca. Note that NF
            % is independent of matching since noise is part of a signal
            % and attenuates with the signal.
            z0 = 50; % NF computed for source impedance of 50
            zvect = [1;z0];
            denomZ = 2*rfbudget.kT*z0;
            NF = 10*log10(1+real(zvect'*Ca*zvect)/denomZ);
        end
        
        function OIP3 = getOIP3(obj) %#ok<MANU>
            OIP3 = Inf;
        end
    end
    
    methods (Access = protected)
        function h = rbBlock(obj,sys,x,y,rconn,~)
            src = 'simrfV2elements/S-parameters';
            h = add_block(obj,src,sys,x,y);
            file = obj.FileName;
            set(h, ...
                'File',file, ...
                'SparamRepresentation','Time domain (rationalfit)', ...
                'AddNoise','on') % start with 'Simulate noise' turned on
            
            ph = get(h,'PortHandles');
            add_line(sys,rconn,ph.LConn(1),'autorouting','on')
        end
    end
    
    % Abstract from rf.internal.circuit.Element
    
    methods (Hidden, Access = protected)
        function initializeTerminalsAndPorts(obj)
            obj.Terminals = {};
        end
        
        function plist1 = getLocalPropertyList(obj)
            plist1.NetworkData = obj.NetworkData;
        end
        
        function outobj = localClone(inobj)
            outobj = nport(inobj.NetworkData);
            outobj.PrivateFileName = inobj.PrivateFileName;
            outobj.NoiseData = inobj.NoiseData;
        end
    end
end