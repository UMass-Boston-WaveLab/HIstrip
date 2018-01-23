classdef tparameters < rf.internal.netparams.ScatteringParameters
%tparameters Create a T-parameters Object
%   OBJ = tparameters(FILENAME) creates the tparameters object OBJ from the
%   file specified by FILENAME.  FILENAME must describe a Touchstone
%   (*.snp, *.ynp, etc) file. The data will be converted from the type
%   specified in the file (S, Y, etc...) to T-parameters. All data is
%   stored in real/imag format.
%
%   OBJ = tparameters(TPARAM_OBJ,Z0) converts the T-parameter data in
%   TPARAM_OBJ to the new impedance Z0. Z0 is optional, and if Z0 is not
%   provided, TPARAM_OBJ will be copied instead of converted.
%
%   OBJ = tparameters(RFTBX_OBJ) extracts S-parameter network data from an
%   rfdata.network object, an rfdata.data object, or any analyzed rfckt
%   object, and then converts to T-parameter data.
%
%   OBJ = tparameters(RFTBX_OBJ,Z0) converts the data in RFTBX_OBJ into
%   T-parameter data.  RFTBX_OBJ can have the following types: sparameters,
%   yparameters, zparameters, hparameters, gparameters, and abcdparameters.
%   Z0 is optional (default=50) and will be stored in the "Impedance"
%   property.
%
%   OBJ = tparameters(PARAMDATA,FREQ,Z0) creates a tparameters object
%   directly from specified data.  PARAMDATA is required and will be stored
%   in the "Parameters" property.  FREQ is required and will be stored in
%   the "Frequencies" property. Z0 is optional (default=50) and will be
%   stored in the "Impedance" property.
%
%PROPERTIES:
%   Parameters - A 2x2xK complex array describing 2x2 T-parameter data for
%   each frequency in the Frequencies property.  Note that
%   size(obj.Parameters,3) must equal length(obj.Frequencies)
%
%   Frequencies - A Kx1 vector of positive, real, increasing values.  It
%   describes the frequencies (in Hz) the T-parameters were measured at.
%
%   Impedance - A numeric, positive, real scalar that describes the
%   characteristic impedance used to measure the T-Parameters.
%
%EXAMPLES:
%   % Read a file named 'passive.s2p'
%   T1 = tparameters('passive.s2p');
%
%   % Convert the T-parameters to 100 ohms
%   T2 = tparameters(T1,100);
%
% See also rfparam, smith, rfwrite, sparameters, yparameters, zparameters,
% hparameters, gparameters, abcdparameters

    properties(Constant,Access = protected)
        TypeFlag = 'T'
    end
    
    % constructor
    methods
        function obj = tparameters(varargin)
            obj = obj@rf.internal.netparams.ScatteringParameters(varargin{:});
        end
    end
    
    % public
    methods
        function newobj = newref(oldobj,newZ0)
            
            narginchk(2,2)
            
            newobj = tparameters(oldobj,newZ0);
        end
    end
    
    % define abstract
    methods(Static,Access = protected)
        function validateParameters(newParam)
            rf.internal.netparams.validateTwoPortParameters(newParam,'tparameters')
        end
        
        function outdata = convert2me(str,indata,z0)
            switch lower(str(1))
                case 's'
                    outdata = s2t(indata);
                case 't'
                    outdata = indata;
                case 'y'
                    outdata = y2s(indata,z0);
                    outdata = s2t(outdata);
                case 'z'
                    outdata = z2s(indata,z0);
                    outdata = s2t(outdata);
                case 'h'
                    outdata = h2s(indata,z0);
                    outdata = s2t(outdata);
                case 'g'
                    outdata = g2h(indata);
                    outdata = h2s(outdata,z0);
                    outdata = s2t(outdata);
                case 'a'
                    outdata = abcd2s(indata,z0);
                    outdata = s2t(outdata);
            end
        end
        
        function outdata = me2s(indata)
            outdata = t2s(indata);
        end
    end
    methods(Static,Hidden)
        function outobj = loadobj(in)
            data = in.Parameters;
            freq = in.Frequencies;
            z0 = in.Impedance;
            outobj = tparameters(data,freq,z0);
        end
    end
end