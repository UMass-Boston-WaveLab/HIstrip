% Produces graphs of calibrated data. This function reorganizes the results
% into pure and mixed-modal matrices - mode 1, mode 2, mode 1 to 2, and
% mode 2 to 1.

% Script needs to get cleaned up - too easy to change variables elsewhere
% and miss them here.
% Needs to accept the variables so these errors get caught/fixed as we
% update the code

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

% Creates one graph with four subplots to display the modal S-parameters.
figure;
% assign thru_freq and end_freq from depth variable
thru_freq = [3:0.1:3+(depth - 1)/10];
end_freq = 3 + (depth - 1) / 10;
% set the font size larger
% set(gca, 'Fontsize', 30);


% Mode 1 S-parameters.
ax1 = subplot(2,2,1);
% plot the correct parameters
plot(ax1, thru_freq,S11cal,'-o',thru_freq,S13cal,'-+',thru_freq,S31cal,...
    '-x',thru_freq,S33cal,'-s');
% title the subplot
title(ax1,strcat(testName, ' Mode 1'))
% label and set the x-axis
xlabel(ax1, 'Freq (GHz)')
xlim( [3 end_freq]);
% label and set the y-axis
ylabel(ax1,'dB');
ylim([-30 10]);
% create the legend
legend(ax1, 'S11','S12','S21','S22','Location','northeast');
% increase font size
set(ax1, 'Fontsize', 16);

% Mode 2 S-parameters
ax2 = subplot(2,2,2);
plot(thru_freq,S22cal,'-o',thru_freq,S24cal,'-+',thru_freq,S42cal,...
    '-x',thru_freq,S44cal,'-s');
title(strcat(testName, ' Mode 2'))
% label and set the x-axis
xlabel('Freq (GHz)');
xlim([3 end_freq]);
% label and set the y-axis
ylabel('dB');
ylim( [-30 10]);
% create legend
legend('S11','S12','S21','S22','Location','northeast');
% increase font size
set(ax2, 'Fontsize', 16);



% Mode 1 to 2 S-paremeters.
ax3 = subplot(2,2,3);
plot(thru_freq,S21cal,'-o',thru_freq,S23cal,'-+',thru_freq,S41cal,...
    '-x',thru_freq,S43cal,'-s');
title(strcat(testName, ' Mode 1 to Mode 2'))
% label and set the x-axis
xlabel('Freq (GHz)');
xlim( [ 3 end_freq]);
% label and set the y-axis
ylabel('dB');
ylim( [-30 10]);
% create legend
legend('S11','S12','S21','S22','Location','northeast');
% increase font size
set(ax3, 'Fontsize', 16);

% Mode 2 to 1 S-parameters.
ax4 = subplot(2,2,4);
plot(thru_freq,S12cal,'-o',thru_freq,S14cal,'-+',thru_freq,S32cal,...
    '-x',thru_freq,S34cal,'-s');
title(strcat(testName, ' Mode 2 to Mode 1'))
% label and set the x-axis
xlabel('Freq (GHz)');
xlim( [ 3 end_freq]);
% label and set the y-axis
ylabel('dB');
ylim( [-30 10]);
% create legend
legend('S11','S12','S21','S22','Location','northeast');
% increase font size
set(ax4, 'Fontsize', 16);

% Commented out for now - producing presentation plots
% Put a big title on the whole thing
% titleText = ['Calibrated Modal S-Parameters for ' testName ''];
% suptitle(titleText);
