function out = setsigmadiel(h, out, prop_name)
%SETSIGMADIEL set function for sigmadiel.

% Copyright 2008 The MathWorks, Inc.
% Date: 2011/07/20 19:46:14 $

if (h.IssueWarningforNonzeroSigmaDiel) && (out ~= 0)
    warning(message('rf:rfckt:basetxline:SigmaDielNotSupportedAnyMore', ...
        prop_name, upper(class(h))));
    set(h, 'IssueWarningforNonzeroSigmaDiel', false);
end