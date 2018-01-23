%% RF Circuit Objects 
% This example shows how to create and use RF Toolbox(TM) circuit objects.
% In this example, you create three circuit (|rfckt|) objects: two
% transmission lines and an amplifier. You visualize the amplifier data
% using RF Toolbox(TM) functions and retrieve frequency data that was read
% from a file into the amplifier |rfckt| object. Then you analyze the
% amplifier over a different frequency range and visualize the results.
% Next, you cascade the three circuits to create a cascaded |rfckt| object.
% Then you analyze the cascaded network and visualize its S-parameters over
% the original frequency range of the amplifier. Finally, you plot the
% |S11|, |S22|, and |S21| parameters and noise figure of the cascaded
% network.

%   Copyright 2003-2014 The MathWorks, Inc.

%% Create |rfckt| Objects
% Create three circuit objects: two transmission lines, and an amplifier
% using data from <matlab:edit('default.amp'); |default.amp|> data file.
FirstCkt = rfckt.txline;
SecondCkt = rfckt.amplifier('IntpType','cubic');
read(SecondCkt,'default.amp');
ThirdCkt = rfckt.txline('LineLength',0.025,'PV',2.0e8);

%% View Properties of |rfckt| Objects
% You can use the |get| function to view an object's properties. For example,
PropertiesOfFirstCkt = get(FirstCkt)
%%
PropertiesOfSecondCkt = get(SecondCkt)
%%
PropertiesOfThirdCkt = get(ThirdCkt)

%% List Methods of |rfckt| Objects
% You can use the |methods| function to list an object's methods. For example,
MethodsOfThirdCkt = methods(ThirdCkt);

%% Change Properties of |rfckt| Objects
% Use the |set| function to change the line length of the first transmission line.
DefaultLength = FirstCkt.LineLength;
%%
FirstCkt.LineLength = .001;
NewLength = FirstCkt.LineLength;
%% Plot the Amplifier S11 and S22 Parameters
% Use the <matlab:doc('rf/smith'); |smith|> method of circuit object to
% plot the original |S11| and |S22| parameters of the amplifier
% (|SecondCkt|) on a Z Smith chart. The original frequencies of the
% amplifier's S-parameters range from 1.0 GHz to 2.9 GHz.
figure
smith(SecondCkt,'S11','S22');
legend show

%% Plot the Amplifier Pin-Pout Data
% Use the <matlab:doc('rf/plot'); |plot|> method of circuit object to plot
% the amplifier (|SecondCkt|) Pin-Pout data, in dBm, at 2.1 GHz on an X-Y
% plane.
plot(SecondCkt,'Pout','dBm')
legend show
set(legend,'Location','NorthWest')
%% Get the Original Frequency Data and the Result of the Analyzing the Amplifier over the Original Frequencies
% When the RF Toolbox reads data from default.amp into an amplifier object
% (|SecondCkt|), it also analyzes the amplifier over the frequencies of
% network parameters in default.amp file and store the result at the
% property |AnalyzedResult|. Here are the original amplifier frequency and
% analyzed result over it.
f = SecondCkt.AnalyzedResult.Freq;
data = SecondCkt.AnalyzedResult

%% Analyze the Amplifier over a New Frequency Range and Plot Its New S11 and S22 
% To visualize the S-parameters of a circuit over a different frequency
% range, you must first analyze it over that frequency range.
analyze(SecondCkt,1.85e9:1e7:2.55e9);
smith(SecondCkt,'S11','S22','zy');
legend show

%% Create and Analyze a Cascaded |rfckt| Object
% Cascade three circuit objects to create a cascaded circuit object, and
% then analyze it at the original amplifier frequencies which range from
% 1.0 GHz to 2.9 GHz.
CascadedCkt = rfckt.cascade('Ckts',{FirstCkt,SecondCkt,ThirdCkt});
analyze(CascadedCkt,f);

%%
% <<ckt_obj_fig.JPG>>
%
% *Figure 1:* The cascaded circuit.

%% Plot the S11 and S22 Parameters of the Cascaded Circuit 
% Use the |smith| method of circuit object to plot |S11| and |S22| of the
% cascaded circuit (|CascadedCkt|) on a Z Smith chart.
smith(CascadedCkt,'S11','S22','z');
legend show

%% Plot the S21 Parameters of the Cascaded Circuit 
% Use the |plot| method of circuit object to plot |S21| of the cascaded
% circuit (|CascadedCkt|) on an X-Y plane.
plot(CascadedCkt,'S21','dB')
legend show

%% Plot the Budget S21 Parameters and Noise Figure of the Cascaded Circuit
% Use the |plot| method of circuit object to plot the budget |S21|
% parameters and noise figure of the cascaded circuit (|CascadedCkt|) on an
% X-Y plane.
plot(CascadedCkt,'budget','S21','NF')
legend show

displayEndOfDemoMessage(mfilename)