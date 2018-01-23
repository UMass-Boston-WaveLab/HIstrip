function outMatrix=convertmatrix(h,inMatrix,inType,outType,z0,          ...
    z0_option,iteration)
%CONVERTMATRIX Convert the network parameters.
%   OUTMATRIX = CONVERTMATRIX(H, INMATRIX, INTYPE, OUTTYPE, Z0, Z0_OPTION)
%   converts the input network parameters INMATRIX to the specified output
%   type OUTTYPE and returns it. If there is only one S_PARAMETERS (either
%   INTYPE or OUTTYPE), Z0 is the reference impedance of the S-parameters.
%   If both INTYPE and OUTTYPE are S_PARAMETERS, Z0 is for INMATRIX while
%   Z0_OPTION for OUTMATRIX.
%
%   INMATRIX is a complex NxNxM array, representing M N-port network
%            parameters.
%   INTYPE:    'ABCD PARAMETERS', 'S PARAMETERS', 'Y PARAMETERS'
%              'Z PARAMETERS', 'H PARAMETERS', 'G PARAMETERS',
%              'T PARAMETERS'
%   OUTTYPE:    'ABCD PARAMETERS', 'S PARAMETERS', 'Y PARAMETERS'
%               'Z PARAMETERS', 'H PARAMETERS', 'G PARAMETERS',
%               'T PARAMETERS'
%   Z0 is the reference impedance of S-parameters. Z0_OPTION is an optional
%   reference impedance of S-parameter matrix. The defaults of Z0 and
%   Z0_OPTION are 50 ohms. 
%   OUTMATRIX is a complex NxNxM array, representing M N-port network
%             parameters.
%
%   See also RFDATA

%   Copyright 2003-2016 The MathWorks, Inc.

% Check the input network parameters
if isempty(inMatrix)
    error(message('rf:rfdata:rfdata:convertmatrix:NoInput'));
end
[n1,n2,m] = size(inMatrix);
if (n1 ~= n2)
    error(message('rf:rfdata:rfdata:convertmatrix:WrongMatrix'));
end

% Set the default result
outMatrix = [];

inType = upper(inType);
outType = upper(outType);

% Get Z0
if nargin < 5
    z0 = 50;
end
    
% Get Z0_OPTION
if nargin < 6
    z0_option = 50;
end

% Do matrix conversion if the method is available
switch inType
case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
    switch outType
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = abcd2s(inMatrix, z0);
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = abcd2y(inMatrix);
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = abcd2z(inMatrix);
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = abcd2h(inMatrix);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(abcd2h(inMatrix));
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(abcd2s(inMatrix, z0));
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = inMatrix;
        return;
        otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
    switch outType
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = y2s(inMatrix, z0);
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = y2z(inMatrix);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = y2abcd(inMatrix);
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = y2h(inMatrix);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(y2h(inMatrix));
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(y2s(inMatrix, z0));
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = inMatrix;
        return;
    otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
    switch outType
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = z2s(inMatrix, z0);
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = z2y(inMatrix);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = z2abcd(inMatrix);
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = z2h(inMatrix);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(z2h(inMatrix));
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(z2s(inMatrix, z0));
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = inMatrix;
        return;
    otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
    switch outType
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = s2y(inMatrix, z0);
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = s2z(inMatrix, z0);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = s2abcd(inMatrix, z0);
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = s2h(inMatrix, z0);
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(inMatrix);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(s2h(inMatrix, z0));
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = s2s(inMatrix, z0, z0_option);
    otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
    switch outType
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = h2y(inMatrix);
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = h2z(inMatrix);
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = h2s(inMatrix, z0);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = h2abcd(inMatrix);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(inMatrix);
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = inMatrix;
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(h2s(inMatrix, z0));
    otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
    switch outType
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = h2y(g2h(inMatrix));
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = h2z(g2h(inMatrix));
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = h2s(g2h(inMatrix), z0);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = h2abcd(g2h(inMatrix));
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = inMatrix;
        return;
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = g2h(inMatrix);
    case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(h2s(g2h(inMatrix), z0));
   otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
    switch outType
    case {'Y PARAMETERS' 'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = s2y(t2s(inMatrix), z0);
    case {'Z PARAMETERS' 'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = s2z(t2s(inMatrix), z0);
    case {'S PARAMETERS' 'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = t2s(inMatrix);
    case {'ABCD PARAMETERS' 'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = s2abcd(t2s(inMatrix), z0);
    case {'G PARAMETERS' 'G_PARAMETERS' 'G-PARAMETERS' 'G_PARAMS' 'G-PARAMS' 'G'}
        outMatrix = h2g(s2h(t2s(inMatrix), z0));
    case {'H PARAMETERS' 'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = s2h(t2s(inMatrix), z0);
     case {'T PARAMETERS' 'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = inMatrix;
        return;
    otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
    end
otherwise
         error(message('rf:rfdata:rfdata:convertmatrix:NoConversionMethod', inType, outType));
end


% Check the output
index = any(any(isnan(outMatrix)));
if any(index)
    if nargin < 7
        iteration = 0;
    end
    iteration = iteration + 1;
    if iteration > 10
        error(message('rf:rfdata:rfdata:convertmatrix:MatrixNotExist', inType, outType));
    end
    m = length(index);
    z0 = z0 + eps;
    z0_option = z0_option + eps;
    outMatrix = convertmatrix(h,inMatrix,inType,outType,z0,z0_option,iteration);
end