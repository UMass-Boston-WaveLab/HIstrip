function setflagindexes(h)
%SETFLAGINDEXES Set the indexes for flag.
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

evalStr1 = '';
flagNames = {'NonLinear', 'TheBudgetAnalysisOn', 'NoiseOn',             ...
    'DoNonlinearAna', 'NeedToUpdate', 'ActiveNoise', 'NoiseLess',       ...
    'ThePropertyIsChecked', 'MaxNumberOfFlags'};
N = length(flagNames);
for n = 1:N-1
    flafName  = flagNames{n};
    evalStr1 = [evalStr1 sprintf('indexOf%s = %d;', flafName, n)];
end;
flagName  = flagNames{N};
evalStr1 = [evalStr1 sprintf('%s = %d;', flagName, N)];
evalin('caller',evalStr1);
return