function varargout = rfinterp1(varargin) %#ok<STOUT>
%RFINTERP1 Interpolate network parameter data at new frequencies
%   OBJ_NEW = RFINTERP1(OBJ_OLD,NEWFREQS) interpolates the data in the
%   Parameters property of OBJ_OLD.  RFINTERP1 uses the MATLAB function
%   INTERP1 to interpolate each individual (I,J) parameter of OBJ_OLD to
%   the new frequencies specified by NEWFREQS.  OBJ_OLD must be a network
%   parameter object with the following types: sparameters, tparameters,
%   yparameters, zparameters, hparameters, gparameters, or abcdparameters.
%   NEWFREQS must be a vector of positive, real, increasing values.
%
%   If any value of NEWFREQS is outside of the range specified by
%   OBJ_OLD.Frequencies, then RFINTERP1 will insert NaNs into OBJ_NEW for
%   those frequency values.
%
%   OBJ_NEW = RFINTERP1(OBJ_OLD,NEWFREQS,'extrap') interpolates as above,
%   but if any value of NEWFREQS is outside of the range specified by
%   OBJ_OLD.Frequencies, then RFINTERP1 will extrapolate flat using the
%   nearest values in the frequency range.
%
%EXAMPLES:
%   % Read in the file 'default.s2p' into an sparameters object
%   S1 = sparameters('default.s2p');
%
%   % Interpolate S1 at a new set of frequencies
%   f = [1.2:0.2:2.8]*1e9;
%   S2 = rfinterp1(S1,f)
%
%   See also sparameters, rfplot, rfparam, interp1

narginchk(1,Inf)

error(message('MATLAB:UndefinedFunctionTextInputArgumentsType','rfinterp1',class(varargin{1})))