%% IEEE Standard Figure Configuration
% run before the plot command
% IEEE Transactions and Journals: 
% Times New Roman is the suggested font in labels. 
% For a singlepart figures labels should be in 8 to 10 points,
% multipart figures, labels should be in 8 points.
% Width: column width: 8.8 cm; page width: 18.1 cm.

x = 0:0.01:2*pi;
y = cos(x);
%% width & height of the figure
k_scaling = 1; % scaling factor of the figure
% (You need to plot a figure which has a width of (8.8*k_scaling)
% in MATLAB, so that when you paste it into your paper, the width will be
% scalled down to 8.8 cm
k_width_height = 2; % width:height ratio of the figure

width = 8.8 * k_scaling;
height = width / k_width_height;

%% figure margins
top = 0.5;  % normalized top margin
bottom = 3;	% normalized bottom margin
left = 3.5;	% normalized left margin
right = 3.5; % normalized right margin

%% set default figure configurations
set(0,'defaultFigureUnits','centimeters');
set(0,'defaultFigurePosition',[0 0 width height]);

set(0,'defaultLineLineWidth',1*k_scaling);
set(0,'defaultAxesLineWidth',0.25*k_scaling);

set(0,'defaultAxesGridLineStyle',':');
set(0,'defaultAxesYGrid','on');
set(0,'defaultAxesXGrid','on');

set(0,'defaultAxesFontName','Times New Roman');
set(0,'defaultAxesFontSize',8*k_scaling);

set(0,'defaultTextFontName','Times New Roman');
set(0,'defaultTextFontSize',8*k_scaling);

set(0,'defaultLegendFontName','Times New Roman');
set(0,'defaultLegendFontSize',8*k_scaling);

set(0,'defaultAxesUnits','normalized');
set(0,'defaultAxesPosition',[left/width bottom/height (width-left-right)/width  (height-bottom-top)/height]);

set(0,'defaultAxesColorOrder',[0 0 0]);
set(0,'defaultAxesTickDir','out');

set(0,'defaultFigurePaperPositionMode','auto');

set(0,'defaultLegendLocation','best');
set(0,'defaultLegendBox','on');
set(0,'defaultLegendOrientation','vertical');


%% Plotting
plot(FreqMHz,S11)
xlabel('f_{MHZ}')
ylabel('\midS11\mid')
legend('Full Wave Sim')
