% Function takes in  S-parameters formatted as two separate csv files, 
% one for the real part, and one for the im. part. HFSS rect data is wrong
% and you shouldn't use it.

function [M,re_frequency_sweep,depth,sq_size] = readin_HFSS(realfile,imfile)

% Reads in the real data. Separates the measured frequency points and the
% data into two separate matrices.
realpart = csvread(realfile,1,0);
M = realpart(:,2:end);
re_frequency_sweep = realpart(1:end,1);
[m,n] = size(M);
sq_size = sqrt(n);
depth = m;

% Reads in the im data. Separates the measured frequency points and the
% data into two separate matrices.
impart = csvread(imfile,1,0);
N = impart(:,2:end);
frequency_sweep_im = impart(1:end,1);
[a,b] = size(N);
im_sq_size = sqrt(b);
depth2 = a;


% Checks if the real and imaginary data have the same measured freq. points
% and the same size. Raises error if not. This just checks if each device
% is internally consistent; the sanitycheck.m function checks each device
% against the others.

if depth ~= depth2
    error('Frequency points not the same.')
end

if sq_size ~= im_sq_size
    error('Matrix data not the same.')
end

% Adds the i component to the imaginary data and combines the matrices into
% a rectangular representation of the S-parameter data.
N = i*N;

M = M+N;
end
