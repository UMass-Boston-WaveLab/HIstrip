function [cmatrix,ctype] = noise(h,freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX,CTYPE] = NOISE(H,FREQ) calculates the noise correlation matrix
%   of the RFCKT object at the specified frequencies FREQ. The first input
%   is the handle to the RFCKT object, the second input is a vector for the
%   specified freqencies.
%
%   See also RFCKT.SERIES

%   Copyright 2015 The MathWorks, Inc.

data = rfdata.data;

allckts = get(h,'CKTS');
numckts = numel(allckts);

% Calculate noise correlation matrix for first circuit
ckt = allckts{1};
[ckt_type,ckt_params,ckt_z0] = nwa(ckt,freq);
[cmatrix,ctype] = noise(ckt,freq);

if numckts > 1
    % Convert correlation matrix of 1st circuit type to Z
    old_ctype = ctype;
    ctype = 'Z CORRELATION MATRIX';
    cmatrix = convertcorrelationmatrix(data,cmatrix,old_ctype,ctype, ...
        ckt_params,ckt_type,ckt_z0);
    
    for nn = 2:numckts
        % Calculate Z correlation matrix of nn'th circuit.
        ckt = allckts{nn};
        [ckt_type,ckt_params,ckt_z0] = nwa(ckt,freq);
        [ckt_cmatrix,ckt_ctype] = noise(ckt,freq);
        ckt_cmatrix = convertcorrelationmatrix(data,ckt_cmatrix, ...
            ckt_ctype,ctype,ckt_params,ckt_type,ckt_z0);
        
        % Sum correlation matricies
        cmatrix = cmatrix + ckt_cmatrix;
    end
end