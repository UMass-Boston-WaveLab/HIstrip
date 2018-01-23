classdef lcladder < rf.internal.circuit.Network
%LCLADDER Create an LC Ladder Object
%   LCOBJ = LCLADDER(TOP,L,C) creates the LC ladder object LCOBJ with a
%   topology specified by the string TOP. The values of the inductors are
%   specified by the numeric vector L, and the values of the capacitors are
%   specified by the numeric vector C.
%
%   LCOBJ = LCLADDER(TOP,L,C,LCNAME) creates an LC ladder object with a
%   name specifed by LCNAME.
%
%PROPERTIES:
%   Topology - The type of LC ladder represented by this object.  Valid
%   values are: 'lowpasspi', 'lowpasstee', 'highpasspi', highpasstee',
%   'bandpaspi', 'bandpasstee', 'bandstoppi', and 'bandstoptee'.
%
%   Inductances - A numeric vector representing the values of the inductors
%   within the LC ladder.
%
%   Capacitances - A numeric vector representing the values of the
%   capacitors within the LC ladder.
%
%   Name - The name of the LC ladder object (Default = 'lcfilt').
%
%   NumPorts - The number of ports (2) the LC ladder object has.
%
%   Terminals - A cell vector containing the names of the terminals of the
%   LC ladder object.  An LC ladder object has four terminals: two
%   terminals associated with the first port ('p1+' and 'p1-') and two
%   terminals associated with the second port ('p2+' and 'p2-')'
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the LC ladder object.
%   Note that "ParentNodes" is only displayed after the LC ladder object
%   has been added into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   LC ladder object belongs to. Note that "ParentPath" is only displayed
%   after the LC ladder object has been added into a circuit.
%
%EXAMPLES:
%   % Create a low-pass pi-network LC ladder object, then calculate and
%   % plot it's S-parameters
%   L = 3.18e-8;
%   C = [6.37e-12 6.37e-12];
%   lpp = lcladder('lowpasspi',L,C);
%
%   freq = 0:1e6:1e9;
%   S = sparameters(lpp,freq);
%   rfplot(S)
%
% See also circuit, resistor, capacitor, inductor, nport, circuit/add
    
    % public
    properties(Dependent,SetAccess = private)
        Topology
    end
    properties(Dependent)
        Inductances
        Capacitances
    end
    
    % infrastructure
    properties(Access = private)
        TopologyObject
    end
    
    % abstract properties from rf.internal.circuit.Network
    properties(Dependent,SetAccess = protected)
        Nodes
        Elements
    end
    properties(Dependent,Hidden,SetAccess = protected)
        TerminalNodes
    end
    
    % abstract properties from rf.internal.circuit.Element
    properties(Constant,Access = protected)
        HeaderDescription = 'LC Ladder'
        DefaultName = 'lcfilt'
    end
    
    % constructor
    methods
        function obj = lcladder(topstr,Lvals,Cvals,varargin)
            narginchk(3,4)
            
            obj@rf.internal.circuit.Network(varargin{:})
            
            validateattributes(topstr,{'char'},{'row'}, ...
                'lcladder','Topology',1)
            switch lower(topstr)
                case 'lowpasspi'
                    topobj = rf.internal.circuit.lc.LowPassPi(Lvals,Cvals);
                case 'lowpasstee'
                    topobj = rf.internal.circuit.lc.LowPassTee(Lvals,Cvals);
                case 'highpasspi'
                    topobj = rf.internal.circuit.lc.HighPassPi(Lvals,Cvals);
                case 'highpasstee'
                    topobj = rf.internal.circuit.lc.HighPassTee(Lvals,Cvals);
                case 'bandpasspi'
                    topobj = rf.internal.circuit.lc.BandPassPi(Lvals,Cvals);
                case 'bandpasstee'
                    topobj = rf.internal.circuit.lc.BandPassTee(Lvals,Cvals);
                case 'bandstoppi'
                    topobj = rf.internal.circuit.lc.BandStopPi(Lvals,Cvals);
                case 'bandstoptee'
                    topobj = rf.internal.circuit.lc.BandStopTee(Lvals,Cvals);
                otherwise
                    % error('''%s'' is not a valid LC Ladder topology',topstr)
                    error(message('rf:shared:LCLadderBadTopology',topstr))
            end
            obj.TopologyObject = topobj;
        end
    end
    
    % set
    methods
        function set.Inductances(obj,newL)
            topobj = obj.TopologyObject;
            topobj.Inductances = newL;
        end
        
        function set.Capacitances(obj,newC)
            topobj = obj.TopologyObject;
            topobj.Capacitances = newC;
        end
    end
    
    % get
    methods
        function topstr = get.Topology(obj)
            topstr = obj.TopologyObject.TopologyString;
        end
        
        function L = get.Inductances(obj)
            L = obj.TopologyObject.Inductances;
        end
        
        function C = get.Capacitances(obj)
            C = obj.TopologyObject.Capacitances;
        end
        
        function nodes = get.Nodes(obj)
            ckt = obj.TopologyObject.LadderCircuit;
            nodes = ckt.Nodes;
        end
        
        function elems = get.Elements(obj)
            ckt = obj.TopologyObject.LadderCircuit;
            elems = ckt.Elements;
        end
        
        function tn = get.TerminalNodes(obj)
            ckt = obj.TopologyObject.LadderCircuit;
            tn = ckt.TerminalNodes;
        end
    end
    
    methods(Hidden)
        function S = sparameters(obj,varargin)
        % For more information, type: help sparameters
            narginchk(2,3)
            
            if ~isscalar(obj)
                validateattributes(obj,{'lcladder'}, ...
                    {'scalar'},'sparameters','LC Ladder',1)
            end
            
            if ~isempty(obj.Parent)
                % error('You can only calculate S-paremeters for a top level circuit.')
                error(message('rflib:shared:SParametersCircuitNotTop'))
            end
            
            ckt = obj.TopologyObject.LadderCircuit;
            S = sparameters(ckt,varargin{:});
        end
        
        function gd = groupdelay(obj,varargin)
        % For more information, type: help groupdelay
            
            % circuit must be a top level circuit
            if ~isempty(obj.Parent)
                % You can only calculate group delay for a top level circuit.
                error(message('rf:shared:GroupDelayCircuitNotTop'))
            end
            
            ckt = obj.TopologyObject.LadderCircuit;
            gd = groupdelay(ckt,varargin{:});
        end
    end
    
    % abstract methods from rf.internal.circuit.Element
    methods(Hidden,Access = protected)
        function initializeTerminalsAndPorts(obj)
            obj.Ports = {'p1','p2'};
            obj.Terminals = {'p1+','p2+','p1-','p2-'};
        end
        function plist1 = getLocalPropertyList(obj)
            plist1.Topology = obj.Topology;
            plist1.Inductances = obj.Inductances;
            plist1.Capacitances = obj.Capacitances;
        end
        function outobj = localClone(inobj)
            topstr = inobj.Topology;
            L = inobj.Inductances;
            C = inobj.Capacitances;
            outobj = lcladder(topstr,L,C);
        end
    end
    
end