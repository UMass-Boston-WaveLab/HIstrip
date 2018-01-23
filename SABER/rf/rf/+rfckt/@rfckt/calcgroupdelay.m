function gd = calcgroupdelay(h, freq, z0, aperture)
%CALCGROUPDELAY Calculate the group delay.
%   GD = CALCGROUPDELAY(H, FREQ, Z0, APERTURE) calculates the group delay
%   for two port.
%
%   See also RFCKT

%   Copyright 2007-2009 The MathWorks, Inc.


% Set the default
gd = [];

% Calculate the group delay for 2-port
if (h.nPort == 2)
    % APERTURE is not specified by the user, then determine DELTAFREQ_LEFT
    % and DELTAFREQ_RIGHT from the simulation frquencies and refine it by
    % each RFCKT object
    if isempty(aperture) 
        % Initial estimation
        deltafreq = 1e-4 .* freq;
        % DELTAFREQ_LEFT and DELTAFREQ_RIGHT should not be smaller than 1Hz
        deltafreq(deltafreq < 1) = 1;     
        deltafreq_left = deltafreq;     
        deltafreq_right = deltafreq;     
        % Forward difference at DC
        deltafreq_left(freq <= 1) = 0.0;
        % Adjust DELTAFREQ_LEFT and DELTAFREQ_RIGHT by comparing with
        % simulation frequency space
        nfreq = numel(freq);
        if (nfreq >= 2)
            diffsimf = diff(freq);
            simdeltafreq_left(1, 1) = freq(1);
            simdeltafreq_left(2:nfreq, 1) = diffsimf(1:nfreq-1);  
            simdeltafreq_right = diffsimf;
            simdeltafreq_right(nfreq, 1) = diffsimf(nfreq-1);
            simdeltafreq = min(simdeltafreq_left, simdeltafreq_right); 
            % DELTAFREQ_RIGHT and DELTAFREQ_LEFT should not be bigger
            % than the simulation FREQ steps 
            idx = abs(deltafreq_right) > abs(simdeltafreq);
            deltafreq_right(idx) = simdeltafreq(idx);     
            idx = abs(deltafreq_left) > abs(simdeltafreq);
            deltafreq_left(idx) = simdeltafreq(idx);
        end
        % Refine DELTAFREQ_LEFT and DELTAFREQ_RIGHT by comparing with the
        % frequencies of measured data if any
        [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,    ...
            deltafreq_left, deltafreq_right, false);
    
    % APERTURE is specified by the user, then use it to calculate
    % DELTAFREQ_LEFT and DELTAFREQ_RIGHT
    else
        % For APERTURE < 1
        deltafreq = freq .* aperture /2;
        % For APERTURE >= 1
        idx = (abs(aperture) >= 1);
        deltafreq(idx) = aperture(idx)/2;  
        deltafreq_right = deltafreq;      
        deltafreq_left = deltafreq;     
        % Forward difference at DC
        deltafreq_left(freq <= 1) = 0.0;       
        % Forward difference if FREQ - DELTAFREQ_LEFT <= 0
        deltafreq_left(freq <= deltafreq_left) = 0.0;
        % Forward difference if the ourput frequency of MIXER is negative
        [deltafreq_left, deltafreq_right] = refinedeltafreq(h, freq,    ...
            deltafreq_left, deltafreq_right, true);  
    end
    % Set falgs for group delay calculation
    cflag = h.Flag;
    setflagindexes(h);
    updateflag(h, indexOfTheBudgetAnalysisOn, 0, MaxNumberOfFlags);
    [type, netparameters, own_z0] = nwa(h, freq + deltafreq_right);
    data = get(h, 'AnalyzedResult');
    % Calculate S-parameters at Freq + DELTAFREQ_RIGHT
    if strncmpi(type,'S',1)
        sparams_plus_delta = s2s(netparameters, own_z0, z0);
    else
        if all(~isfinite(netparameters(:)))
            error(message('rf:rfckt:rfckt:calcgroupdelay:InfNetparams'));
        end        
        sparams_plus_delta = convertmatrix(data, netparameters,         ...
            type, 'S_PARAMETERS', z0);
    end
    % Calculate S-parameters at Freq - DELTAFREQ_LEFT
    [type, netparameters, own_z0] = nwa(h, freq - deltafreq_left);
    if strncmpi(type,'S',1)
        sparams_minus_delta = s2s(netparameters, own_z0, z0);
    else
        sparams_minus_delta = convertmatrix(data, netparameters,        ...
            type, 'S_PARAMETERS', z0);
    end
    set(h, 'Flag', cflag);   
    % Calculate group delay using central difference
    diff_s21_angle = unwrap(angle(sparams_plus_delta(2, 1, :))) -       ...
        unwrap(angle(sparams_minus_delta(2, 1, :)));
    gd = - diff_s21_angle(:) ./ (2*pi*(deltafreq_right + deltafreq_left)); 
end