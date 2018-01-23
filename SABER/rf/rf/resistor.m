classdef resistor < rf.internal.circuit.RLC
%RESISTOR Create a Resistor Object
%   ROBJ = resistor(RVALUE) creates the resistor object ROBJ with a
%   resistance of RVALUE and a default name 'R'.  RVALUE must be a numeric
%   non-negative scalar.
%
%   ROBJ = resistor(RVALUE,RNAME) creates the resistor object ROBJ with a
%   resistance of RVALUE and a name of RNAME.  RVALUE must be a numeric
%   non-negative scalar and RNAME must be a string.
%
%PROPERTIES:
%   Resistance - The resistance in Ohms of the resistor object.
%
%   Name - The name of the resistor object (Default = 'R').
%
%   Terminals - A cell vector containing the names of the terminals of the
%   resistor object.  A resistor has two terminals named 'p' and 'n'.
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the resistor.  Note
%   that "ParentNodes" is only displayed after the resistor has been added
%   into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   resistor belongs to. Note that "ParentPath" is only displayed after the
%   resistor has been added into a circuit.
%
%EXAMPLES:
%   % Create a 50 Ohm resistor with a default name, and display it
%   r1 = resistor(50);
%   disp(r1)
%
%   % Insert a 100 Ohm resistor with a name of 'R100' into a circuit, then
%   % display it
%   ckt = circuit('example_circuit');
%   r2 = resistor(100,'R100');
%   add(ckt,[1 2],r2)
%   disp(r2)
%
% See also circuit, capacitor, inductor, nport, circuit/add

    properties
        Resistance
    end
    properties(Constant,Access = protected)
        HeaderDescription = 'Resistor'
        DefaultName = 'R'
    end 
    
    % constructor
    methods
        function obj = resistor(R,varargin)
            narginchk(1,2)
            
            obj = obj@rf.internal.circuit.RLC(varargin{:});
            
            obj.Resistance = R;
        end
    end
    
    % set
    methods
        function set.Resistance(obj,newR)
            validateattributes(newR,{'numeric'},...
                {'nonnegative','scalar','nonnan'},'','Resistance')
            obj.Resistance = newR;
        end
    end
    
    % clone
    methods
        function outobj = clone(inobj)
% CLONE create an identical resistor
%   OUTR = CLONE(INR) creates a resistor object OUTR and copies the
%   contents from INR.  OUTR and INR will have identical resistences,
%   names, and terminals.
%
%   CLONE will not copy information about the parent circuit.  The
%   "ParentNodes" and "ParentPath" properties of OUTR will be empty.
%
%EXAMPLES:
%     % Create a resistor with a very specific name and resistance
%     r1 = resistor(2112,'yyz');
%     
%     % Clone the resistor
%     r2 = clone(r1);
%     
%     disp(r1)
%     disp(r2)
%
% See also resistor, circuit/clone, capacitor/clone, inductor/clone, nport/clone

            outobj = clone@rf.internal.circuit.RLC(inobj);
        end
    end
    
    % define abstract from rf.internal.circuit.Element
    methods(Hidden,Access = protected)
        function plist1 = getLocalPropertyList(obj)
            plist1.Resistance = obj.Resistance;
        end
        
        function outobj = localClone(inobj)
            outobj = resistor(inobj.Resistance);
        end
    end
    
end