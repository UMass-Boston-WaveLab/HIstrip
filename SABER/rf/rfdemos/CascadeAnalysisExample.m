%% Finding Cascaded Gain, Noise Figure, and IP3
% This example shows how to calculate the cascaded gain, noise figure, and
% 3rd order intercept (IP3) of a chain of RF stages.  Each stage is
% represented by a frequency independent "black box", specified with it's
% own stage gain, stage noise figure, and either an output referred stage
% IP3 (OIP3) or an input referred IP3 (IIP3).
%
% First, specify the system by defining a gain, noise figure, OIP3, and
% name for each stage.  Second, create an <matlab:doc('rf/rfchain');
% |rfchain|> object to represent the cascaded system.  To add additonal
% stages to the chain, use the <matlab:doc('rf/rfchain/addstage');
% |addstage|> function.  To change or update any stage, use the
% <matlab:doc('rf/rfchain/setstage'); |setstage|> function.  To view the
% calculated cascaded values of gain, noise figure, and IP3, use the
% functions <matlab:doc('rf/rfchain/plot'); |plot|> and
% <matlab:doc('rf/rfchain/worksheet'); |worksheet|>. To access these
% values, use the functions <matlab:doc('rf/rfchain/cumgain'); |cumgain|>,
% <matlab:doc('rf/rfchain/cumnoisefig'); |cumnoisefig|>,
% <matlab:doc('rf/rfchain/cumoip3'); |cumoip3|>, and
% <matlab:doc('rf/rfchain/cumiip3'); |cumiip3|>.
%
%% Specify the System
% In this example, we will analyze the six-stage receiver specified in [1].
% First, we must create vectors to hold the stage gains, noise figures,
% OIP3s, and names.
g  = [-2.5 15.3 -2.5 14.5  -8  35];
nf = [ 2.5  1.4  2.5  7.8   8 6.4];
o3 = [ Inf   23  Inf   22 Inf   4];
nm = {'Duplexer','LNA','ImageFilt','Mix1','IF_Filt','Mix2'};

%% Create the |rfchain| object
% Next, we use the <matlab:doc('rf/rfchain'); |rfchain|> object
% to represent the system.
sys = rfchain(g,nf,o3,'Name',nm);

%% View the Results
% Use the <matlab:doc('rf/rfchain/plot'); |plot|> function to view the
% calculated results graphically, or the
% <matlab:doc('rf/rfchain/worksheet'); |worksheet|> function to see them in
% a spreadsheet-like format.
figure
plot(sys)
worksheet(sys)

%% Change Values Inside the |rfchain|
% In the above example, it is possible that better IP3 performance in the
% 6th stage is needed. To see what the results would look like if one or
% more stages had different values, use the
% <matlab:doc('rf/rfchain/setstage'); |setstage|> function to update the
% values in a particular stage.  To view the results after the 6th stage is
% re-specified with G = 25, NF = 2.3, and OIP3 = 18:
setstage(sys,6,25,2.3,18)

figure
plot(sys)
worksheet(sys)
 
%% References
%
% [1] Les Besser and Rowan Gilmore. "Practical RF circuit design for modern
% wireless systems Vol. 1: Passive circuits and systems," Artech House Inc,
% 2003, p. 135.
