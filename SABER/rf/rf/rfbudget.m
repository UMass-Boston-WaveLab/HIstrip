classdef rfbudget < rf.internal.rfbudget.RFBudget
    methods
        function obj = rfbudget(varargin)
%RFBUDGET Create an RF budget object and compute RF budget results.
%   OBJ = RFBUDGET(ELEMENTS,INPUTFREQ,INPUTPWR,BANDWIDTH) specifies the
%   input properties of an RF budget object, independently computes an RF
%   budget analysis for each input frequency, storing the results in
%   dependent properties.  By default, the object recomputes results if any
%   of the input properties are changed.
%
%   OBJ = RFBUDGET(ELEMENTS,INPUTFREQ,INPUTPWR,BANDWIDTH,AUTOUPDATE) allows
%   the user to set AUTOUPDATE to false to turn off automatic budget
%   recomputation as parameters are changed.
%
%   OBJ = RFBUDGET(Name,Value) specifies rfbudget properties with one or
%   more Name, Value pair arguments.
%
%   OBJ = RFBUDGET creates an rfbudget object OBJ with default empty
%   property values.
%
%PROPERTIES:
%   Elements - A vector of amplifier, modulator, rfelement, or nport
%   objects, i.e. the 2-port cascade to be analyzed (Default = []).
%
%   InputFrequency - The frequency of the signal at the input of the
%   cascade specified as a nonnegative value in Hz (Default = []).
%   If the InputFrequency is a vector, then the RF budget is separately
%   computed for each InputFrequency value, and stored as rows in the
%   analysis results.  This is useful for plotting across bandwidth.
%
%   AvailableInputPower - The available input power applied at the input of
%   the cascade, specified as a scalar in dBm (Default = []).
%
%   SignalBandwidth - The bandwidth of the signal at the input of the
%   cascade specified as a positive scalar in Hz (Default = []).
%
%   AutoUpdate - A logical specifying whether or not the budget analysis
%   will be automatically recomputed if any of the other properties are
%   changed (Default = true).  The computeBudget method can be used to
%   update the budget results when AutoUpdate is false.
%
%DEPENDENT PROPERTIES (ANALYSIS RESULTS):
%   OutputFrequency - A row vector of output frequencies in Hz, where
%   column j is computed for the partial cascade Elements(1:j).
%
%   OutputPower - A row vector of output powers in dBm, where column j is
%   computed for the partial cascade Elements(1:j).
%
%   TransducerGain - A row vector of transducer power gains in dB, where
%   column j is computed for the partial cascade Elements(1:j).
%
%   NF - A row vector of noise figures in dB, where column j is computed
%   for the partial cascade Elements(1:j).
%
%   OIP3 - A row vector of output-referred third-order intercept points in
%   dBm, where column j is computed for the partial cascade Elements(1:j).
%
%   IIP3 - A row vector of input-referred third-order intercept points in
%   dBm, where column j is computed for the partial cascade Elements(1:j).
%
%   SNR - A row vector of signal-to-noise ratios in dB, where column j is
%   computed for the partial cascade Elements(1:j).
%
% rfbudget methods:
%   computeBudget - Compute the results of an rfbudget object
%   exportScript - Export the MATLAB code that generates an rfbudget
%   exportRFBlockset - Create an RF Blockset model from the rfbudget object
%   exportTestbench - Create a measurement testbench from an rfbudget
%   show - Display the rfbudget in the rfBudgetAnalyzer app.
%
%EXAMPLES:
%   % Create an rfbudget with four elements:
%   a = amplifier('Name','LNA','Gain',4);
%   m = modulator('ConverterType','Up','LO',100e6,'Name','Mod');
%   r = rfelement('Gain',10,'NF',3,'OIP3',2);
%   n = nport('passive.s2p');
%   b = rfbudget([a m r n],2.1e9,-30,10e6)
%   % Display the rfbudget for exploration in the rfBudgetAnalyzer app
%   show(b)
%
% See also amplifier, modulator, rfelement, nport, rfBudgetAnalyzer
            
            narginchk(0,10)
            nargoutchk(0,1)
            obj = obj@rf.internal.rfbudget.RFBudget(varargin{:});
        end
    end
    
    methods
        function computeBudget(obj)
%COMPUTEBUDGET Compute the results of an rfbudget object
%   computeBudget(OBJ) computes the result of an rfbudget object.  This is
%   only needed if the user has set the rfbudget object's AutoUpdate
%   property to false.  By default the property is true.

            narginchk(1,1)
            nargoutchk(0,0)
            computeBudget@rf.internal.rfbudget.RFBudget(obj)
        end
        
        function exportScript(obj)
%EXPORTSCRIPT Export the MATLAB code that generates an rfbudget object
%   exportScript(OBJ) exports the MATLAB command-line code that generates
%   an rfbudget object.  The script is opened in an Untitled* window in the
%   MATLAB editor for the user to save.

            narginchk(1,1)
            nargoutchk(0,0)
            exportScript@rf.internal.rfbudget.RFBudget(obj)
        end
        
        function out = exportRFBlockset(obj,varargin)
%EXPORTRFBLOCKSET Create an RF Blockset model from an rfbudget object
%   exportRFBlockset(OBJ) creates an RF Blockset model from the rfbudget
%   object OBJ, and opens the system.
%
%   SYS = exportRFBlockset(OBJ) creates an RF Blockset model from OBJ, and
%   returns SYS, the system name.
%
%EXAMPLES:
%
% See also rfbudget, rfbudget/exportTestbench
            
            narginchk(1,3)
            nargoutchk(0,1)
            sys = exportRFBlockset@rf.internal.rfbudget.RFBudget(obj,varargin{:});
            if nargout > 0
                out = sys;
            elseif ~isempty(sys)
                open_system(sys)
            end
        end
        
        function out = exportTestbench(obj)
%EXPORTTESTBENCH Create a measurement testbench from an rfbudget object
%   exportTestbench(OBJ) creates an RF Blockset model from the rfbudget
%   object OBJ, and opens a measurement testbench system.
%
%   SYS = exportTestbench(OBJ) creates an RF Blockset model from OBJ, and
%   returns SYS, the measurement testbench system name.
%
%EXAMPLES:
%
% See also rfbudget, rfbudget/exportRFBlockset
            
            narginchk(1,2)
            nargoutchk(0,1)
            sys = exportTestbench@rf.internal.rfbudget.RFBudget(obj);
            if nargout > 0
                out = sys;
            elseif ~isempty(sys)
                open_system(sys)
            end
        end
        
        function show(obj)
%SHOW Display an rfbudget object in the rfBudgetAnalyzer app
%   SHOW(OBJ) Opens an rfBudgetAnalyzer app to display a clone of the
%   rfbudget object OBJ.
%
%EXAMPLES:
%
% See also rfbudget, rfBudgetAnalyzer
            
            narginchk(1,1)
            nargoutchk(0,0)
            show@rf.internal.rfbudget.RFBudget(obj)
        end
        
        function out = clone(obj)
%CLONE Create an identical rfbudget object
%   OUT = CLONE(IN) creates an rfbudget object OUT and copies the contents
%   from IN.  If there are any elements in IN, they will each be cloned,
%   and added into OUT in the same sequence.
%
%EXAMPLES:
%
% See also rfbudget
            
            narginchk(1,1)
            nargoutchk(0,1)
            out = clone@rf.internal.rfbudget.RFBudget(obj);
        end
    end
end
