classdef circuit < rf.internal.circuit.Circuit
%CIRCUIT Create a Circuit Object
%   CKTOBJ = CIRCUIT creates the circuit object CKTOBJ with a default name
%   'unnamed'.
%
%   CKTOBJ = CIRCUIT(CKTNAME) creates the circuit object CKTOBJ with a name
%   of CKTNAME.  CKTNAME must be a string.
%
%   CKTOBJ = CIRCUIT([ELEM1 ELEM2 ...]) creates a circuit object CKTOBJ by
%   cascading the specified two-port RF circuit object.
%
%   CKTOBJ = CIRCUIT([ELEM1 ELEM2 ...],CKTNAME) creates a cascaded circuit
%   object with a name of CKTNAME.  CKTNAME must be a string.
%
%   CKTOBJ = CIRCUIT(RFB) creates a circuit object CKTOBJ by cascading the
%   elements in the RF budget object RFB.
%
%   CKTOBJ = CIRCUIT(RFB,CKTNAME) creates a cascaded circuit object out of
%   a budget object RFB using name CKTNAME.
%
%PROPERTIES:
%   ElementNames - A cell vector containing the names of the elements that
%   have been added into this circuit object.
%
%   Nodes - A list of nodes already created by this circuit.  Nodes are
%   created automatically when each new element is added into the circuit.
%
%   Name - The name of the circuit object (Default = 'unnamed').
%
%   NumPorts - The number of ports the circuit has. Note that "Ports" is
%   only displayed once ports are defined by the SETPORTS function.
%
%   Terminals - A cell vector containing the names of the terminals of the
%   circuit object. A circuit initially has no terminals but they can be
%   defined by the SETPORTS or the SETTERMINALS functions. Note that
%   "Terminals" is only displayed once terminals are defined.
%
%   ParentNodes - A vector of integers that has the same length as the
%   "Terminals" property. The "ParentNodes" describe which nodes in the
%   parent circuit are connected to the terminals of the circuit.  Note
%   that "ParentNodes" is only displayed after the circuit has been added
%   into a circuit.
%
%   ParentPath - A string describing the full path of the circuit that the
%   circuit belongs to. Note that "ParentPath" is only displayed after the
%   circuit has been added into a circuit.
%
%EXAMPLES:
%   % Create a new circuit, and display it
%   ckt1 = circuit('example_circuit1');
%   disp(ckt1)
%   
%   % Add a capacitor and inductor in series, then display the circuit
%   add(ckt1,[1 2],capacitor(1e-12))
%   add(ckt1,[2 3],inductor(1e-9))
%   disp(ckt1)
%   
%   % Define nodes 1 and 3 as terminals, then display the circuit
%   setterminals(ckt1,[1 3])
%   disp(ckt1)
%   
%   % Create a second new circuit, and display it
%   ckt2 = circuit('example_circuit2');
%   disp(ckt2)
%   
%   % Add a capacitor and "ckt1" in parallel, then display the circuit
%   add(ckt2,[1 2],capacitor(1e-12))
%   add(ckt2,[1 2],ckt1)
%   disp(ckt2)
%   
%   % Define this circuit as a 2-port object, then display the circuit
%   setports(ckt2,[1 2],[1 2])
%   disp(ckt2)
%
% See also setterminals, setports, circuit/add, resistor, capacitor,
% inductor, nport, lcladder, rfbudget, amplifier, modulator, rfelement
    
    properties(Constant,Access = protected)
        DefaultName = 'unnamed'
    end 

    % constructor
    methods
        function obj = circuit(varargin)
            obj = obj@rf.internal.circuit.Circuit(varargin{:});
        end
    end
    
    % public
    methods
        function setterminals(obj,tnodes,varargin)
%SETTERMINALS Define some of the nodes of a circuit object as terminals
%   SETTERMINALS(CKTOBJ,CKTNODES) defines the nodes specified by CKTNODES
%   as terminals and gives the terminals default names. All of the integers
%   in CKTNODES must already be in the "Nodes" property of CKTOBJ
%
%   SETTERMINALS(CKTOBJ,CKTNODES,TERMNAMES) defines the nodes specified by
%   CKTNODES as terminals and gives the terminals the names spcified by
%   TERMNAMES. TERMNAMES must be a cell vector whose contents are strings
%   which are valid MATLAB variable names. CKTNODES and TERMNAMES must be
%   the same length.
%
%EXAMPLES:
%   % Connect a resistor and capacitor in series
%   ckt1 = circuit('example_circuit1');
%   add(ckt1,[1 2],resistor(50))
%   add(ckt1,[2 3],capacitor(1e-9))
%   % Define nodes 1 & 3 as terminals with default names
%   setterminals(ckt1,[1 3])
%   disp(ckt1)
% 
%   % Build a circuit using 3 resistors
%   ckt2 = circuit('example_circuit2');
%   add(ckt2,[1 2],resistor(50))
%   add(ckt2,[1 3],resistor(50))
%   add(ckt2,[1 4],resistor(50))
%   % Define nodes 2, 3 & 4 as terminals with names 'a','b', and 'c'.
%   setterminals(ckt2,[2 3 4],{'a' 'b' 'c'})
%   disp(ckt2)
%
% See also circuit, setports
            
            narginchk(2,3)
            
            setterminals@rf.internal.circuit.Circuit(obj,tnodes,varargin{:})
        end
        
        function setports(obj,varargin)
%SETPORTS Define a list of node-pairs in a circuit object as ports
%   SETPORTS(CKTOBJ,NODEPAIR_1,...,NODEPAIR_N) defines an N-port circuit by
%   defining the node-pairs specified by NODEPAIR_1 through NODEPAIR_N as
%   ports and gives the ports default names.  It also defines the terminals
%   of CKTOBJ, basing the terminal names off of the port names. If any of
%   the nodes in a NODEPAIR do not yet exist in CKTOBJ, they will be
%   created.
%
%   SETPORTS(CKTOBJ,NODEPAIR_1,...,NODEPAIR_N,PORTNAMES) defines an N-port
%   circuit and names the ports using the strings in the cell vector
%   PORTNAMES.  It also defines the terminals of CKTOBJ, basing the
%   terminal names off of the port names.  The length of PORTNAMES must
%   equal the number of NODEPAIRs given.
%
%EXAMPLES:
%   % Create a 1-port circuit with default port names
%   ckt1 = circuit('example_circuit1');
%   add(ckt1,[1 2],resistor(50))
%   setports(ckt1,[1 2])
%   disp(ckt1)
% 
%   % Create a 2-port circuit using port names 'in' and 'out'
%   ckt2 = circuit('example_circuit2');
%   add(ckt2,[2 3],resistor(50))
%   add(ckt2,[3 1],capacitor(1e-9))
%   setports(ckt2,[2 1],[3 1],{'in' 'out'})
%   disp(ckt2)
%
% See also circuit, setterminals
            
            narginchk(2,Inf)
            
            setports@rf.internal.circuit.Circuit(obj,varargin{:})
        end
        
        function varargout = add(ckt,nodes,elem,varargin)
%ADD Attach an Element object into a Circuit object
%   ADD(CKTOBJ,CKTNODES,ELEM) inserts a circuit element ELEM into circuit
%   object CKTOBJ. The add command attaches the terminals in ELEM to the
%   circuit nodes given in CKTNODES. If the nodes do not yet exist in
%   CKTOBJ, they will be created.  ELEM may be any of the following circuit
%   elements: resistor, capacitor, inductor, nport, or circuit.  When ELEM
%   is a Touchstone filename or sparameters object, an nport object is
%   created from that input and added into CKTOBJ.
%
%   ADD(CKTOBJ,CKTNODES,ELEM,TERMORDER) attaches the terminals specified by
%   TERMORDER to the circuit nodes specified by CKTNODES. TERMORDER must be
%   a cell vector containing a list of the same terminal names found in the
%   "Terminals" property of ELEM, but it can be in any order.
%
%   ELEM = ADD(___) returns ELEM as an output.  If the input ELEM was a
%   filename or sparameters object, the output will be the newly created
%   nport element.
%
%EXAMPLES:
%   % 1) Create a resistor and add it bewteen nodes 1 & 2 of a new circuit
%   r1 = resistor(50);
%   ckt1 = circuit('new_circuit1');
%   add(ckt1,[1 2],r1)
%   disp(r1)
%   disp(ckt1)
%   
%   % 2) Create a capacitor, and attach terminal 'n' to node 3 and terminal
%   % 'p' to node 4
%   c2 = capacitor(1e-10);
%   ckt2 = circuit('new_circuit2');
%   add(ckt2,[3 4],c2,{'n' 'p'})
%   disp(c2)
%   disp(ckt2)
%   
%   % 3) Construct an inductor from inside the ADD function, and pass out
%   % the variable refering to the inductor as an output argument
%   hckt3 = circuit('new_circuit3');
%   hL3 = add(hckt3,[100 200],inductor(1e-9));
%   disp(hL3)
%   disp(hckt3)
%
% See also circuit, resistor, capacitor, inductor, nport
            
            narginchk(3,4)
            nargoutchk(0,1)
            
            elem = add@rf.internal.circuit.Circuit(ckt,nodes,elem,varargin{:});

            if nargout
                varargout{1} = elem;
            end
        end
        
        function outobj = clone(inobj)
% CLONE create an identical circuit
%   OUTCKT = CLONE(INCKT) creates a circuit object OUTCKT and copies the
%   contents from INCKT.  If there are any elements in INCKT, they will be
%   cloned recursively, and added into OUTCKT to the same nodes that they
%   were attached to in INCKT.  If INCKT has ports or terminals defined,
%   OUTCKT will have an identical definition.
%
%   CLONE will not copy information about the parent circuit.  The
%   "ParentNodes" and "ParentPath" properties of OUTCKT will be empty.
%
%EXAMPLES:
%   % Create a 2-port circuit using port names 'in' and 'out'
%   ckt1 = circuit('example_circuit1');
%   add(ckt1,[2 3],resistor(50))
%   add(ckt1,[3 1],capacitor(1e-9))
%   setports(ckt1,[2 1],[3 1],{'in' 'out'})
%   
%   % Clone the circuit
%   ckt2 = clone(ckt1);
%   
%   disp(ckt1)
%   disp(ckt2)
%
% See also circuit, resistor/clone, capacitor/clone, inductor/clone, nport/clone

            outobj = clone@rf.internal.circuit.Circuit(inobj);
        end
    end
    
    methods(Hidden)
        function gd = groupdelay(obj,varargin)
        % For more information, type: help groupdelay
            
            % circuit must be a top level circuit
            if ~isempty(obj.Parent)
                % You can only calculate group delay for a top level circuit.
                error(message('rf:shared:GroupDelayCircuitNotTop'))
            end
            
            gdcalcobj = rf.internal.groupdelay.FromCircuit(obj);
            gd = calculateGroupDelay(gdcalcobj,varargin{:});
        end
    end
end