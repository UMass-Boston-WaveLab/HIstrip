% Function takes in  S-parameters formatted as two separate csv files, 
% one for the real part, and one for the imag part. HFSS rect data is wrong
% and you shouldn't use it.

function [complexData, realFrequencyPoints, realDepth] = readin_HFSS(realfile,imfile)

% Reads in the real data. Separates the measured frequency points and the
% data into two separate matrices.
realPart = csvread(realfile,1,0);
realData = realPart(:,2:end);
realFrequencyPoints = realPart(1:end,1);
[realDepth, ~] = size(realFrequencyPoints);

% Reads in the im data. Separates the measured frequency points and the
% data into two separate matrices.
imagPart = csvread(imfile,1,0);
imagData = imagPart(:,2:end);
imagFrequencyPoints = imagPart(1:end,1);

% Checks if the real and imaginary data have the same measured freq. points
% and the same size. Throws error if not. 
if realFrequencyPoints ~= imagFrequencyPoints
    error('Frequency points not the same.')
end

if size(realData) ~= size(imagData)
    error('Matrix sizes not the same.')
end

% Adds the i component to the imaginary data and combines the matrices into
% a rectangular representation of the S-parameter data.
imagData = imagData * 1i;
complexData = realData + imagData;