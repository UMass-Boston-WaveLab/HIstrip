function varargout = smith(varargin) %#ok<STOUT>
%--------------------------------------------------------------------------
%   For help on SMITH for rfdata.data objects, type:
%   <a href="matlab:help rfdata.data/smith">help rfdata.data/smith</a>
%--------------------------------------------------------------------------
%SMITH Plot network parameter data on a smith chart
%   SMITH(OBJ,I,J) plots the (I,J)th parameter of OBJ on a smith chart. I
%   and J must be positive integers whose value is less than or equal to
%   the number of ports represented by OBJ.  OBJ must be a network
%   parameter object of one of the following types: sparameters,
%   tparameters, yparameters, zparameters, hparameters, gparameters, or
%   abcdparameters.
%
%   HLINES = SMITH(...) returns a column vector of handles to the line
%   objects, where HLINES contains one handle per line plotted.
%
%EXAMPLES:
%   % Read in the file 'default.s2p' into an sparameters object
%   S = sparameters('default.s2p');
%
%   % Plot the reflection coefficient S11 on a smith chart
%   smith(S,1,1)
%
%   See also rfplot, rfparam, rfinterp1

narginchk(1,Inf)

error(message('MATLAB:UndefinedFunctionTextInputArgumentsType','smith',class(varargin{1})))