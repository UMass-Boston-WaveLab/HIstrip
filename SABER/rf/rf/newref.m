function newobj = newref(varargin) %#ok<STOUT>
%NEWREF Convert an sparameters object using a new impedance value
%   S_OBJ_NEW = NEWREF(S_OBJ_OLD,NEWZ) converts the sparameters object
%   S_OBJ_OLD with impedance S_OBJ_OLD.Impedance into a new sparameters
%   object S_OBJ_NEW with the new reference impedance NEWZ.  S_OBJ_OLD must
%   be an sparameters object, and NEWZ must be a positive, real, numeric
%   scalar.
%
%EXAMPLES:
%   % Read in the file 'default.s2p' into an sparameters object
%   S1 = sparameters('default.s2p');
%
%   % Calculate S as if it were measured with 40 Ohms
%   S2 = newref(S1,40);
%
%   See also sparameters, rfplot, rfparam, rfinterp1

narginchk(2,2)
nargoutchk(0,1)

error(message('MATLAB:UndefinedFunctionTextInputArgumentsType','newref',class(varargin{1})))