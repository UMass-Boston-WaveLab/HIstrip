classdef inductor < rf.internal.circuit.RLC
%INDUCTOR Create an Inductor Object
%   LOBJ = inductor(LVALUE) creates the inductor object LOBJ with a
%   inductance of LVALUE and a default name 'L'.  LVALUE must be a numeric
%   non-negative scalar.
%
%   LOBJ = inductor(LVALUE,LNAME) creates the inductor object LOBJ with a
%   inductance of LVALUE and a name of LNAME.  LVALUE must be a numeric
%   non-negative scalar and LNAME must be a string.
%
%PROPERTIES:
%   Inductance - The inductance in Henrys of the inductor object.
%
%   Name - The name of the inductor object (Default = 'L').
%
%   Terminals - A cell vector containing the names of the terminals of the
%   inductor object. An inductor has two terminals named 'p' and 'n'.
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the inductor.  Note
%   that "ParentNodes" is only displayed after the inductor has been added
%   into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   inductor belongs to. Note that "ParentPath" is only displayed after
%   the inductor has been added into a circuit.
%
%EXAMPLES:
%   % Create a 1 nH inductor with a default name, and display it
%   l1 = inductor(1e-9);
%   disp(l1)
%
%   % Insert a 1 pH inductor with a name of 'L1p' into a circuit, then
%   % display it
%   ckt = circuit('example_circuit');
%   l2 = inductor(1e-12,'L1p');
%   add(ckt,[1 2],l2)
%   disp(l2)
%
% See also circuit, resistor, capacitor, nport, circuit/add
    
    properties
        Inductance
    end
    properties(Constant,Access = protected)
        HeaderDescription = 'Inductor'
        DefaultName = 'L'
    end 
    
    % constructor
    methods
        function obj = inductor(L,varargin)
            narginchk(1,2)
            
            obj = obj@rf.internal.circuit.RLC(varargin{:});
            
            obj.Inductance = L;
        end
    end
    
    % set
    methods
        function set.Inductance(obj,newL)
            validateattributes(newL,{'numeric'},...
                {'nonnegative','scalar','nonnan'},'','Inductance')
            obj.Inductance = newL;
        end
    end
    
    % clone
    methods
        function outobj = clone(inobj)
% CLONE create an identical inductor
%   OUTL = CLONE(INL) creates an inductor object OUTL and copies the
%   contents from INL.  OUTL and INL will have identical inductances,
%   names, and terminals.
%
%   CLONE will not copy information about the parent circuit.  The
%   "ParentNodes" and "ParentPath" properties of OUTL will be empty.
%
%EXAMPLES:
%     % Create a inductor with a very specific name and resistance
%     l1 = inductor(123,'xyz');
%     
%     % Clone the inductor
%     l2 = clone(l1);
%     
%     disp(l1)
%     disp(l2)
%
% See also inductor, circuit/clone, resistor/clone, capacitor/clone, nport/clone

            outobj = clone@rf.internal.circuit.RLC(inobj);
        end
    end
    
    % define abstract from rf.internal.circuit.Element
    methods(Hidden,Access = protected)
        function plist1 = getLocalPropertyList(obj)
            plist1.Inductance = obj.Inductance;
        end
        
        function outobj = localClone(inobj)
            outobj = inductor(inobj.Inductance);
        end
    end
    
end