function simulink_rfmodel_build_rational_system_helper(modelname, nblock)
%SIMULINK_RFMODEL_BUILD_RATIONAL_SYSTEM_HELPER build a rational model.
%   SIMULINK_RFMODEL_BUILD_RATIONAL_SYSTEM_HELPER(MODELNAME, NBLOCK) create
%   a new simulink model that contains a rational function subsystem.
%
%   MODELNAME is the name of the new simulink model.
%   NBlock is the number of transfer function blocks in the subsystem.  
%
%   SIMULINK_RFMODEL_ADD_SOURCE_SINK_HELPER is a helper function of RF
%   Toolbox demo: Modeling a High-Speed Backplane (Part 4: Rational
%   Function Object to a Simulink Model).

%   Copyright 2006-2009 The MathWorks, Inc.

new_system(modelname,'model');
set_param(modelname, 'Location', [35, 93, 685, 230], 'SolverType', ...
    'Variable-step', 'SolverName', 'ode45', 'MaxStep', '5e-13', ...
    'StopTime', '4.9e-8', 'SingleTaskRateTransMsg', 'none')
% To change solver, click the Simulation menu and select Configuration
% Parameters.
open_system(modelname); open_system('simulink');

% Add a subsystem into the model
add_block('simulink/Ports & Subsystems/Subsystem', ...
    [modelname,'/Subsystem'], 'Position', [285, 20, 325, 80])
rational_sys = [modelname, '/Subsystem'];
open_system(rational_sys)
set_param(rational_sys, 'Location', [713, 91, 1183, 1040])
delete_line(rational_sys, 'In1/1', 'Out1/1') % Delete line between input and output port
set_param([rational_sys, '/In1'], 'Position', [25, 53, 55, 67])
set_param([rational_sys, '/Out1'], 'Position', [415, 53, 445, 67])

% Add the Gain, Delay and Add blocks
add_block('simulink/Math Operations/Gain', [rational_sys,'/Gain'], ...
    'Position', [135, 37, 195, 83], 'Gain', 'rationalfunc.D')
add_line(rational_sys, 'In1/1', 'Gain/1')
add_block('simulink/Math Operations/Add', [rational_sys,'/Add'], ...
    'Position', [260, 23, 300, 57], 'Inputs', '+')
add_line(rational_sys, 'Gain/1', 'Add/1')
add_block('simulink/Continuous/Transport Delay', [rational_sys,'/Delay'], ...
    'Position', [350, 45, 380, 75], 'BufferSize', '12288', ...
    'DelayTime', 'rationalfunc.Delay')
add_line(rational_sys, 'Add/1', 'Delay/1', 'autorouting', 'on')
add_line(rational_sys, 'Delay/1', 'Out1/1', 'autorouting', 'on')

start_pos = [135, 37, 195, 83];  
for k = 1:nblock                % Add all the Simulink Transfer Fcn blocks
    idx = num2str(k);
    start_pos(2) = start_pos(2) + 70;
    start_pos(4) = start_pos(4) + 70;
    add_block('simulink/Continuous/Transfer Fcn', ...
        [rational_sys,'/Transfcn',idx], 'Position', start_pos,...
        'Numerator', ['num{',idx,'}'], 'Denominator', ['den{',idx,'}']);
end

start_pos = [135, 37, 195, 83];
last_pos = get_param([rational_sys,'/Transfcn',num2str(nblock)], 'Position');
my_pos = get_param([rational_sys,'/Add'], 'Position');
set_param([rational_sys,'/Add'], 'Position', [my_pos(1), start_pos(2)-4, ...
    my_pos(3), last_pos(4)+4], 'Inputs', repmat('+',[1, nblock+1]));
                                % Expand the Add block
for k = 1:nblock                % Connect all the lines
    idx = num2str(k);
    idx_plus_1 = num2str(k+1);
    add_line(rational_sys, 'In1/1', ['Transfcn',idx,'/1'], 'autorouting', 'on')
    add_line(rational_sys, ['Transfcn',idx,'/1'], ['Add/',idx_plus_1], ...
        'autorouting', 'on')
end

close_system('simulink')
