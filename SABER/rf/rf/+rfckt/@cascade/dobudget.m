function dobudget(h)
%DOBUDGET Set the flag for budget analysis.
%   DOBUDGET(H) sets the flag for budget analysis.
%
%   See also RFCKT.CASCADE

%   Copyright 2004-2007 The MathWorks, Inc.

setflagindexes(h);
%Set the flag for budget analysis.
updateflag(h, indexOfTheBudgetAnalysisOn, 1, MaxNumberOfFlags);
updateflag(h, indexOfNeedToUpdate, 1, MaxNumberOfFlags);