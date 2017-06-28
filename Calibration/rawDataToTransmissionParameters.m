% Function makes calls to helpers to completely process incoming raw
% S-Parameters into T-Parameters. Used for the thru, line, and 4x4 DUTs.

function [T] = rawDataToTransmissionParameters(realFile, imagFile)

% Get the raw data into an unformatted complex matrix.
[complexData, realFrequencyPoints, realDepth] = ...
    readin_HFSS(realFile,imagFile);

% Process the data into 2x2 submatrices.
[S11, S12, S21, S22] = generalized_S(complexData, realDepth, 4);

% Convert the 2x2 S-parameter submatrices into a 4x4 T-parameter matrix.
T = genS_to_genT(S11, S12, S21, S22, realDepth);