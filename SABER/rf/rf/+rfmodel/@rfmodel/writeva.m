function status = writeva(h, filename, innets, outnets, discipline,     ...
    printformat, filestoinclude)
%WRITEVA Write Verilog-A description of a rational function object.
%   STATUS = WRITEVA(H, FILENAME, INNETS, OUTNETS, DISCIPLINE, PRINTFORMAT,
%   FILESTOINCLUDE) writes a Verilog-A module that describes a rational
%   function object, H, to the file specified by filename. The function
%   implements the object as Laplace Transform S-domain filters in
%   Verilog-A. It returns a status of True if the operation is successful
%   and False otherwise.
% 
%   H is the handle to the RFMODEL.RATIONAL object. FILENAME is a string
%   representing the name of the Verilog-A file to which to write the
%   module. INNETS is a string or a cell of two strings that specifies the
%   name of each of the module?s input nets. OUTNETS is a string or a cell
%   of two strings that specifies the name of each of the module?s output
%   nets. DISCIPLINE is a string that specifies the predefined Verilog-A
%   discipline of the nets. PRINTFORMAT is a string that specifies the
%   precision of the numerator and denominator coefficients of the
%   Verilog-A filter using the C language conversion specifications.
%   FILESTOINCLUDE is a cell of strings that specifies a list of header
%   files to include in the module using Verilog-A '`include' statements.
%
%   See also RFMODEL, RFMODEL.RFMODEL/FREQRESP, RFMODEL.RFMODEL/TIMERESP,
%   RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

error(message('rf:rfmodel:rfmodel:writeva:NotForThisObject',            ...
    upper( class( h ) )));