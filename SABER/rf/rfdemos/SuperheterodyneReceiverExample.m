%% Superheterodyne Receiver Using RF Budget Analyzer App
% This example shows how to build a superheterodyne receiver and analyze
% the receiver's RF budget for gain, noise figure, and IP3 using the RF
% Budget Analyzer app. The receiver is a part of a transmitter-receiver
% system described in two IEEE conference papers, [1] and [2].
%
% This example requires the following products: 
% 
% * RF Blockset(TM)
% * DSP System Toolbox(TM)
%
% Copyright 2015 The MathWorks, Inc.
%% Introduction
% RF system designers begin the design process with a budget 
% specification for how much gain, noise figure (NF), and nonlinearity 
% (IP3) the entire system must satisfy. To assure the feasibility of 
% an architecture modeled as a simple cascade of RF elements, designers 
% calculate both the per-stage and cascade values of gain, noise 
% figure and IP3 (third-intercept point). 
%
% Using the RF Budget Analyzer app, you can:
%
% * Build a cascade of RF elements.
% * Calculate the per-stage and cascade output power, gain, noise figure,
%   SNR, and IP3 of the system.
% * Export the per-stage and cascade values to the MATLAB(TM)
%   workspace.
% * Export the system design to RF Blockset for simulation.
% * Export the system design to RF Blockset measurement testbench as a DUT
% (device under test) subsystem and verify the results obtained using the
%  app.
%
%% System Architecture
% The receiver system architecture designed using the app is:
%
% <<superhetrodynereceiver.png>>
% 
% The receiver bandwidth is between 5.825 GHz and 5.845 GHz.

%% Build Using RF Budget Analyzer
% 1. To open the app, type the following at the MATLAB prompt:
% 
%   rfBudgetAnalyzer
% 
% <<rfBudgetAnalyzer.png>>
% 
%%
% 2. In the *System Parameters* dialog box, enter 5.8 GHz for |Input
% frequency|, -80 dB for |Available input power|, and 20 MHz for |Signal
% bandwidth|.
%%
% 3. Add an |S-parameters| block to model the RF bandpass filter. In the
% *Element Parameters* dialog box, change the block name to *RF Filter*. To
% add the Touchstone (.s2p) file, click on the browse button and choose 
% <matlab:edit('RFfilter.s2p'); |RFfilter.s2p|>. The app automatically
% populates the gain and noise figure values for the filter from the 
% file. In the display region, the top table shows the per-stage
% values and the bottom table shows the cascaded values.
% 
% <<rffilterparameters.png>>
%
%%
% 4. In the system architecture, the RF filter has an insertion loss of 1
% dB. The values from the .s2p file are for an ideal filter, and the
% parameters do not model this loss. Use a |Generic| block to model the
% insertion loss of the filter. Click on the |Generic| block in the
% toolstrip to add the block. In the *Element Parameters* dialog box,
% change the block name to *Loss*. Enter -1 dB for |Available power gain|
% and 12 dB for |Noise figure|.
% 
% <<generic_24.png>>
%
%%
% 5. To model the LNA (Low Noise Amplifier), use the |Amplifier| block.
% Click on the |Amplifier| block in the toolstrip to add the block. Change
% the block name to *LNA*. Enter 15 dB for |Available power gain|, 1.5 dB
% for |Noise figure|, and 26 dBm for |OIP3|.
% 
% <<amp_24.png>>
% 
%%
% 6. To model the Gain block, use the |Amplifier| block. Change the block
% name to *Gain*. Enter 10.5 dB for |Available power gain|, 3.5 dB for
% |Noise figure|, and 23 dBm for |OIP3|.
%%
% 7. The receiver downconverts the RF frequency to an IF frequency of 400
% MHz. To model the Mixer block, use the *Demodulator* block. From the
% Toolstrip, use the *Modulator* drop-down list to add a |Demodulator|.
% 
% <<demodulator.png>>
% 
% 8. In the *Element Parameters* of the |Demodulator| block, specify an LO
% (Local Oscillator) frequency of 5.4 GHz. Enter -7 dB for |Available power
% gain|, 7 dB for |Noise figure|, and 15 dBm for |OIP3|.
%%
% 9. Add the IF filter using the S-parameters block. Change the block name
% to *IF Filter*. Use the <matlab:edit('IFfilter.s2p'); |IFfilter.s2p|>
% file for populating the gain and noise figure of the filter. The
% S-parameters for this filter are not ideal and automatically inserts a
% loss of approximately -1dB into the system. 
%%
% When the number of elements in the app window exceeds five, you see the
% cascade values on the right side of the window without using the scroll
% bar.
%%
% 10. Add an |Amplifier| block with an |Available power gain| of 40 dB and
% |Noise figure| of 2.5 dB. Change the block name to *IF Amp*.
%%
% 11. As seen in the references, the receiver uses an AGC (Automatic Gain
% Control) block where the gain varies with the available input power
% level. For an input power of -80 dB, the AGC gain is at a maximum of 17.5
% dB. Use an Amplifier block to model an AGC. Change the name of the block
% to *AGC*. Enter 17.5 dB for |Available power gain|, 4.3 dB for |Noise
% figure|, and 36 dBm for |OIP3|.
%%
% 12. The first components in the superheterodyne receiver system
% architecture are the *antenna* and *TR switch*. To match the RF
% budget results from the IEEE paper [1], add these two blocks to the
% system. To add the antenna and TR switch, scroll to the left side of the
% canvas and click before the RF filter. The red insertion line moves to
% the front of the system.
% 
% <<insertingantenna.png>>
% 
% 13. Use the |Generic| block to model an antenna. Change the block name 
% to *Antenna*. Enter 14 dB for |Available power gain|.
%%
% 14. The system uses the TR switch to switch between the transmitter and
% the receiver. The switch adds a loss of 1.3 dB to the system. Use the
% |Generic| block to model the TR switch after the antenna. Change the name
% of the block to *TR Switch*. Enter -1.3 dB as |Available power gain|, 12
% dB for |Noise figure|, and 37 dBm for |OIP3|.
%%
% 15. The app displays the cascade values such as: output frequency of the
% receiver, output power, gain, noise figure, OIP3, and SNR (Signal-to-
% Noise-Ratio).
%
% <<superheterodynereceiver_appimg.png>>
%
% 16. Save the model as *superheterodynereceiver*. The RF Budget Analyzer
% app saves the model in a MAT-file format.

%% Plot Cascade Transducer Gain and Cascade Noise Figure 
% 1. Use the *Export* button to export the details of the receiver to
% MATLAB workspace. 
% 
% <<superheterodyne_export_matlab_workspace.png>>
% 
%%
% 2. In the MATLAB command line, you will see *Exported RF Budget to
% workspace variable *"rfb"*. 
%%
% 3. Click on the variable, *rfb* in MATLAB to  list the per-stage and
% cascade values of the receiver. 
%%
% 4. Plot the cascade transducer gain of the receiver using the MATLAB 
% function, plot
% 
%   g = rfb.TransducerGain
%   plot(g,'--gs','MarkerEdgeColor','b')
%   title('Cascade Transducer Gain')
%   xlabel('Number of Stages')
%   ylabel('Gain')
% 
% <<cumulativegaingraph.png>>
% 
%%
% 5. Plot the cascade noise figure of the receiver.
%
%   nf = rfb.NF
%   plot(nf,'--bs','MarkerEdgeColor','b')
%   title('Cascade Noise Figure')
%   xlabel('Number of Stages')
%   ylabel('Noise Figure')
% 
% <<cumulativenfgraph.png>>
% 
%% Export to MATLAB Script
% 1. You can also  export the model to MATLAB script format using the
% *Export* button.
% 
% <<superheterodyne_export_matlab_script.png>>
% 
% The script opens automatically in a MATLAB Editor window.
% 
% <<superheterodyne_matlab_script.png>>
% 
%% Verify Output Power and Transducer Gain Using RF Blockset Simulation
% 1. Use the *Export* button to export the receiver to RF Blockset. 
% 
% <<superheterodyne_export_rf_blockset.png>>
% 
% 2. Run the RF Blockset model to calculate the *Output power (dBm)* and
% *Transducer gain (dB)* of the receiver. Note that the results match the
% *Pout (dBm)* and the *GainT (dB)* values of the receiver obtained using
% the  RF Budget Analyzer app.
% 
% <<superheterodyne_verify_rf_blockset.png>>
% 
% 3. Double-click on the Demodulator subsystem block. This subsystem
% consists of an image reject filter for proper noise calculation and an LO
% (local oscillator) for frequency up or down conversion.
% 
% <<demodulator_subsystem.png>>
% 
% 4. The stop time for the simulation is zero. To simulate time-varying 
% results, you need to change the stop time.
%% Export to RF Blockset Testbench
% 1. Use the *Export* dropdown button to export the receiver to RF Blockset
% measurement testbench.
% 
% <<superheterodyne_export_rf_blockset_testbench.png>>
% 
% 2. The RF Blockset testbench consists of two subsystems, |RF Measurement Unit|
% and |Device Under Test|.
% 
% <<rf_blockset_testbench.png>>
% 
% 3. The |Device Under Test| subsystem block contains the superheterodyne 
% receiver you exported from the RF Budget Analyzer app. Double-click on 
% the DUT subsystem block to look inside.
% 
% <<simrftestbench_DUT.png>>
%
% 4. Double-click on the |RF Measurement Unit| subsystem block to see the
% system parameters. By default, RF Blockset testbench verifies gain.
% 
% <<gainparameters.png>>
% 
% 
%% Verify Gain, Noise Figure and IP3 Using RF Blockset Testbench
% You can verify the gain, noise figure, and IP3 measurements using the 
% RF Blockset testbench. 
%
% 1. By default, the model verifies the gain measurement of the device
% under test. Run the model to check the gain value. The simulated gain
% value matches the cascade transducer gain value from the app. The scope
% shows an output power of approximately 6 dB at 400 MHz that matches the
% output power value in the RF Budget Analyzer app.
% 
% <<rf_blockset_gain_verification.png>>
% 
%%
% 2. The RF Blockset testbench calculates the spot noise figure. The calculation
% assumes a frequency independent system 
% within a given bandwidth. To simulate a frequency independent system and
% calculate the correct noise figure value, you need to reduce the broad
% bandwidth of 20 MHz to a narrow bandwidth.
% 
% 3. First, stop all simulations. Double-click on the |RF Measurement Unit|
% Block. This opens the RF measurement unit parameters. In the
% *Measured Quantity* parameter drop down, change the parameter to *NF*
% (noise figure). In the *Parameters* tab, change the *Baseband bandwidth
% (Hz)* to 2000 Hz. Click *Apply*. To learn more about how to manipulate
% noise figure verification, click the *Instructions* tab.
%
% <<noisefigureparameters.png>>
% 
% 4. Run the model again to check the noise figure value. The
% testbench noise figure value matches the cascade noise figure value 
% from the RF Budget Analyzer app.
% 
% <<rf_blockset_nf_verification.png>>
%
%%
% 5. IP3 measurements rely on the creation and measurement of
% intermodulation tones that are usually small in amplitude and may be
% below the DUT's noise floor. For accurate IP3 measurements, clear the
% *Simulate noise* checkbox.
%
% 6. To verify OIP3 (output third-order intercept), stop all simulations.
% Open the |RF Measurement Unit| dialog box. Clear the *Simulate noise
% (both stimulus and DUT internal)* check box. Change the *Measured
% Quantity* parameter to *IP3*. Keep the *IP Type* as *Output referred*. To
% learn more about how to manipulate OIP3 verification, click the
% *Instructions* tab. Click *Apply*.
% 
% <<oip3parameters.png>>
% 
% 7. Run the model. The testbench OIP3 value matches the cascade OIP3 value
% of the app.
% 
% <<rf_blockset_oip3_verification.png>>
% 
%%
% 8. To verify IIP3 (input third-order intercept), stop all simulations.
%  Open |RF Measurement Unit| dialog box. Clear the *Simulate noise
% (both stimulus and DUT internal)* check box. Change the *Measured
% Quantity* parameter in block parameters to *IP3*. Change the *IP Type* to
% *Input referred*. To learn more about how to manipulate IIP3 verification,
% click the *Instructions* tab. Click *Apply*.
%
% <<iip3parameters.png>>
%
% 9. Run the model again to check the IIP3 value.
% 
% <<rf_blockset_iip3_verification.png>>
% 
%% References
% 
% [1] Hongbao Zhou, Bin Luo. " Design and budget analysis of RF receiver of
% 5.8GHz ETC reader" Published at Communication Technology (ICCT), 2010
% 12th IEEE International Conference, Nanjing, China, November 2010. 
% 
% [2] Bin Luo, Peng Li. "Budget Analysis of RF Transceiver Used in 5.8GHz
% RFID Reader Based on the ETC-DSRC National Specifications of China"
% Published at Wireless Communications, Networking and Mobile Computing,
% WiCom '09. 5th International Conference, Beijing, China, September 2009.

displayEndOfDemoMessage(mfilename)

