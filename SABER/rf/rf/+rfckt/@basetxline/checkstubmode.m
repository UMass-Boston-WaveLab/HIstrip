function checkstubmode(h)
%CHECKSTUBMODE Check the StubMode and Termination of the object.
%
%   See also RFCKT.BASETXLINE

%   Copyright 2004-2007 The MathWorks, Inc.

% Check the properties

if strcmpi(h.StubMode, 'NotAStub') &&                                   ...
        ~strcmpi(h.Termination, 'NotApplicable')
    error(message(['rf:rfckt:basetxline:checkstubmode:'                 ...
        'TerminationIncompatible'], h.Name, h.Termination, h.Termination));
end
if ~strcmpi(h.StubMode, 'NotAStub') &&                                  ...
        strcmpi(h.Termination, 'NotApplicable')
    error(message(['rf:rfckt:basetxline:checkstubmode:'                 ...
        'StubModeIncompatible'], h.Name, h.StubMode, h.StubMode));
end