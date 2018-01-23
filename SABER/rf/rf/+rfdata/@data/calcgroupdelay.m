function gd = calcgroupdelay(h, freq, z0, aperture)
%CALCGROUPDELAY Calculate the group delay.
%   GD = CALCGROUPDELAY(H, FREQ, Z0, APERTURE) calculates the group delay
%   for two port.
%
%   See also RFDATA.DATA

%   Copyright 2007-2009 The MathWorks, Inc.

% Set the default
gd = [];

% Calculate the group delay for 2-port
if (getnport(h) == 2)
    % Get the original frequencies
    original_freq = [];
    original_sparams = [];
    refobj = getreference(h);
    if hasreference(h)
        netobj = get(refobj, 'NetworkData');
        if isa(netobj, 'rfdata.network')
            [original_sparams, original_freq] = extract(netobj,'S_Parameters', z0);
        end
    end
    if isempty(original_freq) && ~isempty(h.Freq)&& ~isempty(h.S_Parameters)
        original_freq = get(h, 'Freq');
        original_sparams = extract(h,'S_Parameters', z0);
    end
    
    if ~isempty(original_freq) && ~isempty(original_sparams)&& ...
            numel(original_freq) == size(original_sparams, 3)
        % Calculate the group delay
        noriginal_freq = numel(original_freq);
        s21_angle = reshape(unwrap(angle(original_sparams(2, 1, :))), [noriginal_freq, 1]);
        diff_s21_angle = diff(s21_angle);
        if noriginal_freq == 2 
            gd = - diff_s21_angle / (2*pi*diff(original_freq));
        elseif noriginal_freq > 2
            original_gd = zeros(noriginal_freq, 1);
            diff_original_freq = diff(original_freq);
            df = unique(diff_original_freq);
            % For equally spaced   
            if numel(df) == 1                      
                forward_gd = - diff_s21_angle / (2*pi*df);
                backward_gd(2:noriginal_freq, 1) = forward_gd;
                forward_gd(noriginal_freq, 1) = forward_gd(noriginal_freq-1);
                backward_gd(1,1) = backward_gd(2,1);
                % Calc the original group delay
                original_gd = (forward_gd + backward_gd)/2;
            % For not equally spaced
            else               
                % Central difference for 2, ... n-1 points
                for k = 2:noriginal_freq-1
                    if (diff_original_freq(k) > diff_original_freq(k-1))
                        ddf = diff_original_freq(k-1);
                        s21_angle_k_right = s21_angle(k) + diff_original_freq(k-1) * ...
                            (s21_angle(k+1) - s21_angle(k))/(diff_original_freq(k));
                        original_gd(k) = - (s21_angle_k_right - s21_angle(k-1)) / (2*pi*2*ddf);
                    else
                        ddf = diff_original_freq(k);
                        s21_angle_k_left = s21_angle(k) - diff_original_freq(k) * ...
                            (s21_angle(k) - s21_angle(k-1))/(diff_original_freq(k-1));
                        original_gd(k) = - (s21_angle(k+1) - s21_angle_k_left) / (2*pi*2*ddf);
                    end
                end
                % Forward difference for the first point
                original_gd(1) = - (s21_angle(2) - s21_angle(1)) / (2*pi*diff_original_freq(1));
                % Backward difference for the last point
                original_gd(noriginal_freq) = - (s21_angle(noriginal_freq) - s21_angle(noriginal_freq-1)) / ...
                    (2*pi*diff_original_freq(noriginal_freq-1));
            end
            % Interpolate the original GD to get the GD over simulation frequencies
            gd = interpolate(h, original_freq, original_gd, freq);
            gd(freq > original_freq(end) | freq < original_freq(1))= 0;
        end
    end
end