%% Modeling a High-Speed Backplane (Part 1: Measured 16-Port S-Parameters to 4-Port S-Parameters)
% This example shows how to use RF Toolbox(TM) to import N-port
% S-parameters representing high-speed backplane channels, and converts
% 16-port S-parameters to 4-port S-parameters to model the channels and the
% crosstalk between the channels.
%
% With the 4-port S-parameters, a rational function object can be built for
% a differential channel. The second part of the example --
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','rational_differential.html'));
% Modeling a High-Speed Backplane (Part 2: 4-Port S-Parameters to a Rational Function)>
% -- will show how to use rational functions to model a
% differential high-speed backplane channel.
%
% With the rational function object, the Time-Domain Reflectometry and
% Time-Domain Transmission can be calculated for a differential channel.
% The third part of the example --
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','tdr_tdt_calculation.html'));
% Modeling a High-Speed Backplane (Part 3: 4-Port S-Parameters to Differential TDR and TDT)>
% -- will show how to use rational functions to
% calculate the Time-Domain Reflectometry and Time-Domain Transmission.
%
% With the rational function object, a Simulink(R) model can be built for a
% differential channel. The fourth part of the example --
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','simulink_rfmodel.html'));
% Modeling a High-Speed Backplane (Part 4: Rational Function to a Simulink Model)>
% -- will show how to build a Simulink model from a rational
% function.
%
% With the rational function object, a Verilog-A module can also be
% generated for a differential channel. The fifth part of the example --
% <matlab:helpview(fullfile(matlabroot,'toolbox','rf','rfdemos','html','generate_veriloga.html'));
% Modeling a High-Speed Backplane (Part 5: Rational Function to a Verilog-A Module)>
% -- will show how to generate a Verilog-A module from a rational
% function.
%
% <<nport_network_fig.JPG>>
%
% *Figure 1:* 16-Port differential backplane

%   Copyright 2007-2010 The MathWorks, Inc.

%% Read the Single-Ended 16-Port S-Parameters
% Read a Touchstone(R) data file into an <matlab:doc('sparameters');
% |sparameters|> object. The data in this file are the 50-ohm S-parameters
% of a 16-port differential backplane designed for a 2-Gbps high-speed
% signal, shown in Figure 1, measured at 1496 frequencies ranging from 50
% MHz to 15 GHz.
filename = 'default.s16p';
backplane = sparameters(filename)
freq = backplane.Frequencies;

%% Convert the 16-Port S-Parameters to 4-Port S-Parameters to Model a Differential Channel
% Use the <matlab:doc('rf/snp2smp'); |snp2smp|> function to convert 16-port
% S-parameters to 4-port S-parameters that represent the first differential
% channel. The port index of this differential channel, |N2M|, which
% specifies how the ports of the 16-port S-parameters map to the ports of
% the 4-port S-parameters, is |[1 16 2 15]|. (The port indices of the
% second, third and fourth channels are |[3 14 4 13]|, |[5 12 6 11]| and
% |[7 10 8 9]|, respectively). The other 12 ports, |[3 4 5 6 7 8 9 10 11 12
% 13 14]|, are terminated with the characteristic |Impedance| specified by
% the |sparameters| object. Then, create an |sparameters| object with
% 4-port S-parameters for the first differential channel.
%
%                   (Port 1)         (Port 16)
%          Port 1  > ----->|         |<----- <   Port 2
%                          |   DUT   |
%          Port 3  > ----->|         |<----- <   Port 4
%                   (Port 2)         (Port 15)
%%
n2m = [1 16 2 15];
z0 = backplane.Impedance;
first4portdata = snp2smp(backplane.Parameters,z0,n2m,z0);
first4portsparams = sparameters(first4portdata,freq,z0)

%%
% Plot |S21| and |S43| of the first differential channel.
figure
rfplot(first4portsparams,2,1)
hold on
rfplot(first4portsparams,4,3,'-r')
% % If you want to write the 4-port S-parameters of the differential
% % channel into a |.s4p| file, then uncomment the line below.
%
% rfwrite(first4portsparams,'firstchannel.s4p')

%% Convert 16-Port S-Parameters to 4-Port S-Parameters to Model the Crosstalk Between Two Differential Channels
% Use the |snp2smp| function to convert 16-port S-parameters to 4-port
% S-parameters that represent the crosstalk between port |[3 4]| and port
% |[16 15]|. As shown in Figure 1, these ports are on different channels.
% The other 12 ports, |[1 2 5 6 7 8 9 10 11 12 13 14]|, are terminated with
% the characteristic |Impedance| specified by the |sparameters| object.
% Then, create an |sparameters| object with 4-port S-parameters for the
% crosstalk.
%
%                   (Port 3)         (Port 16)
%          Port 1  > ----->|         |<----- <   Port 2
%                          |   DUT   |
%          Port 3  > ----->|         |<----- <   Port 4
%                   (Port 4)         (Port 15)
%%
n2m = [3 16 4 15];
crosstalk4portdata = snp2smp(backplane.Parameters,z0,n2m,z0);
crosstalk4portsparams = sparameters(crosstalk4portdata,freq,z0)

%%
% Plot |S21|, |S43|, |S12| and |S34| to show the crosstalk between these
% two channels.
figure
rfplot(crosstalk4portsparams,2,1)
hold on
rfplot(crosstalk4portsparams,4,3,'-r')
rfplot(crosstalk4portsparams,1,2,'-k')
rfplot(crosstalk4portsparams,3,4,'-g')
% % If you want to write the 4-port S-parameters of the crosstalk into an
% % .s4p file, then uncomment the line below.
%
% rfwrite(crosstalk4portsparams,'crosstalk.s4p')

displayEndOfDemoMessage(mfilename)