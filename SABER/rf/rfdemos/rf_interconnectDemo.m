%% MOS Interconnect and Crosstalk
% This example shows how to build and simulate an RC tree circuit using the
% RF Toolbox.
%
% In "Asymptotic Waveform Evaluation for Timing Analysis" (IEEE
% Transactions on Computer-Aided Design, Vol., 9, No. 4, April 1990),
% Pillage and Rohrer present and simulate an RC tree circuit that models
% signal integrity and crosstalk in low- to mid-frequency MOS circuit
% interconnect. This example confirms their simulations using RF Toolbox
% software.
%
% Their circuit, reproduced in the following figure, consists of 11
% resistors and 12 capacitors. In the paper, Pillage and Rohrer:
%
% * Apply a ramp voltage input
% * Compute transient responses
% * Plot the output voltages across two different capacitors, |C7| and
% |C12|.
%
% <<interconnectWithCrosstalk_rlc.png>>
%
% *Figure 1:* An RC tree model of MOS interconnect with crosstalk.
% 
% With RF Toolbox software, you can programmatically construct this circuit
% in MATLAB and perform signal integrity simulations.
%
% This example shows:
%
% # How to use <matlab:doc('rf/circuit'); |circuit|>,
% <matlab:doc('rf/resistor'); |resistor|>, and <matlab:doc('rf/capacitor');
% |capacitor|> with the <matlab:doc('rf/add'); |add|> function to
% programmatically construct the circuit.
% # How to use <matlab:doc('rf/circuit.clone'); |clone|>,
% <matlab:doc('rf/setports'); |setports|>, and
% <matlab:doc('rf/sparameters'); |sparameters|> to calculate S-parameters
% for each desired output over a wide frequency range.
% # How to use <matlab:doc('rf/s2tf'); |s2tf|> with |Zsource = 0| and
% |Zload = Inf| to compute the voltage transfer function from input to each
% desired output.
% # How to use <matlab:doc('rf/rationalfit'); |rationalfit|> to produce
% rational-function approximations that capture the ideal RC-circuit
% behavior to a very high degree of accuracy.
% # How to use <matlab:doc('rf/timeresp'); |timeresp|> to compute the
% transient response to the input voltage waveform.
 
%% Insert Node Numbers into the Circuit Diagram
% Before building the circuit using <matlab:doc('rf/resistor'); |resistor|>
% and <matlab:doc('rf/capacitor'); |capacitor|> objects, we must number the
% nodes of the circuit shown in figure 1.
%
% <<interconnectWithCrosstalk_rlc_withnodenum.png>>
%
% *Figure 2:* The circuit drawn with node numbers

%% Programmatically Construct the Circuit
% Create a <matlab:doc('rf/circuit'); |circuit|> and use the
% <matlab:doc('rf/add'); |add|> function to populate the circuit with named
% <matlab:doc('rf/resistor'); |resistor|> and <matlab:doc('rf/capacitor');
% |capacitor|> objects.

ckt = circuit('crosstalk');

add(ckt,[2 1],resistor(10,'R1'))
add(ckt,[2 0],capacitor(0.114e-12,'C1'))
add(ckt,[3 2],resistor(72,'R2'))
add(ckt,[3 0],capacitor(1.238e-12,'C2'))
add(ckt,[4 3],resistor(34,'R3'))
add(ckt,[4 0],capacitor(0.021e-12,'C3'))
add(ckt,[5 4],resistor(96,'R4'))
add(ckt,[5 0],capacitor(0.028e-12,'C4'))
add(ckt,[6 5],resistor(72,'R5'))
add(ckt,[6 0],capacitor(0.007e-12,'C5'))
add(ckt,[7 6],resistor(10,'R6'))
add(ckt,[7 0],capacitor(1.048e-12,'C6'))
add(ckt,[8 7],resistor(120,'R7'))
add(ckt,[8 0],capacitor(0.47e-12,'C7'))

add(ckt,[12 8],resistor(24,'R8'))
add(ckt,[12 0],capacitor(0.2e-12,'C8'))

add(ckt,[10 2],resistor(48,'R9'))
add(ckt,[10 0],capacitor(0.007e-12,'C9'))
add(ckt,[11 10],resistor(24,'R10'))
add(ckt,[11 0],capacitor(0.2e-12,'C10'))

add(ckt,[9 8],capacitor(0.1e-12,'C11'))
add(ckt,[9 0],resistor(1000,'R11'))
add(ckt,[9 0],capacitor(1e-12,'C12'))

%% Simulation Setup
% The input signal used by Pillage and Rohrer is a voltage ramp from 0 to 5
% volts with a rise time of one nanosecond and a duration of ten
% nanoseconds. The following MATLAB code models this signal with 1000
% timepoints with a |sampleTime| of 0.01 nanoseconds.
%
% The following MATLAB code also uses the <matlab:doc('logspace');
% |logspace|> function to generate a vector of 101 logarithmically spaced
% analysis frequencies between 1 Hz and 100 GHz. Specifying a wide set of
% frequency points improves simulation accuracy.

sampleTime = 1e-11;
t = (0:1000)'*sampleTime;
input = [(0:100)'*(5/100); (101:1000)'*0+5];

freq = logspace(0,11,101)';

%% Calculate S-parameters For Each 2-Port Network
% To calculate the response across both the |C7| and |C12| capacitors, two
% separate S-parameter calculations must be made: first, assuming the |C7|
% capacitor represents the output port, and second, assuming the |C12|
% capacitor represents the output port.  To calculate the S-parameters for
% each setup:
% 
% # Copy the original circuit |ckt| using the
% <matlab:doc('rf/circuit.clone'); |clone|> function.
% # Define the input and output ports of the network using the
% <matlab:doc('rf/setports'); |setports|> function.
% # Calculate the S-parameters using the <matlab:doc('rf/sparameters');
% |sparameters|> function.

cktC7 = clone(ckt);
setports(cktC7,[1 0],[8 0])
S_C7 = sparameters(cktC7,freq);

cktC12 = clone(ckt);
setports(cktC12,[1 0],[9 0])
S_C12 = sparameters(cktC12,freq);

%% Simulate Each 2-Port Network
% To simulate each network:
% 
% # The <matlab:doc('rf/s2tf'); |s2tf|> function, with |option = 2|,
% computes the gain from the source voltage to the output voltage. It
% allows arbitrary source and load impedances, in this case |Zsource = 0|
% and |Zload = Inf|. The resulting transfer functions |tfC7| and |tfC12|
% are frequency-dependent data vectors that can be fit with
% rational-function approximation.
% # The <matlab:doc('rf/rationalfit'); |rationalfit|> function generates
% high-accuracy rational-function approximations. The resulting
% approximations match the networks to machine accuracy.
% # The <matlab:doc('rf/timeresp'); |timeresp|> function computes the
% analytic solution to the state-space equations defined by a
% rational-function approximation. This methodology is fast enough to
% enable one to push a million bits through a channel.

tfC7 = s2tf(S_C7,0,Inf,2);
fitC7 = rationalfit(freq,tfC7);
outputC7 = timeresp(fitC7,input,sampleTime);

tfC12 = s2tf(S_C12,0,Inf,2);
fitC12 = rationalfit(freq,tfC12);
outputC12 = timeresp(fitC12,input,sampleTime);

%% Plot Transient Responses
% The outputs match Figures 23 and 24 of the Pillage and Rohrer paper.

figure
plot(t,input,t,outputC7,'LineWidth',2)
axis([0 2.5e-9 0 5.5])
title('Ramp Response of Low- to Mid-frequency MOS Circuit Interconnect with Crosstalk')
xlabel('Time (sec)')
ylabel('Voltage (volts)')
legend('Vinput','V(C7)','Location','NorthWest')

figure
plot(t,input,t,outputC12,'LineWidth',2)
axis([0 5e-9 0 .5])
title('Crosstalk in Low- to Mid-frequency MOS Circuit Interconnect with Ramp Input')
xlabel('Time (sec)')
ylabel('Voltage (volts)')
legend('Vinput','V(C12)','Location','NorthEast')

%% Verify the Rational Fit Outside the Fit Range
% Though not shown in this example, you can also use the
% <matlab:doc('rf/freqresp'); |freqresp|> function to check the behavior of
% <matlab:doc('rf/rationalfit'); |rationalfit|> well outside the specified
% frequency range. The fit outside the specified range can sometimes cause
% surprising behavior, especially if frequency data near 0 Hz (DC) was not
% provided.
%
% To perform this check for the rational-function approximation in this
% example, uncomment and run the following MATLAB code.

% widerFreqs = logspace(0,12,1001);
% respC7 = freqresp(fitC7,widerFreqs);
% figure
% loglog(freq,abs(tfC7),'+',widerFreqs,abs(respC7))
% respC12 = freqresp(fitC12,widerFreqs);
% figure
% loglog(freq,abs(tfC12),'+',widerFreqs,abs(respC12))

%%
% For an example of how to buld and simulate this RC tree circuit using
% RFCKT objects, go to:
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','rf_interconnectDemo_rfckt.html'));
% MOS Interconnect and Crosstalk Using RFCKT Objects>