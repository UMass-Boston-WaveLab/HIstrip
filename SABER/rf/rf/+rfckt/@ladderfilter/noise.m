function [cmatrix,ctype] = noise(~,freq)
%NOISE Calculate the noise correlation matrix.
%   [CMATRIX,CTYPE] = NOISE(H,FREQ) calculates the noise correlation matrix
%   of the LC Ladder RFCKT object at the specified frequencies FREQ. The
%   first input is the handle to the RFCKT object, the second input is a
%   vector for the specified freqencies.

%   Copyright 2015 The MathWorks, Inc.

% Noise is always zero for lc ladder objects
cmatrix = zeros(2,2,numel(freq));
ctype = 'ABCD CORRELATION MATRIX';