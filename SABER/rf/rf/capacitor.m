classdef capacitor < rf.internal.circuit.RLC
%CAPACITOR Create a Capacitor Object
%   COBJ = capacitor(CVALUE) creates the capacitor object COBJ with a
%   capacitance of CVALUE and a default name 'C'.  CVALUE must be a numeric
%   non-negative scalar.
%
%   COBJ = capacitor(CVALUE,CNAME) creates the capacitor object COBJ with a
%   capacitance of CVALUE and a name of CNAME.  CVALUE must be a numeric
%   non-negative scalar and CNAME must be a string.
%
%PROPERTIES:
%   Capacitance - The capacitance in Farads of the capacitor object.
%
%   Name - The name of the capacitor object (Default = 'C').
%
%   Terminals - A cell vector containing the names of the terminals of the
%   capacitor object. A capacitor has two terminals named 'p' and 'n'.
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the capacitor.  Note
%   that "ParentNodes" is only displayed after the capacitor has been added
%   into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   capacitor belongs to. Note that "ParentPath" is only displayed after
%   the capacitor has been added into a circuit.
%
%EXAMPLES:
%   % Create a 1 nF capacitor with a default name, and display it
%   c1 = capacitor(1e-9);
%   disp(c1)
%
%   % Insert a 1 pF capacitor with a name of 'C1p' into a circuit, then
%   % display it
%   ckt = circuit('example_circuit');
%   c2 = capacitor(1e-12,'C1p');
%   add(ckt,[1 2],c2)
%   disp(c2)
%
% See also circuit, resistor, inductor, nport, circuit/add

    properties
        Capacitance
    end
    properties(Constant,Access = protected)
        HeaderDescription = 'Capacitor'
        DefaultName = 'C'
    end 
    
    % constructor
    methods
        function obj = capacitor(C,varargin)
            narginchk(1,2)
            
            obj = obj@rf.internal.circuit.RLC(varargin{:});
            
            obj.Capacitance = C;
        end
    end
    
    % set
    methods
        function set.Capacitance(obj,newC)
            validateattributes(newC,{'numeric'},...
                {'nonnegative','scalar','nonnan'},'','Capacitance')
            obj.Capacitance = newC;
        end
    end
    
    % clone
    methods
        function outobj = clone(inobj)
% CLONE create an identical capacitor
%   OUTC = CLONE(INC) creates a capacitor object OUTC and copies the
%   contents from INC.  OUTC and INC will have identical capacitances,
%   names, and terminals.
%
%   CLONE will not copy information about the parent circuit.  The
%   "ParentNodes" and "ParentPath" properties of OUTC will be empty.
%
%EXAMPLES:
%     % Create a capacitor with a very specific name and resistance
%     c1 = capacitor(123,'xyz');
%     
%     % Clone the capacitor
%     c2 = clone(c1);
%     
%     disp(c1)
%     disp(c2)
%
% See also capacitor, circuit/clone, resistor/clone, inductor/clone, nport/clone

            outobj = clone@rf.internal.circuit.RLC(inobj);
        end
    end
    
    % define abstract from rf.internal.circuit.Element
    methods(Hidden,Access = protected)
        function plist1 = getLocalPropertyList(obj)
            plist1.Capacitance = obj.Capacitance;
        end
        
        function outobj = localClone(inobj)
            outobj = capacitor(inobj.Capacitance);
        end
    end
    
end