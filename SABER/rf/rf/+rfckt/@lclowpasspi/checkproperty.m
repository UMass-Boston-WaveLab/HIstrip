function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.LCLOWPASSPI

%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = numel(c) - numel(l);
if (diffcomp~=0) && (diffcomp~=1)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:lclowpasspi:checkproperty:InvalidLC',       ...
        rferrhole));
end

% Check if number of C
if (numel(c) < 1)
    rferrhole = '';
    if isempty(h.Block)
        rferrhole = [h.Name, ': '];
    end
    error(message('rf:rfckt:lclowpasspi:checkproperty:MinimumC',        ...
        rferrhole));
end

% Call createntwk method to build LC lowpass pi network
createntwk(h);