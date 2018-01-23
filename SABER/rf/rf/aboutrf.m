function aboutrf
%ABOUTRF About the RF Toolbox.
%   ABOUTRF Displays the version number of the RF Toolbox and the copyright
%   notice in a modal dialog box.

%   Copyright 2003-2010 The MathWorks, Inc.
 
tlbx = ver('rf');
str = sprintf([tlbx.Name ' ' tlbx.Version '\n',...
	'Copyright 2003-' datestr(tlbx.Date,10) ' The MathWorks, Inc.']);
msgbox(str,'About the RF Toolbox','modal');
% [EOF] aboutrf.m