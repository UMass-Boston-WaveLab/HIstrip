function h = createntwk(varargin)
%CREATENTWK Create LC lowpass pi ladder filter network
%
%   See also RFCKT.LCLOWPASSPI

%   Copyright 2003-2007 The MathWorks, Inc.

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC lowpass pi network
numSections = floor((numel(l)+numel(c)+1)/2);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    ckts{indx} = rfckt.shuntrlc('C', c(num));
    indx = indx+1;
    if num <= numel(l)
        ckts{indx} = rfckt.seriesrlc('L', l(num));
    end
end

% Create cascade from individual LC components
set(h, 'Ckts', ckts);