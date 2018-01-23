%% Writing A Touchstone(R) File
% This example shows how to write out the data in |rfckt| objects you
% create in the MATLAB(R) workspace into an industry-standard data file:
% Touchstone(R). You can use these files in third-party tools.
%
% This simple example shows how to create and analyze an RLCG transmission
% line object. It then shows how to write the analyzed result into a
% Touchstone file, read it back in, and compare the file data to the
% original result.

%   Copyright 2007-2015 The MathWorks, Inc.

%% Create an RF Circuit Object to Represent an RLCG Transmission Line
% Create an <matlab:doc('rf/rfckt.rlcgline'); |rfckt.rlcgline|> object to
% represent an RLCG transmission line. Create variables to represent the
% transmission line parameters and use the |set| method to update the
% |rfckt.rlcgline| object to use these values.
ckt1 = rfckt.rlcgline;
R = 0.002;                              % ohm/m 
G = 0.002;                              % S/m 
mu_0 = pi*4e-7;                         % H/m 
L = mu_0;                               % H/m
c = 299792458;                          % m/s 
epsilon_0 = 1/(mu_0*c^2);               % F/m 
C = epsilon_0;                          % F/m         
linelen = 10;                           % m 
Z_vacuum = sqrt(mu_0/epsilon_0);        % ohms
ckt1.R = R;
ckt1.G = G;
ckt1.L = L;
ckt1.C = C;
ckt1.LineLength = linelen;

%% Copy the Circuit Object
% Make a copy of the first |rfckt| object. Then change the capacitance of
% the new object to introduce mismatch that will appear as a finite
% reflection coefficient on the Smith chart.
ckt2 = copy(ckt1)
ckt2.C = 0.5*ckt1.C;

%% Cascade Two Circuit Objects
% Create an <matlab:doc('rf/rfckt.cascade'); |rfckt.cascade|> object that
% cascades the two transmission lines together.
ckt3 = rfckt.cascade('Ckts',{ckt1,ckt2}); 

%% Analyze the Cascade and Plot S-Parameter Data
% Use the <matlab:doc('rf/analyze'); |analyze|> method of the
% |rfckt.cascade| object to analyze the cascade in the frequency domain.
% Then, use the <matlab:doc('rf/smith'); |smith|> method to plot the
% object's |S11| on a Smith chart.
freq = logspace(0,8,20);
analyze(ckt3,freq); 
figure
hline = smith(ckt3,'S11');
legend(hline,'S_{11} Original')

%% Write out the Data to an S2P File
% Use the <matlab:doc('rf/rfwrite'); |rfwrite|> function to write the data
% to a file.
workingdir = tempname;
mkdir(workingdir)
filename = fullfile(workingdir,'myrlcg.s2p');
if exist(filename,'file')
    delete(filename)
end
filedata = ckt3.AnalyzedResult.S_Parameters;
rfwrite(filedata,freq,filename)

%% Inspect the S2P File
% Use the |type| function to display the contents of the |.s2p| file in the
% MATLAB command window to see the Touchstone file format.
type(filename)

%% Compare the Data
% Read the data from the file |myrlcg.s2p| into a new |rfckt| object and
% plot |S11| on a Smith chart. Visually compare this Smith chart to the
% previous one to see that the data is the same.
ckt4 = read(rfckt.passive,filename); 
figure
hline = smith(ckt4,'S11'); 
legend(hline,'S_{11} from S2P')

displayEndOfDemoMessage(mfilename)