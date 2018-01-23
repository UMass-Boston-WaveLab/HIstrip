function [result, iip3, p1db, psat, gcsat] = oip3(h, freq, ckt_oip3)
%OIP3 Calculate the OIP3.
%   RESULT = OIP3(H, FREQ) calculates the OIP3 of the data object at the
%   specified frequencies FREQ. The first input is the handle to the
%   RFDATA.DATA object, the second input is a vector for the specified
%   freqencies.
%
%   See also RFDATA.DATA

%   Copyright 2003-2009 The MathWorks, Inc.

narginchk(2,4)
% Set the default 
nfreq = numel(freq); 
result = inf * ones(nfreq, 1); 
iip3 = inf;  p1db = inf;  psat = inf; gcsat = 1;
if nargin < 3; ckt_oip3 = inf; end;

refobj = getreference(h);
original_psat = [];
if haspowerreference(h) || hasp2dreference(h)
    if  haspowerreference(h)
        powerdata = get(refobj, 'PowerData');
    else % Has P2D reference.
        powerdata = convert2power(get(refobj, 'P2DData'));
    end
    original_freq = get(powerdata, 'Freq');
    original_pouts = get(powerdata, 'Pout');
    noriginal_freq = numel(original_freq); 
    for jj=1:noriginal_freq
        original_pout = original_pouts{jj};
        original_psat(jj) = original_pout(end);
    end
    if ~isempty(original_psat)
        original_oip3 = original_psat * 27.0/4.0;
        % Get the needed OIP3 using interpolation
        [original_freq, freqindex] = sort(original_freq);
        original_oip3 = original_oip3(freqindex);
        result = interpolate(h, original_freq, original_oip3, freq);
    end
elseif hasip3reference(h)
    ip3data = get(refobj, 'IP3Data');
    original_freq = get(ip3data, 'Freq');
    original_ip3 = get(ip3data, 'Data');
    if ~isempty(original_ip3)
        % Get the needed IP3 using interpolation
        ip3 = interpolate(h, original_freq, original_ip3, freq);
        if strcmp(ip3data.Type, 'IIP3')
            result = ip3 .* ga(h, freq);
        else
            result = ip3;
        end
    end
elseif isa(refobj, 'rfdata.reference')
    original_freq = get(refobj, 'NonlinearDataFreq');
    original_oip3 = get(refobj, 'OIP3');
    if all(isinf(original_oip3)); original_oip3 = ckt_oip3; end;  
    original_iip3 = get(refobj, 'IIP3');
    original_p1db = get(refobj, 'OneDBC');
    original_psat = get(refobj, 'PS');
    original_gcsat = get(refobj, 'GCS');
    
    if length(original_oip3)>1
        result = interpolate(h, original_freq, original_oip3, freq);
    elseif length(original_oip3)==1
        result(1:nfreq, 1) = original_oip3; 
    end
    if length(original_iip3)>1
        iip3 = interpolate(h, original_freq, original_iip3, freq);
    elseif length(original_iip3)==1
        iip3(1:nfreq, 1) = original_iip3; 
    end
    if length(original_p1db)>1
        p1db = interpolate(h, original_freq, original_p1db, freq);
    elseif length(original_p1db)==1
        p1db(1:nfreq, 1) = original_p1db; 
    end
    if length(original_psat)>1
        psat = interpolate(h, original_freq, original_psat, freq);
    elseif length(original_psat)==1
        psat = original_psat; 
    end
    if length(original_gcsat)>1
        gcsat = interpolate(h, original_freq, original_gcsat, freq);
    elseif length(original_gcsat)==1
        gcsat = original_gcsat;
    end
    if all(isinf(result)) && all(isfinite(iip3)) 
        result = iip3 .* ga(h, freq); 
    end
    if all(isinf(result)) && all(isfinite(p1db)) 
        result = 0.001*10.^(10*log10(1000*p1db) + 10.6/10);
    end
    if all(isinf(result))&& all(isfinite(psat)) 
        result = psat * 27.0/4.0;
    end
end