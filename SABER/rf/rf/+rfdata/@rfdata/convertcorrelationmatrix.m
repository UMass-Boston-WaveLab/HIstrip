function outCMatrix = convertcorrelationmatrix(h,inCMatrix,inCType, ...
    outCType,inNetParams,inNetParamsType,z0)
%CONVERTCORRELATIONMATRIX Convert the noise correlation matrix.
%   OUTMATRIX = CONVERTCORRELATIONMATRIX(H,INCMATRIX,INCTYPE,OUTCTYPE,
%   INNETPARAMS,INNETPARAMSTYPE,Z0,Z0_OPTION) converts the input noise
%   correlation matrix INCMATRIX to the specified output noise correlation
%   matrix type OUTCTYPE and returns it.
%
%   INCMATRIX is a NxNxM array, representing M N-port noise correlation
%             matrix.
%   INCTYPE:    'ABCD CORRELATION MATRIX', 'Z CORRELATION MATRIX',
%               'Y CORRELATION MATRIX'
%   OUCTTYPE:   'ABCD CORRELATION MATRIX', 'Z CORRELATION MATRIX',
%               'Y CORRELATION MATRIX'
%   INNETPARAMS is a NxNxM array, representing M N-port network parameters.
%   INNETPARAMSTYPE:    'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%               'Z_PARAMETERS', 'H_PARAMETERS', 'T_PARAMETERS'
%   Z0 is the reference impedance of S-parameters. Z0_OPTION is an optional
%   reference impedance of S-parameter matrix. The defaults of Z0 and
%   Z0_OPTION are 50 ohms.
%   OUTMATRIX is a NxNxM array, representing M N-port noise
%             correlation matrix.
%
%   See also RFDATA

%   Copyright 2003-2015 The MathWorks, Inc.

% Check the input matrices
if isempty(inNetParams)
    error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoInputNetworkParameters'))
end
[n1,n2,~] = size(inNetParams);
if (n1 ~= n2)
    error(message('rf:rfdata:rfdata:convertcorrelationmatrix:WrongNetworkParameters'))
end
if isempty(inCMatrix)
    error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoInputCorrelationMatrix'))
end
[n1,n2,~] = size(inCMatrix);
if (n1 ~= n2)
    error(message('rf:rfdata:rfdata:convertcorrelationmatrix:WrongCorrelationMatrix'))
end

% Get Z0
if nargin < 7
    z0 = 50;
end

inCType = upper(inCType);
outCType = upper(outCType);

% Set the default result
outCMatrix = NaN;

for iter = 0:10
    if any(isnan(outCMatrix(:)))
        % Do matrix conversion if the method is available
        switch outCType
            case 'ABCD CORRELATION MATRIX'
                switch inCType
                    case 'Y CORRELATION MATRIX'
                        outCMatrix = cy2cabcd(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Z CORRELATION MATRIX'
                        outCMatrix = cz2cabcd(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'H CORRELATION MATRIX'
                        outCMatrix = ch2cabcd(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'G CORRELATION MATRIX'
                        outCMatrix = cg2cabcd(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'ABCD CORRELATION MATRIX'
                        outCMatrix = inCMatrix;
                        return
                    otherwise
                        error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
                end
            case 'Y CORRELATION MATRIX'
                switch inCType
                    case 'Z CORRELATION MATRIX'
                        outCMatrix = cz2cy(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'ABCD CORRELATION MATRIX'
                        outCMatrix = cabcd2cy(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'H CORRELATION MATRIX'
                        outCMatrix = ch2cy(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'G CORRELATION MATRIX'
                        outCMatrix = cg2cy(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Y CORRELATION MATRIX'
                        outCMatrix = inCMatrix;
                        return
                    otherwise
                        error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
                end
            case 'Z CORRELATION MATRIX'
                switch inCType
                    case 'Y CORRELATION MATRIX'
                        outCMatrix = cy2cz(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'ABCD CORRELATION MATRIX'
                        outCMatrix = cabcd2cz(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'H CORRELATION MATRIX'
                        outCMatrix = ch2cz(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'G CORRELATION MATRIX'
                        outCMatrix = cg2cz(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Z CORRELATION MATRIX'
                        outCMatrix = inCMatrix;
                        return
                    otherwise
                        error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
                end
            case 'H CORRELATION MATRIX'
                switch inCType
                    case 'ABCD CORRELATION MATRIX'
                        outCMatrix = cabcd2ch(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Y CORRELATION MATRIX'
                        outCMatrix = cy2ch(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Z CORRELATION MATRIX'
                        outCMatrix = cz2ch(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'G CORRELATION MATRIX'
                        outCMatrix = cg2ch(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'H CORRELATION MATRIX'
                        outCMatrix = inCMatrix;
                        return
                    otherwise
                        error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
                end
            case 'G CORRELATION MATRIX'
                switch inCType
                    case 'ABCD CORRELATION MATRIX'
                        outCMatrix = cabcd2cg(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Y CORRELATION MATRIX'
                        outCMatrix = cy2cg(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'Z CORRELATION MATRIX'
                        outCMatrix = cz2cg(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'H CORRELATION MATRIX'
                        outCMatrix = ch2cg(h,inCMatrix,inNetParams, ...
                            inNetParamsType,z0);
                    case 'G CORRELATION MATRIX'
                        outCMatrix = inCMatrix;
                        return
                    otherwise
                        error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
                end
            otherwise
                error(message('rf:rfdata:rfdata:convertcorrelationmatrix:NoConversionMethod',inCType,outCType))
        end
        z0 = z0 + eps(z0);
    else
        return
    end
end

error(message('rf:rfdata:rfdata:convertcorrelationmatrix:MatrixNotExist',outCType))


function cabcd = cy2cabcd(h,cy,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(2,1,:) = 1;
t(1,2,:) = abcd(1,2,:);
t(2,2,:) = abcd(2,2,:);
cabcd = zeros(2,2,nfreq);
for ii = 1:nfreq
    cabcd(:,:,ii) = t(:,:,ii)*cy(:,:,ii)*t(:,:,ii)';
end


function cabcd = cz2cabcd(h,cz,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(1,1,:) = 1;
t(1,2,:) = -abcd(1,1,:);
t(2,2,:) = -abcd(2,1,:);
cabcd = zeros(2,2,nfreq);
for ii = 1:nfreq
    cabcd(:,:,ii) = t(:,:,ii)*cz(:,:,ii)*t(:,:,ii)';
end


function cabcd = ch2cabcd(h,ch,netparams,type,z0)
t = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
t(1,1,:) = 1;
t(2,1,:) = 0;
nfreq = size(t,3);
cabcd = zeros(2,2,nfreq);
for ii = 1:nfreq
    cabcd(:,:,ii) = t(:,:,ii)*ch(:,:,ii)*t(:,:,ii)';
end


function cabcd = cg2cabcd(h,cg,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(2,1,:) = 1;
t(1,2,:) = -abcd(1,1,:);
t(2,2,:) = -abcd(2,1,:);
cabcd = zeros(2,2,nfreq);
for ii = 1:nfreq
    cabcd(:,:,ii) = t(:,:,ii)*cg(:,:,ii)*t(:,:,ii)';
end


function cy = cz2cy(h,cz,netparams,type,z0)
% Can occur when an rfckt.series is inside an rfckt.parallel
y = convertmatrix(h,netparams,type,'Y_PARAMETERS',z0);
[n1,n2,nfreq] = size(y);
cy = zeros(n1,n2,nfreq);
for ii = 1:nfreq
    cy(:,:,ii) = y(:,:,ii)*cz(:,:,ii)*y(:,:,ii)';
end


function cy = cabcd2cy(h,cabcd,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(2,1,:) = 1;
t(1,2,:) = abcd(1,2,:);
t(2,2,:) = abcd(2,2,:);
cy = zeros(2,2,nfreq);
for ii = 1:nfreq
    if any(any(cabcd(:,:,ii) ~= 0))
        cy(:,:,ii) = t(:,:,ii)\cabcd(:,:,ii)/t(:,:,ii)';
    end
end


function cy = ch2cy(h,ch,netparams,type,z0)
% Can occur when an rfckt.hybrid is inside an rfckt.parallel
cabcd = ch2cabcd(h,ch,netparams,type,z0);
cy = cabcd2cy(h,cabcd,netparams,type,z0);


function cy = cg2cy(h,cg,netparams,type,z0)
% Can occur when an rfckt.hybridg is inside an rfckt.parallel
cabcd = cg2cabcd(h,cg,netparams,type,z0);
cy = cabcd2cy(h,cabcd,netparams,type,z0);


function cz = cy2cz(h,cy,netparams,type,z0)
% Can occur when an rfckt.parallel is inside an rfckt.series
z = convertmatrix(h,netparams,type,'Z_PARAMETERS',z0);
[n1,n2,nfreq] = size(z);
cz = zeros(n1,n2,nfreq);
for ii = 1:nfreq
    cz(:,:,ii) = z(:,:,ii)*cy(:,:,ii)*z(:,:,ii)';
end


function cz = cabcd2cz(h,cabcd,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(1,1,:) = 1;
t(1,2,:) = -abcd(1,1,:);
t(2,2,:) = -abcd(2,1,:);
cz = zeros(2,2,nfreq);
for ii = 1:nfreq
    if any(any(cabcd(:,:,ii) ~= 0))
        cz(:,:,ii) = t(:,:,ii)\cabcd(:,:,ii)/t(:,:,ii)';
    end
end


function cz = ch2cz(h,ch,netparams,type,z0)
% Can occur when an rfckt.hybrid is inside an rfckt.series
cabcd = ch2cabcd(h,ch,netparams,type,z0);
cz = cabcd2cz(h,cabcd,netparams,type,z0);


function cz = cg2cz(h,cg,netparams,type,z0)
% Can occur when an rfckt.hybridg is inside an rfckt.series
cabcd = cg2cabcd(h,cg,netparams,type,z0);
cz = cabcd2cz(h,cabcd,netparams,type,z0);


function ch = cabcd2ch(h,cabcd,netparams,type,z0)
t = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
t(1,1,:) = 1;
t(2,1,:) = 0;
nfreq = size(t,3);
ch = zeros(2,2,nfreq);
for ii = 1:nfreq
    if any(any(cabcd(:,:,ii) ~= 0))
        ch(:,:,ii) = t(:,:,ii)\cabcd(:,:,ii)/t(:,:,ii)';
    end
end


function ch = cy2ch(h,cy,netparams,type,z0)
% Can occur when an rfckt.parallel is inside an rfckt.hybrid
cabcd = cy2cabcd(h,cy,netparams,type,z0);
ch = cabcd2ch(h,cabcd,netparams,type,z0);


function ch = cz2ch(h,cz,netparams,type,z0)
% Can occur when an rfckt.series is inside an rfckt.hybrid
cabcd = cz2cabcd(h,cz,netparams,type,z0);
ch = cabcd2ch(h,cabcd,netparams,type,z0);


function ch = cg2ch(h,cg,netparams,type,z0)
% Can occur when an rfckt.hybridg is inside an rfckt.hybrid
cabcd = cg2cabcd(h,cg,netparams,type,z0);
ch = cabcd2ch(h,cabcd,netparams,type,z0);


function cg = cabcd2cg(h,cabcd,netparams,type,z0)
abcd = convertmatrix(h,netparams,type,'ABCD_PARAMETERS',z0);
nfreq = size(abcd,3);
t = zeros(2,2,nfreq);
t(2,1,:) = 1;
t(1,2,:) = -abcd(1,1,:);
t(2,2,:) = -abcd(2,1,:);
cg = zeros(2,2,nfreq);
for ii = 1:nfreq
    if any(any(cabcd(:,:,ii) ~= 0))
        cg(:,:,ii) = t(:,:,ii)\cabcd(:,:,ii)/t(:,:,ii)';
    end
end


function cg = cy2cg(h,cy,netparams,type,z0)
% Can occur when an rfckt.parallel is inside an rfckt.hybridg
cabcd = cy2cabcd(h,cy,netparams,type,z0);
cg = cabcd2cg(h,cabcd,netparams,type,z0);


function cg = cz2cg(h,cz,netparams,type,z0)
% Can occur when an rfckt.series is inside an rfckt.hybridg
cabcd = cz2cabcd(h,cz,netparams,type,z0);
cg = cabcd2cg(h,cabcd,netparams,type,z0);


function cg = ch2cg(h,ch,netparams,type,z0)
% Can occur when an rfckt.hybrid is inside an rfckt.hybridg
cabcd = ch2cabcd(h,ch,netparams,type,z0);
cg = cabcd2cg(h,cabcd,netparams,type,z0);