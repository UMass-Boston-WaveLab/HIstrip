function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFDATA.POWER
  
%   Copyright 2003-2007 The MathWorks, Inc.

% Get the properties
freq = get(h, 'Freq');
pin = get(h, 'Pin');
pout = get(h, 'Pout');
phase = get(h, 'Phase');
n = numel(freq);
m1 = numel(pin);
m2 = numel(pout);
m3 = numel(phase);
if ((n ==0) && ~((m1 == 1) && (m2 == 1) && ((m3==0) ||(m3==1)))) ||     ...
        (~(n ==0) && ~((n==m1) && (n==m2) && ((m3==0) ||(n==m3))))
    error(message('rf:rfdata:power:checkproperty:WrongDataSize'));
end
for ii=1:m1
    pini = pin{ii};
    pouti = pout{ii};
    n1 = numel(pini); 
    n2 = numel(pouti); 
    if isempty(phase)
        phasei = [];
        n3 = n2;
    else
       phasei = phase{ii};
       n3 = numel(phasei); 
   end
   if ~((n1==n2) && (n1==n3))
        error(message('rf:rfdata:power:checkproperty:InconsistentRFPOWERDataSize'));
    end
    pini = pin{ii};
    pouti = pout{ii};
    [pin{ii}, index] = sort(pini);
    pout{ii} = pouti(index);
    if ~isempty(phasei)
        phase{ii} = phasei(index);
    end 
end
if n > 1
    [freq, index] = sort(freq);
    newpin = cell(n,1); 
    newpout = cell(n,1); 
    newphase = cell(n,1); 
    for idx = 1:n
        newpin{idx} = pin{index(idx)};
        newpout{idx} = pout{index(idx)};
        if ~isempty(phase)
            newphase{idx} = phase{index(idx)};
        else
            newphase = phase;
        end
    end
    set(h, 'Freq', freq, 'Pin', newpin, 'Pout', newpout, 'Phase', newphase);
else
    set(h, 'Freq', freq, 'Pin', pin, 'Pout', pout, 'Phase', phase);
end