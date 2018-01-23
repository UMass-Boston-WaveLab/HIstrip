function [index1, index2] = sparamsindexes(h, parameter, nport)
%SPARAMSINDEXES Get the indexes of S-parameters.
%
%   See also RFDATA

%   Copyright 2003-2009 The MathWorks, Inc.

% Set the defaults 
index1 = 0;
index2 = 0;

if  strncmpi(parameter(1), 'S', 1) 
    idx = strfind(parameter, ',');
    if numel(idx)==1
        nport = getnport(h);
        index1 = str2double(parameter(2:idx-1));
        index2 = str2double(parameter(idx+1:end));
        if  ((0 < index1) && (index1 <= nport) && (0 < index2) &&       ...
                (index2 <= nport))
            return;
        end
    elseif (numel(parameter)==3)
        nport = getnport(h);
        index1 = str2double(parameter(2));
        index2 = str2double(parameter(3));
        if  ((0 < index1) && (index1 <= nport) && (0 < index2) &&       ...
                (index2 <= nport))
            return;
        end
    end
end

error(message('rf:rfdata:rfdata:sparamsindexes:InvalidInput', parameter));