function h = read(h, filename)
%READ Read data from a .SNP, .YNP, .ZNP, .HNP or .AMP file.
%   H = READ(H, FILENAME) reads data from a data file and updates
%   properties of RFCKT object, H. FILENAME is a string, representing the
%   filename of a .SNP, .YNP, .ZNP or .AMP file.
%
%   See also RFCKT, RFCKT.RFCKT/WRITE, RFCKT.RFCKT/RESTORE

%   Copyright 2003-2009 The MathWorks, Inc.

error(message('rf:rfckt:rfckt:read:NotForThisObject', upper( class( h ) )));