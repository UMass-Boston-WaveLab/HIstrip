% Function makes calls to helpers to completely process incoming raw
% S-Parameters into formatted S-Parameters. Used for the reflect and any
% 2x2 DUTS.

function [S] = rawDataToScatteringParameters(realFile, imagFile, sq_size )

% Get the raw data into an unformatted complex matrix.
[complexData, realFrequencyPoints, realDepth] = ...
    readin_HFSS(realFile,imagFile);

% Process the data into a 2x2 S-Parameter matrix.
[~, ~, ~, ~, S] = generalized_S(complexData, realDepth, sq_size);