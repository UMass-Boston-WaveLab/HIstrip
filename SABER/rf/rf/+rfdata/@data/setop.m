function varargout = setop(h, varargin)
%SETOP Set operating conditions.
%   SETOP(H,CONDITION1,VALUE1,CONDITION2,VALUE2,...) changes the operating
%   conditions of the data object, h, to those specified by the
%   condition/value pairs.
%
%   SETOP(H,CONDITION1) lists the available values for the specified
%   operating condition 'CONDITION1'.
%
%   SETOP(H) lists the available values for all operating conditions of the
%   object, h.
%
%   See also RFDATA.DATA, RFDATA.DATA/GETOP

%   Copyright 2006-2007 The MathWorks, Inc.

error(nargoutchk(0, 1, nargout))

if hasmultireference(h)
    if numel(varargin) > 1 % Change operating conditions
        if nargout == 1
            error(message('rf:rfdata:data:setop:TooManyOutput'))
        end
        checkcondition(h, varargin{:});
        varargin = simplifycondition(h, varargin);
        changeop(h.Reference, varargin{:});
    elseif numel(varargin) == 1
        if ischar(varargin{1})
            if nargout == 1
                varargout{1} = getallvalues(h.Reference, varargin{1});
            else
                getallvalues(h.Reference, varargin{1});
            end
        else
            if nargout == 1
                error(message('rf:rfdata:data:setop:TooManyOutput'))
            end
            changeop(h.Reference, varargin{1});
        end
    else % List all operating conditions
        if nargout == 1
            varargout{1} = listop(h.Reference);
        else
            listop(h.Reference);
        end
    end

else
    error(message('rf:rfdata:data:setop:NotForThisObject', h.Name))
end