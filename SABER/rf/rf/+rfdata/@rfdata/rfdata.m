classdef (CaseInsensitiveProperties,TruncatedProperties)                ...
        rfdata < rfbase.rfbase
%rfdata.rfdata class
%   rfdata.rfdata extends rfbase.rfbase.
%
%    rfdata.rfdata properties:
%       Name - Property is of type 'string' (read only)
%
%    rfdata.rfdata methods:
%       checkcondition - Check if operating conditions are valid.
%       checknport -  Throw an error when number of ports is not as
%                     expected.
%       convertcorrelationmatrix - Convert the noise correlation matrix.
%       convertmatrix - Convert the network parameters.
%       expandcondition - Expand vector condition values into multiple
%                         conditions.
%       modifyname - Modify the parameter name for plot.
%       noisefigure - Calculate the noise figure.
%       simplifycondition - Remove irrelevant operating conditions.
%       sparamsindexes - Get the indexes of S-parameters.



    methods  % method signatures
        checkcondition(h,varargin)
        checknport(h,actn,expn,fname,classname)
        outCMatrix = convertcorrelationmatrix(h,inCMatrix,inCType,      ...
            outCType,inNetParams,inNetParamsType,z0)
        outMatrix = convertmatrix(h,inMatrix,inType,outType,z0,         ...
            z0_option,iteration)
        conditions = expandcondition(h,conditions)
        out = modifyname(h,parameter,nport)
        nf = noisefigure(h,cabcd,zs)
        conditions = simplifycondition(h,conditions)
        [index1,index2] = sparamsindexes(h,parameter,nport)
    end  % method signatures
    
end  % classdef