% Produces graphs of calibrated data. This function reorganizes the results
% into pure and mixed-modal matrices - mode 1, mode 2, mode 1 to 2, and
% mode 2 to 1.

% Creates empty vectors to store results.
% Mode 1.
S11cal = zeros(1,depth);
S13cal = zeros(1,depth);
S31cal = zeros(1,depth);
S33cal = zeros(1,depth);

% Mode 2.
S22cal = zeros(1,depth);
S24cal = zeros(1,depth);
S42cal = zeros(1,depth);
S44cal = zeros(1,depth);

% Mode 1 to Mode 2.
S21cal = zeros(1,depth);
S23cal = zeros(1,depth);
S41cal = zeros(1,depth);
S43cal = zeros(1,depth);

% Mode 2 to Mode 1.
S12cal = zeros(1,depth);
S14cal = zeros(1,depth);
S32cal = zeros(1,depth);
S34cal = zeros(1,depth);

% Fills empty vectors with calibrated results.

for ii = 1:depth
    % Mode 1.
    S11cal(1,ii) = mag_dut_cal_S(1,1,ii);
    S13cal(1,ii) = mag_dut_cal_S(1,3,ii);
    S31cal(1,ii) = mag_dut_cal_S(3,1,ii);
    S33cal(1,ii) = mag_dut_cal_S(3,3,ii);

    % Mode 2.
    S22cal(1,ii) = mag_dut_cal_S(2,2,ii);
    S24cal(1,ii) = mag_dut_cal_S(2,4,ii); 
    S42cal(1,ii) = mag_dut_cal_S(4,2,ii);
    S44cal(1,ii) = mag_dut_cal_S(4,4,ii);

    % Mode 1 to Mode 2.
    S21cal(1,ii) = mag_dut_cal_S(2,1,ii);
    S23cal(1,ii) = mag_dut_cal_S(2,3,ii);
    S41cal(1,ii) = mag_dut_cal_S(4,1,ii);
    S43cal(1,ii) = mag_dut_cal_S(4,3,ii);

    % Mode 2 to Mode 1.
    S12cal(1,ii) = mag_dut_cal_S(1,2,ii);
    S14cal(1,ii) = mag_dut_cal_S(1,4,ii);
    S32cal(1,ii) = mag_dut_cal_S(3,2,ii);
    S34cal(1,ii) = mag_dut_cal_S(3,4,ii);
end

% Creates four graphs to display the modal S-parameters.

% Mode 1 S-parameters.
plot(thru_freq,S11cal,'-o',thru_freq,S13cal,'-+',thru_freq,S31cal,...
    '-x',thru_freq,S33cal,'-s');
title('Mode 1 S-Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S12','S21','S22','Location','northeast')
figure;

% Mode 2 S-parameters
plot(thru_freq,S22cal,'-o',thru_freq,S24cal,'-+',thru_freq,S42cal,...
    '-x',thru_freq,S44cal,'-s');
title('Mode 2 S-Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S12','S21','S22','Location','northeast')
figure;

% Mode 1 to 2 S-paremeters.
plot(thru_freq,S21cal,'-o',thru_freq,S23cal,'-+',thru_freq,S41cal,...
    '-x',thru_freq,S43cal,'-s');
title('Mode 1 to Mode 2 S-Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S12','S21','S22','Location','northeast')
figure;

% Mode 2 to 1 S-parameters.
plot(thru_freq,S12cal,'-o',thru_freq,S14cal,'-+',thru_freq,S32cal,...
    '-x',thru_freq,S34cal,'-s');
title('Mode 2 to Mode 1 S-Parameters')
xlabel('Freq (GHz)')
ylabel('dB')
legend('S11','S12','S21','S22','Location','northeast')