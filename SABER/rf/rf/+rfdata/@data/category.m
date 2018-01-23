function dcategory = category(h, parameter)
%CATEGORY Check and find the category of the specified parameter.
%   DCATEGORY = CATEGORY(H, PARAMETER) checks the PARAMETER and returns
%   its category. 
%
%   Type LIST(H) to see the valid parameter for the RFDATA.DATA object.
%
%   See also RFDATA.DATA

%   Copyright 2003-2010 The MathWorks, Inc.

% Set the default
dcategory = '';

% Check the data to find its category
switch upper(parameter)
    case {'POUT' 'PHASE'}
        dcategory = 'Power Parameters';
    case {'AM/AM' 'AM/PM'}
        dcategory = 'AMAM/AMPM Parameters';
    case {'FMIN' 'GAMMAOPT' 'RN'}
        dcategory = 'Noise Parameters';
    case {'PHASENOISE'}
        dcategory = 'Phase Noise';
    case {'GAMMAIN' 'GAMMAOUT' 'VSWRIN' 'VSWROUT' 'NF' 'NFACTOR' 'NTEMP' 'OIP3' 'IIP3' 'OIP2' 'IIP2'}
        dcategory = 'Network Parameters';
    case {'LS11', 'LS21', 'LS12', 'LS22'}
        dcategory = 'Large Parameters';
    case {'GT', 'GA', 'GP', 'GMAG', 'GMSG' 'GAMMAMS' 'GAMMAML' 'TF1' 'TF2' 'TF3'}
        dcategory = 'Network Parameters';  
    case {'K' 'MU' 'MUPRIME' 'DELTA' 'GROUPDELAY'}
        dcategory = 'Network Parameters'; 
    otherwise
        if strncmpi(parameter, 'S', 1)
            idx = strfind(parameter, ',');
            if numel(idx)==1
                nport = getnport(h);
                index1 = str2double(parameter(2:idx-1));
                index2 = str2double(parameter(idx+1:end));
                if (~isempty(get(h,'Freq')) &&                          ...
                        ~isempty(get(h,'S_Parameters')))
                    if  ((0 < index1) && (index1 <= nport) &&           ...
                            (0 < index2) && (index2 <= nport))
                        dcategory = 'Network Parameters';
                    end
                end
            elseif (numel(parameter)==3)
                nport = getnport(h);
                index1 = str2double(parameter(2));
                index2 = str2double(parameter(3));
                if (~isempty(get(h,'Freq')) &&                          ...
                        ~isempty(get(h,'S_Parameters')))
                    if  ((0 < index1) && (index1 <= nport) &&           ...
                            (0 < index2) && (index2 <= nport))
                        dcategory = 'Network Parameters';
                    end
                end
            end
        end
end

if isempty(dcategory)
    error(message('rf:rfdata:data:category:InvalidInput', parameter));
end