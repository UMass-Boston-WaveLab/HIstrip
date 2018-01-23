% RF Toolbox
% Version 3.2 (R2017a) 16-Feb-2017
%
%   Network Data Objects
%       sparameters       - Extract or convert to S-parameter data
%       tparameters       - Extract or convert to T-parameter data
%       yparameters       - Extract or convert to Y-parameter data
%       zparameters       - Extract or convert to Z-parameter data
%       hparameters       - Extract or convert to h-parameter data
%       gparameters       - Extract or convert to g-parameter data
%       abcdparameters    - Extract or convert to ABCD parameter data
%
%   RF Utility Functions
%
%     Analysis
%       rationalfit       - Perform rational function fitting to broadband data
%       ispassive         - Check passivity of N-port S-parameters
%       makepassive       - Make N-port S-parameters passive
%       stabilityk        - Calculate stability factor K of 2-port network
%       stabilitymu       - Calculate stability factor Mu of 2-port network
%       s2tf              - Calculate transfer function from 2-port S-parameters
%       powergain         - Calculate power gain from 2-port S-parameters
%       gammams           - Calculate GammaMS from 2-port S-parameters
%       gammaml           - Calculate GammaML from 2-port S-parameters
%       gammain           - Calculate GammaIn from 2-port S-parameters
%       gammaout          - Calculate GammaOut from 2-port S-parameters
%       gamma2z           - Calculate impedance from reflection coefficient
%       z2gamma           - Calculate reflection coefficient from impedance
%       vswr              - Calculate VSWR from reflection coefficient
%       cascadesparams    - Cascade S-parameters
%       deembedsparams    - De-embed S-parameters
%       groupdelay        - Calculate group delay
%       newref            - Calculate S-parameters for new impedance value
%       rfparam           - Return column vector of network parameter data
%       snp2smp           - Convert N-port S-parameters to M-port S-parameters
%       s2t               - Convert S-parameters to T-parameters
%       t2s               - Convert T-parameters to S-parameters
%       rlgc2s            - Convert transmission line RLGC-parameters to S-parameters
%       s2rlgc            - Convert S-parameters to transmission line RLGC-parameters 
%
%     Mixed-mode S-parameters
%       s2smm             - Convert single-ended S-parameters to mixed-mode S-parameters
%       smm2s             - Convert mixed-mode S-parameters to single-ended S-parameters
%       s2sdd             - Convert S-parameters to differential S-parameters
%       s2sdc             - Convert S-parameters to cross mode (Sdc) S-parameters
%       s2scd             - Convert S-parameters to cross mode (Scd) S-parameters
%       s2scc             - Convert S-parameters to common mode S-parameters
%
%     Plot support
%       smithchart        - Draw numeric data on Smith chart
%       smith             - Plot object data on Smith chart
%       rfplot            - Plot S-parameter data
%
%   RF Data Objects
%       rfdata            - Create RF data object
%       rfmodel           - Create rational function model
%
%   Construct RF Networks
%       rfckt             - Create object for frequency-domain analysis and visualization of RF circuits
%       circuit           - Build network with arbitrary topology for S-parameter extraction
%       resistor          - Create resistor to insert into circuit
%       capacitor         - Create capacitor to insert into circuit
%       inductor          - Create inductor to insert into circuit
%       nport             - Create N-port device, defined by S-parameter data, to insert into circuit
%
%   Frequency Planning
%       OpenIF            - Create frequency planning object
%
%   Graphical User Interfaces
%       rfBudgetAnalyzer  - Open RF Budget Analyzer
%       rftool            - Open RF Analysis GUI
%
%   See also RFDEMOS

% Copyright 2003-2017 The MathWorks, Inc.
