classdef gparameters < rf.internal.netparams.VoltageCurrentParameters
%gparameters Create an g-parameters Object
%   OBJ = gparameters(FILENAME) creates the gparameters object OBJ from the
%   file specified by FILENAME.  FILENAME must describe a Touchstone
%   (*.snp, *.ynp, etc) file.  The data will be converted from the file
%   type (S, Y, etc...) to g-parameters. All data is stored in real/imag
%   format.
%
%   OBJ = gparameters(GPARAM_OBJ) creates a deep copy of another
%   gparameters object GPARAM_OBJ.
%
%   OBJ = gparameters(RFTBX_OBJ) extracts the network data in RFTBX_OBJ and
%   then converts it into g-parameter data.  RFTBX_OBJ can have the
%   following types: sparameters, tparameters, yparameters, zparameters,
%   hparameters, abcdparameters, rfdata.data, rfdata.network, and any
%   analyzed rfckt type.
%
%   OBJ = gparameters(PARAMDATA,FREQ) creates a gparameters object directly
%   from specified data.  PARAMDATA is required and will be stored in the
%   "Parameters" property.  FREQ is required and will be stored in the
%   "Frequencies" property.
%
%PROPERTIES:
%   Parameters - A 2x2xK complex array describing 2x2 g-parameter data for
%   each frequency in the Frequencies property.  Note that
%   size(obj.Parameters,3) must equal length(obj.Frequencies)
%
%   Frequencies - A Kx1 vector of positive, real, increasing values.  It
%   describes the frequencies (in Hz) the g-parameters were measured at.
%
%EXAMPLES:
%   % Read a file 'default.s2p' as g-parameters
%   g = gparameters('default.s2p');
%
%   % Extract g11
%   g11 = rfparam(g,1,1);
%
% See also rfparam, smith, rfwrite, sparameters, tparameters, yparameters,
% zparameters, hparameters, abcdparameters

    properties(Constant,Access = protected)
        TypeFlag = 'g'
    end
    
    methods
        function obj = gparameters(varargin)
            obj = obj@rf.internal.netparams.VoltageCurrentParameters(varargin{:});
        end
    end
    
    % define abstract
    methods(Static,Access = protected)
        function validateParameters(newParam)
            rf.internal.netparams.validateTwoPortParameters(newParam,'gparameters')
        end
        
        function outdata = convert2me(str,indata,z0)
            switch lower(str(1))
                case 's'
                    outdata = s2h(indata,z0);
                    outdata = h2g(outdata);
                case 't'
                    outdata = t2s(indata);
                    outdata = s2h(outdata,z0);
                    outdata = h2g(outdata);
                case 'y'
                    outdata = y2h(indata);
                    outdata = h2g(outdata);
                case 'z'
                    outdata = z2h(indata);
                    outdata = h2g(outdata);
                case 'h'
                    outdata = h2g(indata);
                case 'g'
                    outdata = indata;
                case 'a'
                    outdata = abcd2h(indata);
                    outdata = h2g(outdata);
            end
        end
    end
    methods(Static,Hidden)
        function outobj = loadobj(in)
            data = in.Parameters;
            freq = in.Frequencies;
            outobj = gparameters(data,freq);
        end
    end
end