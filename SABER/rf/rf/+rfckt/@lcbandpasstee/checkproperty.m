function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.LCBANDPASSTEE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = numel(l) - numel(c);
if (diffcomp~=0)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:lcbandpasstee:checkproperty:InvalidLC',     ...
        rferrhole));
end

% Check if number of L,C is atleast 3
if (numel(l) < 1) 
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:lcbandpasstee:checkproperty:MinimumL',      ...
        rferrhole));
end

% Call createntwk method to build LC bandpass tee network
createntwk(h);