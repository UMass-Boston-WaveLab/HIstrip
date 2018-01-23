function output = broadband_match_amplifier_objective_function(AMP,LC_Optim,freq,Gt_target,NF,Zl,Zs,Z0)
%BROADBAND_MATCH_AMPLIFIER_OBJECTIVE_FUNCTION Is the objective function.
% OUTPUT =  BROADBAND_MATCH_AMPLIFIER_OBJECTIVE_FUNCTION(AMP,LC_OPTIM,FREQ,GT_TARGET,NF,Zl,Zs,Z0) 
% returns the current value of the objective function stored in OUTPUT
% evaluated after updating the element values in the object, AMP. The
% inductor and capacitor values are stored in the variable LC_OPTIM.
%
% BROADBAND_MATCH_AMPLIFIER_OBJECTIVE_FUNCTION is an objective function of RF Toolbox demo:
% Designing Broadband Matching Networks (Part II: Amplifier)
 
%   Copyright 2008 The MathWorks, Inc.

% Ensure positive element values
if any(LC_Optim<=0)                                                          
    output = inf;
    return;
end
% Update matching network elements - The object AMP has several properties
% among which the cell array 'ckts' consists of all circuit objects from
% source to load.  Since RFCKT.CASCADE was used twice, first to form the
% matching network itself and a second time to form the LNA, we have to
% step through two sets of cell arrays to access the elements
for loop1 = 1:3
    AMP.ckts{1}.ckts{loop1}.L  = LC_Optim(loop1);
    AMP.ckts{3}.ckts{loop1}.L  = LC_Optim(loop1+4);
end
AMP.ckts{1}.ckts{2}.C    = LC_Optim(4);
AMP.ckts{3}.ckts{2}.C    = LC_Optim(8);

% Perform analysis on tuned matching network
Npts           = length(freq);                                        
analyze(AMP,freq,Zl,Zs,Z0);

% Calculate target parameters of the Amplifier
target_param   = calculate(AMP,'Gt','NF','dB');
Gt             = target_param{1}(1:Npts,1);
NF_amp         = target_param{2}(1:Npts,1);

% Calculate Target Gain and noise figure error
errGt          = (Gt - Gt_target);          
errNF          = (NF_amp - NF);

% Check to see if gain and noise figure target are achieved by specifying
% bounds for variation.
deltaG         = 0.40;               
deltaNF        = -0.05;
errGt(abs(errGt)<=deltaG) = 0;
errNF(errNF<deltaNF) = 0;

% Cost function
err_vec        = [errGt;errNF];
output         = norm((err_vec),2);               

% Animate
Gmax           = (Gt_target + deltaG).*ones(1,Npts);
Gmin           = (Gt_target - deltaG).*ones(1,Npts);
plot(AMP,'Gt','NF','dB');
hold on
plot(freq.*1e-6,Gmax,'r-*')
plot(freq.*1e-6,Gmin,'r-*')
legend('G_t','NF','Gain bounds','Location','East');
axis([freq(1)*1e-6 freq(end)*1e-6 0 Gt_target+2]);
hold off
drawnow;