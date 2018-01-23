function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.TXLINE

%   Copyright 2003-2007 The MathWorks, Inc.

% Check the properties
freq = get(h, 'Freq');
alphadB = get(h, 'Loss');
pv = get(h, 'PV'); 
z0 = get(h, 'Z0'); 
n = length(freq);
m1 = length(z0);
m2 = length(pv);
m3 = length(alphadB);

if ~(((n==1||n==0)&&(m1==1))||(n>1)&&(m1==1||n==m1))
    if isempty(h.Block)
        rferrhole = h.Name;
    else
        rferrhole = h.Block;
    end
    error(message('rf:rfckt:txline:checkproperty:WrongDataSizeZ0',      ...
        rferrhole));
  
end
if ~(((n==1||n==0)&&(m2==1))||(n>1)&&(m2==1||n==m2))
    if isempty(h.Block)
        rferrhole = h.Name;
    else
        rferrhole = h.Block;
    end
    error(message('rf:rfckt:txline:checkproperty:WrongDataSizePV',      ...
        rferrhole));
end
if ~(((n==1||n==0)&&(m3==1))||(n>1)&&(m3==1||n==m3))
    if isempty(h.Block)
        rferrhole = h.Name;
    else
        rferrhole = h.Block;
    end
    error(message('rf:rfckt:txline:checkproperty:WrongDataSizeLoss',    ...
        rferrhole));
end
if n~= 0
    [freq, index] = sort(freq);
    if n==length(alphadB)
        alphadB = alphadB(index);
    end
    if n ==length(pv)
        pv = pv(index);
    end
    if n==length(z0)
        z0 = z0(index);
    end
end
if strcmpi(h.StubMode, 'NotAStub') &&                                   ...
        ~strcmpi(h.Termination, 'NotApplicable')
    error(message(['rf:rfckt:txline:checkproperty:'                     ...
        'TerminationIncompatible'], h.Name, h.Termination, h.Termination));
end
if ~strcmpi(h.StubMode, 'NotAStub') &&                                  ...
        strcmpi(h.Termination, 'NotApplicable')
    error(message(['rf:rfckt:txline:checkproperty:'                     ...
        'StubModeIncompatible'], h.Name, h.StubMode, h.StubMode));
end

set(h, 'Freq', freq, 'PV', pv, 'Loss', alphadB, 'Z0', z0);