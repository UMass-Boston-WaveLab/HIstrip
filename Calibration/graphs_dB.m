% Produces graphs of the uncalibrated and calibrated DUT data. Don't forget
% to rename on git!

% Creates empty vectors to store calibrated results.

S11cal = zeros(1,depth);
S21cal = zeros(1,depth);
S31cal = zeros(1,depth);
S41cal = zeros(1,depth);
S22cal = zeros(1,depth);
S42cal = zeros(1,depth);

% Creates empty vectors to store uncalibrated results.

S11uncal = zeros(1,depth);
S21uncal = zeros(1,depth);
S31uncal = zeros(1,depth);
S41uncal = zeros(1,depth);
S22uncal = zeros(1,depth);
S42uncal = zeros(1,depth);

% Moves the uncalibrated/calibrated results into individual vectors for 
% plotting.

for ii = 1:depth
    S11cal(1,ii) = mag_dut_cal_S(1,1,ii);
    S21cal(1,ii) = mag_dut_cal_S(2,1,ii);
    S31cal(1,ii) = mag_dut_cal_S(3,1,ii);
    S41cal(1,ii) = mag_dut_cal_S(4,1,ii);
    S22cal(1,ii) = mag_dut_cal_S(2,2,ii);
    S42cal(1,ii) = mag_dut_cal_S(4,2,ii);
    
    S11uncal(1,ii) = mag_dutS(1,1,ii);
    S21uncal(1,ii) = mag_dutS(2,1,ii);
    S31uncal(1,ii) = mag_dutS(3,1,ii);
    S41uncal(1,ii) = mag_dutS(4,1,ii);
    S22uncal(1,ii) = mag_dutS(2,2,ii);
    S42uncal(1,ii) = mag_dutS(4,2,ii);
end

% Creates two separate graphs to plot magnitude data for uncalibrated and
% calibrated results. Rename graph titles as appropriate for DUT.

plot(thru_freq,S11uncal,'-o',thru_freq,S21uncal,'-+',thru_freq,S31uncal,...
    '-x',thru_freq,S41uncal,'-s',thru_freq,S22uncal,'-d',...
    thru_freq,S42uncal,'-^');
title('Uncalibrated Longer Line S-Parameter Magnitude')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S21','S31','S41','S22','S42','Location','southeast')

figure;

plot(thru_freq,S11cal,'-o',thru_freq,S21cal,'-+',thru_freq,S31cal,...
    '-x',thru_freq,S41cal,'-s',thru_freq,S22cal,'-d',...
    thru_freq,S42cal,'-^');
title('Calibrated Longer Line S-Parameter Magnitude')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S21','S31','S41','S22','S42','Location','northeast')
