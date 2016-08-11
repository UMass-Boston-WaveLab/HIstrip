% Takes the two measured reflection matrices (left and right and converts
% them into T-parameters, yielding Gamma1 and Gamma2 matrices

function [Gamma1, Gamma2] = readin_gamma(leftgamma, rightgamma)

% Reads in the two input files in .csv format.
X = csvread(leftgamma,1,1);
Y = csvread(rightgamma,1,1);

% Gets the number of frequency points and creates 2 blank multidimensional
% matrices to store the input data.
[m,n] = size(X);
SG1 = zeros(2,2,m);
SG2 = zeros(2,2,m);

% Loops through input data, reshaping each row of data (at a frequency
% point) into a 2x2 matrix.
for ii = 1:m
    c = X(ii,:);
    d = reshape(c,2,2);
    SG1(:,:,ii) = d;
    
    e = Y(ii,:);
    f = reshape(e,2,2);
    SG2(:,:,ii) = f;
end

% Converts the measured reflection matrices into T-parameters for further
% use.
 
Gamma1 = zeros(2,2,m);
Gamma2 = zeros(2,2,m);
for ii = 1:m
    Gamma1(1,1,ii) = SG1(1,2,ii) - SG1(1,1,ii)*(1/SG1(2,1,ii))*SG1(2,2,ii);
    Gamma1(1,2,ii) = SG1(1,1,ii)*(1/SG1(2,1,ii));
    Gamma1(2,1,ii) = -(1/(SG1(2,1,ii)))*SG1(2,2,ii);
    Gamma1(2,2,ii) = 1/(SG1(2,1,ii));
    
    Gamma2(1,1,ii) = SG2(1,2,ii) - SG2(1,1,ii)*(1/SG2(2,1,ii))*SG2(2,2,ii);
    Gamma2(1,2,ii) = SG2(1,1,ii)*(1/SG2(2,1,ii));
    Gamma2(2,1,ii) = -(1/(SG2(2,1,ii)))*SG2(2,2,ii);
    Gamma2(2,2,ii) = 1/(SG2(2,1,ii));
end
end

    

    
    