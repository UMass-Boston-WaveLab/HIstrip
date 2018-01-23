%% Bandpass Filter Response
% This example shows how to compute the time-domain response of a simple
% bandpass filter:
%
% # Choose inductance and capacitance values using the classic image
% parameter design method.
% # Use <matlab:doc('rf/circuit'); |circuit|>, <matlab:doc('rf/capacitor');
% |capacitor|>, and <matlab:doc('rf/inductor'); |inductor|> with the
% <matlab:doc('rf/add'); |add|> function to programmatically construct a
% Butterworth circuit.
% # Use <matlab:doc('rf/setports'); |setports|> to define the circuit as a
% 2-port network.
% # Use <matlab:doc('rf/sparameters'); |sparameters|> to extract the
% S-parameters of the 2-port network over a wide frequency range.
% # Use <matlab:doc('rf/s2tf'); |s2tf|> to compute the voltage transfer
% function from the input to the output.
% # Use <matlab:doc('rf/rationalfit'); |rationalfit|> to generate rational
% fits that capture the ideal RC circuit to a very high degree of accuracy.
% # Create a noisy input voltage waveform.
% # Use <matlab:doc('rf/timeresp'); |timeresp|> to compute the
% transient response to a noisy input voltage waveform.

%% Design a Bandpass Filter by Image Parameters
% The image parameter design method is a framework for analytically
% computing the values of the series and parallel components in passive
% filters. For more information on this method, see "Complete Wireless
% Design" by Cotter W. Sayre, McGraw-Hill 2008 p. 331.
%
% <<rf_bpf_rlc.png>>
%
% *Figure 1:* A Butterworth bandpass filter built out of two half-sections.
%
% The following MATLAB code generates component values for a bandpass
% filter with a lower 3-dB cutoff frequency of 2.4 GHz and an upper 3-dB
% cutoff frequency of 2.5 GHz.

Ro = 50;
f1C = 2400e6;
f2C = 2500e6;

Ls = (Ro / (pi*(f2C - f1C)))/2;
Cs = 2*(f2C - f1C)/(4*pi*Ro*f2C*f1C);

Lp = 2*Ro*(f2C - f1C)/(4*pi*f2C*f1C);
Cp = (1/(pi*Ro*(f2C - f1C)))/2;

%% Programmatically Construct the Circuit
% Before building the circuit using <matlab:doc('rf/inductor'); |inductor|>
% and <matlab:doc('rf/capacitor'); |capacitor|> objects, we must number the
% nodes of the circuit shown in figure 1.
%
% <<rf_bpf_rlc_withnodenum.png>>
%
% *Figure 2:* Node numbers added to the Butterworth bandpass filter.
%
% Create a <matlab:doc('rf/circuit'); |circuit|> object and populate it
% with <matlab:doc('rf/inductor'); |inductor|> and
% <matlab:doc('rf/capacitor'); |capacitor|> objects using the
% <matlab:doc('rf/add'); |add|> function.  
%

ckt = circuit('butterworthBPF');

add(ckt,[3 2],inductor(Ls))
add(ckt,[4 3],capacitor(Cs))
add(ckt,[5 4],capacitor(Cs))
add(ckt,[6 5],inductor(Ls))

add(ckt,[4 1],capacitor(Cp))
add(ckt,[4 1],inductor(Lp))
add(ckt,[4 1],inductor(Lp))
add(ckt,[4 1],capacitor(Cp))

%% Extract S-Parameters From the 2-Port Network
% To extract S-parameters from the circuit object, first use the
% <matlab:doc('rf/setports'); |setports|> function to define the circuit as
% a 2-port network.  Once the circuit has ports, use
% <matlab:doc('rf/sparameters'); |sparameters|> to extract the S-parameters
% at the frequencies of interest.

freq = linspace(2e9,3e9,101);

setports(ckt,[2 1],[6 1])
S = sparameters(ckt,freq);

%% Fit the Transfer Function of the Circuit to a Rational Function
% Use the <matlab:doc('rf/s2tf'); |s2tf|> function to generate a transfer
% function from the S-parameter object. Then use
% <matlab:doc('rf/rationalfit'); |rationalfit|> to fit the transfer
% function data to a rational function.

tfS = s2tf(S);
fit = rationalfit(freq,tfS);

%% Verify the Rational Fit Approximation
% Use the <matlab:doc('rf/freqresp'); |freqresp|> function to verify that
% the rational fit approximation has reasonable behavior outside both sides
% of the fitted frequency range.

widerFreqs = linspace(2e8,5e9,1001);
resp = freqresp(fit,widerFreqs);

figure
semilogy(freq,abs(tfS),widerFreqs,abs(resp),'--','LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Magnitude')
legend('data','fit')
title('The rational fit behaves well outside the fitted frequency range.')

%% Construct an Input Signal to Test the Band Pass Filter
% This bandpass filter should be able to recover a sinusoidal signal at
% 2.45 GHz that is made noisy by the inclusion of zero-mean random noise
% and a blocker at 2.35 GHz. The following MATLAB code constructs such a
% signal from 4096 samples.

fCenter = 2.45e9;
fBlocker = 2.35e9;
period = 1/fCenter;
sampleTime = period/16;
signalLen = 8192;
t = (0:signalLen-1)'*sampleTime; % 256 periods

input = sin(2*pi*fCenter*t);     % Clean input signal
rng('default')
noise = randn(size(t)) + sin(2*pi*fBlocker*t);
noisyInput = input + noise;      % Noisy input signal

%% Compute the Transient Response to the Input Signal
% The <matlab:doc('rf/timeresp'); |timeresp|> function computes 
% the analytic solution to the state-space equations defined by the
% rational fit and the input signal.

output = timeresp(fit,noisyInput,sampleTime);

%% View Input Signal and Filter Response in the Time Domain 
% Plot the input signal, noisy input signal, and the band pass filter 
% output in a figure window.

xmax = t(end)/8;
figure
subplot(3,1,1)
plot(t,input)
axis([0 xmax -1.5 1.5])
title('Input')

subplot(3,1,2)
plot(t,noisyInput)
axis([0 xmax floor(min(noisyInput)) ceil(max(noisyInput))])
title('Noisy Input')
ylabel('Amplitude (volts)')

subplot(3,1,3)
plot(t,output)
axis([0 xmax -1.5 1.5])
title('Filter Output')
xlabel('Time (sec)')

%% View Input Signal and Filter Response in the Frequency Domain 
% Overlaying the noisy input and the filter response in the frequency
% domain explains why the filtering operation is successful. Both the
% blocker signal at 2.35 GHz and much of the noise is significantly
% attenuated.

NFFT = 2^nextpow2(signalLen); % Next power of 2 from length of y
Y = fft(noisyInput,NFFT)/signalLen;
samplingFreq = 1/sampleTime;
f = samplingFreq/2*linspace(0,1,NFFT/2+1)';
O = fft(output,NFFT)/signalLen;

figure
subplot(2,1,1)
plot(freq,abs(tfS),'b','LineWidth',2)
axis([freq(1) freq(end) 0 1.1])
legend('filter transfer function')
ylabel('Magnitude')

subplot(2,1,2)
plot(f,2*abs(Y(1:NFFT/2+1)),'g',f,2*abs(O(1:NFFT/2+1)),'r','LineWidth',2)
axis([freq(1) freq(end) 0 1.1])
legend('input+noise','output')
title('Filter characteristic and noisy input spectrum.')
xlabel('Frequency (Hz)')
ylabel('Magnitude (Volts)')

%%
% For an example of how to compute and display this bandpass filter
% response using RFCKT objects, go to:
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','rf_bpfDemo_rfckt.html'));
% Bandpass Filter Response Using RFCKT Objects>
