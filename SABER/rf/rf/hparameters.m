classdef hparameters < rf.internal.netparams.VoltageCurrentParameters
%hparameters Create an h-parameters Object
%   OBJ = hparameters(FILENAME) creates the hparameters object OBJ from the
%   file specified by FILENAME.  FILENAME must describe a Touchstone
%   (*.snp, *.ynp, etc) file.  The data will be converted from the file
%   type (S, Y, etc...) to h-parameters. All data is stored in real/imag
%   format.
%
%   OBJ = hparameters(HPARAM_OBJ) creates a deep copy of another
%   hparameters object HPARAM_OBJ.
%
%   OBJ = hparameters(RFTBX_OBJ) extracts the network data in RFTBX_OBJ and
%   then converts it into h-parameter data.  RFTBX_OBJ can have the
%   following types: sparameters, tparameters, yparameters, zparameters,
%   gparameters, abcdparameters, rfdata.data, rfdata.network, and any
%   analyzed rfckt type.
%
%   OBJ = hparameters(PARAMDATA,FREQ) creates a hparameters object directly
%   from specified data.  PARAMDATA is required and will be stored in the
%   "Parameters" property.  FREQ is required and will be stored in the
%   "Frequencies" property.
%
%PROPERTIES:
%   Parameters - A 2x2xK complex array describing 2x2 h-parameter data for
%   each frequency in the Frequencies property.  Note that
%   size(obj.Parameters,3) must equal length(obj.Frequencies)
%
%   Frequencies - A Kx1 vector of positive, real, increasing values.  It
%   describes the frequencies (in Hz) the h-parameters were measured at.
%
%EXAMPLES:
%   % Read a file 'default.s2p' as h-parameters
%   h = hparameters('default.s2p');
%
%   % Extract h11
%   h11 = rfparam(h,1,1);
%
% See also rfparam, smith, rfwrite, sparameters, tparameters, yparameters,
% zparameters, gparameters, abcdparameters

    properties(Constant,Access = protected)
        TypeFlag = 'h'
    end
    
    methods
        function obj = hparameters(varargin)
            obj = obj@rf.internal.netparams.VoltageCurrentParameters(varargin{:});
        end
    end
    
    % define abstract
    methods(Static,Access = protected)
        function validateParameters(newParam)
            rf.internal.netparams.validateTwoPortParameters(newParam,'hparameters')
        end
        
        function outdata = convert2me(str,indata,z0)
            switch lower(str(1))
                case 's'
                    outdata = s2h(indata,z0);
                case 't'
                    outdata = t2s(indata);
                    outdata = s2h(outdata,z0);
                case 'y'
                    outdata = y2h(indata);
                case 'z'
                    outdata = z2h(indata);
                case 'h'
                    outdata = indata;
                case 'g'
                    outdata = g2h(indata);
                case 'a'
                    outdata = abcd2h(indata);
            end
        end
    end
    methods(Static,Hidden)
        function outobj = loadobj(in)
            data = in.Parameters;
            freq = in.Frequencies;
            outobj = hparameters(data,freq);
        end
    end
end