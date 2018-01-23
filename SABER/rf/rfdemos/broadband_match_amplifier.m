%% Designing Broadband Matching Networks (Part 2: Amplifier)
% This example shows how to design broadband matching networks for a low
% noise amplifier (LNA). In an RF receiver front end, the LNA is commonly
% found immediately after the antenna or after the first bandpass filter
% that follows the antenna. Its position in the receiver chain ensures that
% it deals with weak signals that have significant noise content. As a
% result the LNA has to not only provide amplification to such signals but
% also minimize its own noise footprint on the amplified signal. In this
% example you will design an LNA to achieve the target gain and noise
% figure specifications over a specified bandwidth, using lumped LC
% elements. A direct search based approach is used to arrive at the optimum
% element values in the input and output matching network.
%
% <<broadband_match_amplifier_fig1.JPG>>
%
% *Figure 1:* Impedance matching of an amplifier

%   Copyright 2008-2010 The MathWorks, Inc.

%% Set Design Parameters
% The design specifications are as follows
%
% * Amplifier is an LNA amplifier
%
% * Center Frequency = 250 MHz
%
% * Bandwidth = 100 MHz
%
% * Transducer Gain greater than or equal to 10 dB
%
% * Noise Figure less than or equal to 2.0 dB
%
% * Operating between 50-Ohm terminations

%% Specify Bandwidth, Center Frequency, Noise Figure and Impedance
% You are building the matching network for an LNA with a bandpass
% response, so specify the bandwidth of match, center frequency, gain and
% noise figure targets.
BW = 100e6;            % Bandwidth of matching network (Hz)
fc = 250e6;            % Center frequency (Hz)
Gt_target = 10;        % Transducer gain target (dB)
NFtarget = 2;          % Max noise figure target (dB)

%%
% Here you specify the source impedance, reference impedance, and the
% load impedance.
Zs = 50;               % Source impedance (Ohm)
Z0 = 50;               % Reference impedance (Ohm)
Zl = 50;               % Load impedance (Ohm)

%% Create an Amplifier Object and Perform Analysis
% Use the <matlab:doc('rf/read'); |read|> method to create an amplifier
% object using data from the file <matlab:edit('lnadata.s2p');
% |lnadata.s2p|>.
Unmatched_Amp = read(rfckt.amplifier,'lnadata.s2p'); % Create amplifier object

%% 
% Define the number of frequency points to use for analysis and set up the
% frequency vector.
Npts = 32;                           % No. of analysis frequency points
fLower = fc - (BW/2);                % Lower band edge               
fUpper = fc + (BW/2);                % Upper band edge              
freq = linspace(fLower,fUpper,Npts); % Frequency array for analysis
w = 2*pi*freq;                       % Frequency (radians/sec)
%%
% Use the <matlab:doc('rf/analyze'); |analyze|> method to perform
% frequency-domain analysis at the frequency points in the vector freq.
analyze(Unmatched_Amp,freq,Zl,Zs,Z0);   % Analyze unmatched amplifier

%% Examine Stability, Power Gain and Noise Figure
% The LNA must operate in a stable region, so our first step is to plot
% |Delta| and |K| for the transistor being used. Use the
% <matlab:doc('rf/plot'); |plot|> method of the |rfckt| object to plot
% |Delta| and |K| as a function of frequency to see if the transistor is
% stable.
figure
plot(Unmatched_Amp,'Delta','mag')
hold all
plot(Unmatched_Amp,'K')
title('Device stability parameters')
hold off
grid on

%% 
% As the plot shows, $K > 1$ and $\Delta < 1$ for all frequencies in the
% bandwidth of interest. This means that the device is unconditionally
% stable. It is also important to view the power gain and noise figure
% behavior across the same bandwidth. Together with the stability
% information this data allows you to determine if the gain and noise
% figure targets can be met.
plot(Unmatched_Amp,'Ga','Gt','dB')

%%
% This plot, shows the power gain across the 100-MHz bandwidth. It 
% indicates that the transducer gain varies linearly between 5.5 dB to
% about 3.1 dB and achieves only 4.3 dB at band center. It also suggests
% there is sufficient headroom between the transducer gain |Gt| and the
% available gain Ga to achieve our target |Gt| of 10 dB.
plot(Unmatched_Amp,'Fmin','NF','dB')
axis([200 300 0 2])
legend('Location','NorthEast')

%% 
% This plot shows the variation of the noise figure with frequency.
% The unmatched amplifier clearly meets the target noise figure
% requirement. However this would change once the input and output matching
% networks are included. Most likely, the noise figure of
% the LNA would exceed the requirement.

%% Design Input and Output Matching Networks
% The region of operation is between 200 and 300 MHz, so you choose a 
% bandpass topology for the matching networks which is shown here,
%
% <<broadband_match_amplifier_fig2.JPG>>
%
% *Figure 2:* Matching network topology
%%
% The topology chosen, as seen in Figure 2, is a direct-coupled prototype
% bandpass network of parallel resonator type with top coupling [2], that
% is initially tuned to the geometric mean frequency with respect to the
% bandwidth of operation.
N_input = 3;           % Order of input matching network
N_output = 3;          % Order of output matching network
wU = 2*pi*fUpper;      % Upper band edge
wL = 2*pi*fLower;      % Lower band edge
w0 = sqrt(wL*wU);      % Geometric mean

%% 
% For the initial design all the inductors are assigned the same value on
% the basis of the first series inductor. As mentioned in [3], choose the
% prototype value to be unity  and use standard impedance and frequency
% transformations to obtain denormalized values [1]. The value for the
% capacitor in the parallel trap is set using this inductor value to make
% it resonate at the geometric mean frequency. Please note that there are
% many ways of designing the initial matching network. This example shows
% one possible approach.
LvaluesIn = (Zs/(wU-wL))*ones(N_input,1);    % Series and shunt L's [H]
CvaluesIn = 1 / ( (w0^2)*LvaluesIn(2));      % Shunt C [F]

%% Form the Complete Circuit with the Matching Networks and the Amplifier
% Use either the <matlab:doc('rf/rfckt.seriesrlc'); |rfckt.seriesrlc|> or
% <matlab:doc('rf/rfckt.shuntrlc'); |rfckt.shuntrlc|> constructor to build
% each branch of the matching network. Then, form the matching network from
% these individual branches by creating an
% <matlab:doc('rf/rfckt.cascade.html'); |rfckt.cascade|> object. The output
% matching network for this example is the same as the input matching
% network.
LC_InitialIn = [LvaluesIn;CvaluesIn];
LvaluesOut = LvaluesIn;
CvaluesOut = CvaluesIn;
LC_InitialOut = [LvaluesOut;CvaluesOut];

InputMatchingNW = rfckt.cascade('Ckts', ...
    {rfckt.seriesrlc('L',LvaluesIn(1)), ...
    rfckt.shuntrlc('C',CvaluesIn,'L',LvaluesIn(2)), ...
    rfckt.seriesrlc('L',LvaluesIn(3))});   
                                
OutputMatchingNW = rfckt.cascade('Ckts', ...
    {rfckt.seriesrlc('L',LvaluesOut(1)), ...
    rfckt.shuntrlc('C',CvaluesOut,'L',LvaluesOut(2)), ...
    rfckt.seriesrlc('L',LvaluesOut(3))});  

%%
% Put together the LNA network consisting of matching networks and
% amplifier by creating an |rfckt.cascade| object as shown in previous
% section.
Matched_Amp = rfckt.cascade('Ckts', ...
    {InputMatchingNW,Unmatched_Amp,OutputMatchingNW});
                                        
%% Optimize the Input & Output Matching Network
% There are several points to consider prior to the optimization.
%
% * Objective function -- The objective function can be built in different
% ways depending on the problem at hand. For this example, the objective
% function is shown in the file below.
% * Choice of cost function -- The cost function is the function you would
% like to minimize (maximize) to achieve near optimal performance. There
% could be several ways to choose the cost function. For this example you
% have two requirements to satisfy simultaneously, i.e. gain and noise
% figure. To create the cost function you first, find the difference,
% between the most current optimized network and the target value for each
% requirement at each frequency. The cost function is the L2-norm of the
% vector of gain and noise figure error values.
% * Optimization variables -- In this case it is a vector of
% values, for the specific elements to optimize in the matching network.
% * Optimization method -- A direct search based technique, the MATLAB(R)
% function <matlab:doc('matlab/fminsearch'); |fminsearch|>, is used in this
% example to perform the optimization.
% * Number of iterations/function evaluations -- Set the maximum no. of
% iterations and function evaluations to perform, so as to tradeoff between
% speed and quality of match.
% * Tolerance value -- Specify the variation in objective function value at
% which the optimization process should terminate.

%%
% The objective function used during the optimization process by
% |fminsearch| is shown here.
type('broadband_match_amplifier_objective_function.m')

%%
% The optimization variables are all the elements (inductors and
% capacitors) of the input and output matching networks.
nIter = 125; % Max No of Iterations
options = optimset('Display','iter','TolFun',1e-2,'MaxIter',nIter);   % Set options structure
LC_Optimized = [LvaluesIn;CvaluesIn;LvaluesOut;CvaluesOut];
LC_Optimized = fminsearch(@(LC_Optimized) broadband_match_amplifier_objective_function(Matched_Amp,...
                             LC_Optimized,freq,Gt_target,NFtarget,Zl,Zs,Z0),LC_Optimized,options);
                                              
%% Update Matching Network and Re-analyze LNA                       
% When the optimization routine stops, the optimized element values are
% stored in |LC_Optimized|. The following code updates the input and output
% matching network with these values.

for loop1 = 1:3
    Matched_Amp.ckts{1}.ckts{loop1}.L = LC_Optimized(loop1);
    Matched_Amp.ckts{3}.ckts{loop1}.L = LC_Optimized(loop1 + 4);
end
Matched_Amp.ckts{1}.ckts{2}.C = LC_Optimized(4);
Matched_Amp.ckts{3}.ckts{2}.C = LC_Optimized(8);
analyze(Matched_Amp,freq,Zl,Zs,Z0); % Analyze LNA

%% Verify the Design
% The results of optimization can be viewed by plotting the transducer gain
% and the noise figure across the bandwidth, and comparing it with the
% unmatched amplifier.
plot(Matched_Amp,'Gt')
hold all
plot(Unmatched_Amp,'Gt')
plot(Matched_Amp,'NF')
plot(Unmatched_Amp,'NF')
legend('G_t  - Matched','G_t  - Unmatched','NF - Matched',...
       'NF - Unmatched','Location','East')
axis([freq(1)*1e-6 freq(end)*1e-6 0 12])
hold off

%%
% The plot shows, the target requirement for both gain and noise figure
% have been met. To understand the effect of optimizing with respect to
% only the transducer gain, use the first choice for the cost function
% (which involves only the gain term) within the objective function shown
% above.

%% Display Optimized Element Values
% The optimized inductor and capacitor values for the input matching
% network are shown below.
Lin_Optimized = LC_Optimized(1:3)
Cin_Optimized = LC_Optimized(4) 

%%
% Similarly, here are the optimized inductor and capacitor values for the
% output matching network
Lout_Optimized = LC_Optimized(5:7)
Cout_Optimized = LC_Optimized(8)

%% References
%
% [1] RF Circuit Design, Theory and Applications, Reinhold Ludwig and P.
% Bretchko, pp 229-239, Prentice Hall, 2000.
%
% [2] Broadband Direct-Coupled and Matching RF networks, Thomas R.
% Cuthbert, pp 31-33, TRCPEP, 1999.
%
% [3] Thomas R.Cuthbert, A Real Frequency Technique Optimizing Broadband
% Equalizer Elements, IEEE(R) International Symposium on Circuits and Systems,
% 2000.
%
% [4] Microwave Engineering, David M.Pozar, 2nd ed., John Wiley and Sons,
% 1999.

displayEndOfDemoMessage(mfilename)