%% De-Embedding S-Parameters 
% This example shows you how to extract the S-parameters of a Device
% Under Test (DUT) using the <matlab:doc('rf/deembedsparams');
% |deembedsparams|> function.
%
% This example will use the S-parameter data in the file
% <matlab:edit('samplebjt2.s2p'); |samplebjt2.s2p|> that was collected from
% a bipolar transistor in a fixture with a bond wire (series inductance 1
% nH) connected to a bond pad (shunt capacitance 100 fF) on the input, and
% a bond pad (shunt capacitance 100 fF) connected to a bond wire (series
% inductance 1 nH) on the output, see Figure 1.
%
% <<de_embed_sparams_fig.JPG>>
%
% *Figure 1:* Device under test (DUT) and the test fixture.
%
% This example will show how to remove the effects of the fixture in order
% to extract the S-parameters of the DUT.

%   Copyright 2003-2014 The MathWorks, Inc.

%% Read the Measured S-Parameters
% Create an |sparameters| object for the measured S-parameters, by reading
% the Touchstone(R) data file |samplebjt2.s2p|.
S_measuredBJT = sparameters('samplebjt2.s2p');
freq = S_measuredBJT.Frequencies;

%% Calculate S-Parameters for the Left Pad
% Create a two port |circuit| object representing the left pad, containing
% a series |inductor| and shunt |capacitor|.  Then calculate the
% S-parameters using the frequencies from |samplebjt2.s2p|.
leftpad = circuit('left');
add(leftpad,[1 2],inductor(1e-9))
add(leftpad,[2 3],capacitor(100e-15))
setports(leftpad,[1 3],[2 3])
S_leftpad = sparameters(leftpad,freq);

%% Calculate S-Parameters for the Right Pad
rightpad = circuit('right');
add(rightpad,[1 3],capacitor(100e-15))
add(rightpad,[1 2],inductor(1e-9))
setports(rightpad,[1 3],[2 3])
S_rightpad = sparameters(rightpad,freq);

%% De-Embed the S-Parameters 
% De-embed the S-parameters of the DUT from the measured S-parameters by
% removing the effects of input and output pads
% (<matlab:doc('rf/deembedsparams'); |deembedsparams|>).
S_DUT = deembedsparams(S_measuredBJT,S_leftpad,S_rightpad);

%% Plot the Measured and De-Embedded S11 Parameters on a Z Smith(R) Chart
figure
h1 = smith(S_measuredBJT,1,1);
h1.Color = [1 0 0];
hold on
h2 = smith(S_DUT,1,1);
h2.Color = [0 0 1];
legend([h1,h2],{'Measured S_{11}','De-Embedded S_{11}'})
legend show

%% Plot the Measured and De-Embedded S22 Parameters on a Z Smith Chart
hold off
h1 = smith(S_measuredBJT,2,2);
h1.Color = [1 0 0];
hold on
h2 = smith(S_DUT,2,2);
h2.Color = [0 0 1];
legend([h1,h2],{'Measured S_{22}','De-Embedded S_{22}'})
legend show

%% Plot the Measured and De-Embedded S21 Parameters in Decibels
hold off
h1 = rfplot(S_measuredBJT,2,1,'-r');
hold on
h2 = rfplot(S_DUT,2,1);
legend([h1,h2],{'Measured S_{21}','De-Embedded S_{21}'})
legend show

displayEndOfDemoMessage(mfilename)