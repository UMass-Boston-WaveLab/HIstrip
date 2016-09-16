% Produces graphs of the uncalibrated and calibrated DUT data. Don't forget
% to rename on git!

% Creates empty vectors to store calibrated results.

% The reflection parameters.
S11cal = zeros(1,depth);
S22cal = zeros(1,depth);
S33cal = zeros(1,depth);
S44cal = zeros(1,depth);

% The transmission parameters.
S31cal = zeros(1,depth);
S42cal = zeros(1,depth);

% The coupling parameters.
S21cal = zeros(1,depth);
S43cal = zeros(1,depth);

% Creates empty vectors to store uncalibrated results.

% The reflection parameters.
S11uncal = zeros(1,depth);
S22uncal = zeros(1,depth);
S33uncal = zeros(1,depth);
S44uncal = zeros(1,depth);

% The transmission parameters.
S31uncal = zeros(1,depth);
S42uncal = zeros(1,depth);

% The coupling parameters.
S21uncal = zeros(1,depth);
S43uncal = zeros(1,depth);

% Moves the uncalibrated/calibrated results into individual vectors for 
% plotting.

for ii = 1:depth
    S11cal(1,ii) = mag_dut_cal_S(1,1,ii);
    S22cal(1,ii) = mag_dut_cal_S(2,2,ii);
    S33cal(1,ii) = mag_dut_cal_S(3,3,ii);
    S44cal(1,ii) = mag_dut_cal_S(4,4,ii);
    S31cal(1,ii) = mag_dut_cal_S(3,1,ii);
    S42cal(1,ii) = mag_dut_cal_S(4,2,ii);
    S21cal(1,ii) = mag_dut_cal_S(2,1,ii);
    S43cal(1,ii) = mag_dut_cal_S(4,3,ii);

    S11uncal(1,ii) = mag_dutS(1,1,ii);
    S22uncal(1,ii) = mag_dutS(2,2,ii);
    S33uncal(1,ii) = mag_dutS(3,3,ii);
    S44uncal(1,ii) = mag_dutS(4,4,ii);
    S31uncal(1,ii) = mag_dutS(3,1,ii);
    S42uncal(1,ii) = mag_dutS(4,2,ii);
    S21uncal(1,ii) = mag_dutS(2,1,ii);
    S43uncal(1,ii) = mag_dutS(4,3,ii);
end

% Creates four separate graphs to plot magnitude data for uncalibrated and
% calibrated results. Calibrated and uncalibrated reflection parameters
% have their own graphs; transmission parameters are all graphed together,
% as are coupling parameters.

plot(thru_freq,S11uncal,'-o',thru_freq,S22uncal,'-+',thru_freq,S33uncal,...
    '-x',thru_freq,S44uncal,'-s');
title('Uncalibrated Reflection Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S22','S33','S44','Location','southeast')

figure;

plot(thru_freq,S11cal,'-o',thru_freq,S22cal,'-+',thru_freq,S33cal,...
    '-x',thru_freq,S44cal,'-s');
title('Calibrated Reflection Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S22','S33','S44','Location','northeast')

figure;

plot(thru_freq,S31uncal,'-o',thru_freq,S42uncal,'-+',thru_freq,S31cal,...
    '-x',thru_freq,S42cal,'-s');
title('Transmission Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('uncalibrated S31','uncalibrated S42','calibrated S31',...
        'calibrated S42','Location','northeast')

figure;

plot(thru_freq,S21uncal,'-o',thru_freq,S43uncal,'-+',thru_freq,S21cal,...
    '-x',thru_freq,S43cal,'-s');
title('Transmission Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('uncalibrated S21','uncalibrated S43','calibrated S21',...
        'calibrated S43','Location','northeast')
