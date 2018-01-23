classdef amplifier < rf.internal.rfbudget.RFElement
%AMPLIFIER Create an amplifier object.
%   OBJ = AMPLIFIER creates an amplifier object with default property
%   values.  An amplifier is a 2-port RF circuit object that can be
%   included  in the elements vector of an rfbudget object.  An amplifier
%   can also be added to a circuit object.
%
%   OBJ = AMPLIFIER(Name,Value) specifies amplifier properties with one or
%   more Name, Value pair arguments.
%
%PROPERTIES:
%   Name - The name of the object, specified as a nonempty character vector
%   (Default = 'Amplifier').  All names must be valid MATLAB variable
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
%    % Create an amplifier object 'LNA' with Gain = 10.
%    a = amplifier('Name','LNA','Gain',10)
%
% See also rfbudget, modulator, rfelement, circuit, nport, rfBudgetAnalyzer

    methods
        function obj = amplifier(varargin)
            obj@rf.internal.rfbudget.RFElement(varargin{:});
        end
    end
    
    % Abstract from rf.internal.rfbudget.Element
    
    methods (Access = protected)
        function h = rbBlock(obj,sys,x,y,rconn,~)
            src = 'simrfV2elements/Amplifier';
            h = add_block(obj,src,sys,x,y);
            set(h, ...
                'Source_linear_gain','Available power gain', ...
                'linear_gain',sprintf('%.15g',obj.Gain), ...
                'linear_gain_unit','dB', ...
                'Zin',sprintf('%.15g',obj.Zin), ...
                'Zout',sprintf('%.15g',obj.Zout), ...
                'NF',sprintf('%.15g',obj.NF), ...
                'Source_Poly','Even and odd order', ...
                'IPType','Output', ...
                'IP2','Inf', ...
                'IP2_unit','dBm', ...
                'IP3',sprintf('%.15g',obj.OIP3), ...
                'IP2_unit','dBm')
            ph = get(h,'PortHandles');
            add_line(sys,rconn,ph.LConn(1),'autorouting','on')
        end
    end
    
    % Abstract from rf.internal.circuit.Element
    
    properties (Constant, Access = protected)
        HeaderDescription = 'Amplifier'
        DefaultName = 'Amplifier'
    end
    
    methods(Hidden, Access = protected)
        function out = localClone(in)
            out = amplifier;
            copyProperties(in,out)
        end
    end
end
