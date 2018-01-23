classdef abcdparameters < rf.internal.netparams.VoltageCurrentParameters
%abcdparameters Create an ABCD-parameters Object
%   OBJ = abcdparameters(FILENAME) creates the abcdparameters object OBJ
%   from the file specified by FILENAME.  FILENAME must describe a
%   Touchstone (*.snp, *.ynp, etc) file. The data will be converted from
%   the file type (S, Y, etc...) to ABCD-parameters. All data is stored in
%   real/imag format.
%
%   OBJ = abcdparameters(ABCD_OBJ) creates a deep copy of another
%   abcdparameters object ABCD_OBJ.
%
%   OBJ = abcdparameters(RFTBX_OBJ) extracts the network data in RFTBX_OBJ
%   and then converts it into ABCD-parameter data.  RFTBX_OBJ can have the
%   following types: sparameters, tparameters, yparameters, zparameters,
%   hparameters, gparameters, rfdata.data, rfdata.network, and any analyzed
%   rfckt type.
%
%   OBJ = abcdparameters(PARAMDATA,FREQ) creates an abcdparameters object
%   directly from specified data.  PARAMDATA is required and will be stored
%   in the "Parameters" property.  FREQ is required and will be stored in
%   the "Frequencies" property.
%
%PROPERTIES:
%   Parameters - A 2Nx2NxK complex array describing 2Nx2N ABCD-parameter
%   data for each frequency in the Frequencies property.  Note that
%   size(obj.Parameters,3) must equal length(obj.Frequencies)
%
%   Frequencies - A Kx1 vector of positive, real, increasing values.  It
%   describes the frequencies (in Hz) the ABCD-parameters were measured at.
%
%EXAMPLES:
%   % Read a file 'default.s2p' as ABCD-parameters
%   abcd = abcdparameters('default.s2p');
%
%   % Extract 'A'
%   A = rfparam(abcd,'A');
%
% See also rfparam, smith, rfwrite, sparameters, tparameters, yparameters,
% zparameters, hparameters, gparameters
    
    properties(Constant,Access = protected)
        TypeFlag = 'ABCD'
    end
    
    methods
        function data = rfparam(obj,varargin)
            narginchk(2,3)
                        
            if nargin == 2
                if obj.NumPorts > 2
                    % error('When using PARAM on ABCD-parameters, you can only specify an ''A'',''B'',''C'', or ''D'' flag for 2-port data sets')
                    error(message('rf:abcdparameters:rfparam:FlagOnlyForTwoPort'))
                end
                [m,n] = obj.flag2MN(varargin{1});
            else
                m = varargin{1};
                n = varargin{2};
            end
            data = obj.rfparam@rf.internal.netparams.VoltageCurrentParameters(m,n);
        end
        
        function obj = abcdparameters(varargin)
            obj = obj@rf.internal.netparams.VoltageCurrentParameters(varargin{:});
        end
    end
    
    methods(Static,Access = protected)
        function [m,n] = flag2MN(flag)
            switch lower(flag)
                case 'a'
                    m = 1;
                    n = 1;
                case 'b'
                    m = 1;
                    n = 2;
                case 'c'
                    m = 2;
                    n = 1;
                case 'd'
                    m = 2;
                    n = 2;
                otherwise
                    % error('Unrecognized flag %s. ABCD flag must be ''A'',''B'',''C'', or ''D''.', flag)
                    error(message('rf:abcdparameters:flag2MN:BadFlag',flag))
            end
        end
        
        function validateParameters(newParam)
            rf.internal.netparams.validate2NPortParameters(newParam,'abcdparameters')
        end
        
        function outdata = convert2me(str,indata,z0)
            switch lower(str(1))
                case 's'
                    outdata = s2abcd(indata,z0);
                case 't'
                    outdata = t2s(indata);
                    outdata = s2abcd(outdata,z0);
                case 'y'
                    outdata = y2abcd(indata);
                case 'z'
                    outdata = z2abcd(indata);
                case 'h'
                    outdata = h2abcd(indata);
                case 'g'
                    outdata = g2h(indata);
                    outdata = h2abcd(outdata);
                case 'a'
                    outdata = indata;
            end
        end
    end
    
    methods(Hidden,Access = protected)
        function str = calculateLegendText(obj,row,col) %#ok<INUSL>
            lookuptbl = ['AB';'CD'];
            str = lookuptbl(row,col);
        end
        
        function str = customFooter(obj)
            if obj.NumPorts == 2
                str = sprintf('(obj,specifier) returns specified ABCD-parameter ''A'', ''B'', ''C'', or ''D''');
            else
                str = sprintf('(obj,i,j) returns the (i,j)th entry of ABCD-parameter obj');
            end
        end
    end
    
    methods(Static,Hidden)
        function outobj = loadobj(in)
            data = in.Parameters;
            freq = in.Frequencies;
            outobj = abcdparameters(data,freq);
        end
    end
end