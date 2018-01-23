%% Modeling a High-Speed Backplane (Part 5: Rational Function to a Verilog-A Module)
% This example shows how to use RF Toolbox(TM) functions to generate a
% Verilog-A module that models the high-level behavior of a high-speed
% backplane. First, it reads the single-ended 4-port S-parameters for a
% differential high-speed backplane and converts them to 2-port
% differential S-parameters. Then, it computes the transfer function of the
% differential circuit and fits a rational function to the transfer
% function. Next, the example exports a Verilog-A module that describes the
% model. Finally, it plots the unit step response of the generated
% Verilog-A module in a third-party circuit simulation tool.

%   Copyright 2006-2010 The MathWorks, Inc.

%% Use a Rational Function Object to Describe the High-Level Behavior of a High-Speed Backplane
% Read a Touchstone(R) data file, <matlab:edit('default.s4p');
% |default.s4p|>, into an <matlab:doc('sparameters'); |sparameters|>
% object. The parameters in this data file are the 50-ohm S-parameters of a
% single-ended 4-port passive circuit, measured at 1496 frequencies ranging
% from 50 MHz to 15 GHz. Then, extract the single-ended 4-port S-parameters
% from the data stored in the |Parameters| property of the |sparameters|
% object, use the <matlab:doc('rf/s2sdd'); |s2sdd|> function to convert
% them to differential 2-port S-parameters, and use the
% <matlab:doc('rf/s2tf'); |s2tf|> function to compute the transfer function
% of the differential circuit. Then, use the <matlab:doc('rf/rationalfit');
% |rationalfit|> function to generate an
% <matlab:doc('rf/rfmodel.rational'); |rfmodel.rational|> object that
% describes the high-level behavior of this high-speed backplane. The
% |rfmodel.rational| object is a rational function object that expresses
% the circuit's transfer function in closed form using poles, residues, and
% other parameters, as described in the |rationalfit| reference page.
%%
filename = 'default.s4p';
backplane = sparameters(filename);
data = backplane.Parameters;
freq = backplane.Frequencies;
z0 = backplane.Impedance;
%%
% Convert to 2-port differential S-parameters.
diffdata = s2sdd(data);  
diffz0 = 2*z0;
difftf = s2tf(diffdata,diffz0,diffz0,diffz0); 
%%
% Fit the differential transfer function into a rational function.
fittol = -30;           % Rational fitting tolerance in dB
delayfactor = 0.9;                % Delay factor
rationalfunc = rationalfit(freq,difftf,fittol,'DelayFactor',delayfactor)

%% Export the Rational Function Object as a Verilog-A Module
% Use the <matlab:doc('rf/writeva'); |writeva|> method of the
% |rfmodel.rational| object to export the rational function object as a
% Verilog-A module, called |samplepassive1|, that describes the rational
% model. The input and output nets of |samplepassive1| are called |line_in|
% and |line_out|. The predefined Verilog-A discipline, |electrical|,
% describes the attributes of these nets. The format of numeric values,
% such as the Laplace transform numerator and denominator coefficients, is
% |%12.10e|. The electrical discipline is defined in the file
% |disciplines.vams|, which is included in the beginning of the
% |samplepassive1.va| file.
workingdir = tempname;
mkdir(workingdir)
writeva(rationalfunc, fullfile(workingdir,'samplepassive1'), ...
    'line_in', 'line_out', 'electrical', '%12.10e', 'disciplines.vams');
%%
type(fullfile(workingdir,'samplepassive1.va'));

%% Plot the Unit Step Response of the Generated Verilog-A Module
% Many third-party circuit simulation tools support the Verilog-A standard.
% These tools simulate standalone components defined by Verilog-A modules
% and circuits that contain these components. The following figure shows
% the unit step response of the samplepassive1 module. The figure was
% generated with a third-party circuit simulation tool.
%
% <<generate_veriloga_fig.JPG>>
%
% *Figure 1:* The unit step response.
delete(fullfile(workingdir,'samplepassive1.va'));
rmdir(workingdir)

displayEndOfDemoMessage(mfilename)