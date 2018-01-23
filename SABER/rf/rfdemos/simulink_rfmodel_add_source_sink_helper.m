function simulink_rfmodel_add_source_sink_helper(mdlname)
%SIMULINK_RFMODEL_ADD_SOURCE_SINK_HELPER add a random source and a scope
%   SIMULINK_RFMODEL_ADD_SOURCE_SINK_HELPER(MDLNAME) add a random source
%   and a scope to a simulink model.
%
%   MDLNAME is the name of the model.
%
%   SIMULINK_RFMODEL_ADD_SOURCE_SINK_HELPER is a helper function of RF
%   Toolbox demo: Modeling a High-Speed Backplane (Part 4: Rational
%   Function Object to a Simulink Model).

%   Copyright 2006-2014 The MathWorks, Inc.

open_system(mdlname);
open_system('simulink');

% Add random source
add_block('simulink/Sources/Random Number',[mdlname,'/Random Number'], ...
    'Position',[35 35 65 65],'SampleTime','1e-9')
add_block('simulink/Math Operations/Sign',[mdlname,'/Sign'], ...
    'Position',[110 35 140 65])
add_line(mdlname,'Random Number/1','Sign/1')
add_line(mdlname,'Sign/1','Subsystem/1')

% Add scope
add_block('simulink/Sinks/Scope', [mdlname,'/Rational Model Output'], ...
    'Position', [510, 20, 545, 60], 'NumInputPorts', '2', ...
    'YMin', '-1.2~-1', 'YMax', '1.2~1', 'TimeRange', '5e-8', ...
    'LimitDataPoints', 'off')

add_line(mdlname,'Sign/1','Rational Model Output/1','autorouting','on')
add_line(mdlname,'Subsystem/1','Rational Model Output/2')

close_system('simulink')