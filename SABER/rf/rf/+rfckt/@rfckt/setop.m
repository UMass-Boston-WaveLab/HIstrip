function varargout = setop(h, varargin)
%SETOP Set operating conditions.
%   SETOP(H, CONDITION1, VALUE1, CONDITION2, VALUE2, ...) changes the
%   operating conditions of the data object, h, to those specified by the
%   condition/value pairs.
%
%   SETOP(H, CONDITION1) lists the available values for the specified
%   operating condition 'CONDITION1'.
%
%   SETOP(H) lists the available values for all operating conditions of the
%   object, h.
%
%   See also RFCKT, RFCKT.RFCKT/GETOP

%   Copyright 2006-2009 The MathWorks, Inc.

error(nargoutchk(0, 1, nargout))

if ~isa(h.AnalyzedResult, 'rfdata.data')
    error(message('rf:rfckt:rfckt:setop:NotForThisObject', h.Name));
end
if nargout == 1
    varargout{1} = setop(h.AnalyzedResult, varargin{:});
else % nargout == 0
    setop(h.AnalyzedResult, varargin{:});
end