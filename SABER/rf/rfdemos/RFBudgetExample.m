%% Visualizing RF Budget Analysis Over Bandwidth
% This example shows how to programmatically perform an RF budget analysis
% of an RF receiver system and visualize computed budget results across the
% bandwidth of the input signal.
%
% First, use
% <matlab:doc('amplifier') amplifier>,
% <matlab:doc('modulator') modulator>,
% <matlab:doc('rfelement') rfelement>,
% and
% <matlab:doc('nport') nport>
% objects to specify the 2-port RF elements in a design.  Then compute RF
% budget results by cascading the elements together into an RF system with
% <matlab:doc('rfbudget') rfbudget>.
%
% The rfbudget object enables design exploration and visualization at the
% MATLAB command-line or graphically in the 
% <matlab:helpview(fullfile(docroot,'rf','helptargets.map'),'rfbudget_app') rfBudgetAnalyzer> 
% app.  It also enables automatic RF Blockset model and measurement
% testbench generation.

% Copyright 2017 The MathWorks, Inc.

%% Introduction
% RF system designers typically begin a design process with budget
% specifications for the gain, noise figure (NF), and nonlinearity (IP3) of
% the entire system.
%
% MATLAB functionality supporting RF budget analysis makes it easy to
% visualize gain, NF and IP3 results at multiple frequencies throughout the
% bandwidth of the signal.  You can:
%
% * Programmatically build an 
%   <matlab:doc('rfbudget') rfbudget>
%   object out of 2-port RF elements.
% * Use the command-line display of the rfbudget object to view
%   single-frequency budget results.
% * Vectorize the input frequency of the rfbudget object and use MATLAB
%   plot to visualize RF budget results across the bandwidth of the input
%   signal.
%
% In addition, with an rfbudget object you can:
%
% * Use export methods to generate MATLAB scripts, RF Blockset models, or
%   measurement testbenches in Simulink.
% * Use show to copy an rfbudget object into the 
%   <matlab:helpview(fullfile(docroot,'rf','helptargets.map'),'rfbudget_app') rfBudgetAnalyzer>
%   app.

%% Building the Elements of an RF Receiver
% A basic RF receiver consists of an RF filter, an RF amplifier, a
% demodulator, an IF filter, and an IF amplifier.
%
% First build and parameterize each of the 2-port RF elements.  Then use
% rfbudget to cascade the elements with input frequency 2.1 GHz, input
% power -30 dBm, and input bandwidth 45 MHz.

f1 = nport('RFBudget_RF.s2p','RFBandpassFilter');

a1 = amplifier('Name','RFAmplifier', ...
    'Gain',11.53, ...
    'NF',1.53, ...
    'OIP3',35);

d = modulator('Name','Demodulator', ...
    'Gain',-6, ...
    'NF',4, ...
    'OIP3',50, ...
    'LO',2.03e9, ...
    'ConverterType','Down');

f2 = nport('RFBudget_IF.s2p','IFBandpassFilter');

a2 = amplifier('Name','IFAmplifier', ...
    'Gain',30, ...
    'NF',8, ...
    'OIP3',37);

b = rfbudget('Elements',[f1 a1 d f2 a2], ...
    'InputFrequency',2.1e9, ...
    'AvailableInputPower',-30, ...
    'SignalBandwidth',45e6);

%% Visualize RF Budget Results in MATLAB
% Scalar frequency results can be viewed simply by using MATLAB disp to see
% the results at the command-line.
%
% Each column of the budget shows the results of cascading only the
% elements of the previous columns.  The final column shows the RF budget
% results of the entire cascade.
disp(b)

%% Vectorize Input Frequency to Compute over Frequency Range
% Change the InputFrequency property to be a vector of nonnegative values
% to compute the results across a frequency range.
%
% Use plot to visualize any of the RF budget results, such as
% TransducerGain, NF, or OIP3.
RF = 2.1e9;
BW = 45e6;
b.InputFrequency = linspace(RF-BW/2,RF+BW/2,101);

figure
plot(b.InputFrequency,b.TransducerGain,'-o')
legend('1','1..2','1..3','1..4','1..5','Location','northwest')
grid on
title('Transducer Gain vs. Bandwidth')
xlabel('Frequency (Hz)')
ylabel('Transducer Gain (dB)')

figure
plot(b.InputFrequency,b.NF,'-o')
legend('1','1..2','1..3','1..4','1..5','Location','northeast')
grid on
title('Noise Figure vs. Bandwidth')
xlabel('Frequency (Hz)')
ylabel('Noise Figure (dB)')

%% Easily Export to RF Blockset and Simulink
% The
% <matlab:doc('rfbudget') rfbudget>
% object has other useful MATLAB methods:
%
% * <matlab:doc('rfbudget.exportScript') exportScript> - generate a MATLAB script that builds the current design
% * <matlab:doc('rfbudget.exportRFBlockset') exportRFBlockset> - generate an RF Blockset model for simulation
% * <matlab:doc('rfbudget.exportTestbench') exportTestbench> - generate a Simulink measurement testbench
%
%% Visualize RF Budget Results in the App
% Finally, you can use the show command to copy a single-frequency rfbudget
% object into the 
% <matlab:helpview(fullfile(docroot,'rf','helptargets.map'),'rfbudget_app') rfBudgetAnalyzer>
% app.
%
% In the app, the Export button copies the current design to an rfbudget
% object in the MATLAB workspace.  All of the other export methods of the
% RF budget object are available through the pulldown options of the Export
% button.
b.InputFrequency = 2.1e9
show(b)
