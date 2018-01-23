function [resp, freq] = freqresp(h, freq)
%FREQRESP Compute the frequency response of a rational function object.
%   [RESP, FREQ] = FREQRESP(H, FREQ) computes the frequency response of the
%   rational function object, H, at the frequencies specified by the input
%   FREQ.
%
%   H is the handle to the RFMODEL.RATIONAL object. FREQ is a vector of
%   frequencies, in Hz, over which the frequency response will be
%   calculated. 
%
%   See also RFMODEL, RFMODEL.RFMODEL/TIMERESP, RFMODEL.RFMODEL/WRITEVA,
%   RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

error(message('rf:rfmodel:rfmodel:freqresp:NotForThisObject',           ...
    upper( class( h ) )));