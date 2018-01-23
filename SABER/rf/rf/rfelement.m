classdef rfelement < rf.internal.rfbudget.RFElement
%RFELEMENT Create an rfelement object.
%   OBJ = RFELEMENT creates a RF element object with default property
%   values.  An rfelement is a generic 2-port RF circuit object that can be
%   included  in the elements vector of an rfbudget object.  An rfelement 
%   can also be added to a circuit object.
%
%   OBJ = RFELEMENT(Name,Value) specifies rfelement properties with one or
%   more Name, Value pair arguments.
%
%PROPERTIES:
%   Name - The name of the object, specified as a nonempty character vector
%   (Default = 'RFelement').  All names must be valid MATLAB variable
%   names.
%
%   Gain - The available power gain, specified as a real finite scalar in
%   dB (Default = 0). 
%
%   NF - The noise figure, specified as a real finite non-negative scalar
%   in dB (Default = 0).
%
%   OIP3 - The third-order output-referred intercept point, specified as a
%   real nonnan scalar in dBm (Default = Inf).
%
%   Zin - The input impedance, specified as a positive-real-part finite
%   scalar in Ohm (Default = 50).  A complex value is allowed, but must
%   have positive real part.
%
%   Zout - The output impedance, specified as a positive-real-part finite
%   scalar in Ohm (Default = 50).  A complex value is allowed, but must
%   have positive real part.
%
%EXAMPLE:
%    % Create an rfelement object with Gain = 10, NF = 3, and OIP3 = 2.
%    r = rfelement('Gain',10,'NF',3,'OIP3',2)
%
% See also rfbudget, amplifier, modulator, circuit, nport, rfBudgetAnalyzer

methods
        function obj = rfelement(varargin)
            obj@rf.internal.rfbudget.RFElement(varargin{:});
        end
    end
    
    % Abstract from rf.internal.rfbudget.Element
    
    methods (Access = protected)
        function h = rbBlock(obj,sys,x,y,rconn,~)
            src = 'rfBudgetAnalyzer_lib/Generic';
            h = add_block(obj,src,sys,x,y);
            set(h, ...
                'Gain',sprintf('%.15g',obj.Gain), ...
                'Zin',sprintf('%.15g',obj.Zin), ...
                'Zout',sprintf('%.15g',obj.Zout), ...
                'NF',sprintf('%.15g',obj.NF), ...
                'OIP3',sprintf('%.15g',obj.OIP3))
            ph = get(h,'PortHandles');
            add_line(sys,rconn,ph.LConn(1),'autorouting','on')
        end
    end
    
    % Abstract from rf.internal.circuit.Element
    
    properties(Constant, Access = protected)
        HeaderDescription = 'RF'
        DefaultName = 'RFelement'
    end
    
    methods(Hidden, Access = protected)
        function out = localClone(in)
            out = rfelement;
            copyProperties(in,out)
        end
    end
end
