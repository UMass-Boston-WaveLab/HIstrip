classdef rfchain < handle & matlab.mixin.CustomDisplay
%RFCHAIN Create an RF Cascade Analysis Object
%   OBJ = RFCHAIN creates an rfchain object with zero stages.  You can grow
%   the chain using the addstage function.
%
%   OBJ = RFCHAIN(G,NF,O3,'Name',NM) creates an RFCHAIN object with N
%   stages, where the gain G, the noise figure NF, and the OIP3 O3 are
%   vectors of length N, and the name NM is a cell array of length N.
%
%   OBJ = RFCHAIN(G,NF,'IIP3',I3,'Name',NM) creates an RFCHAIN object with
%   N stages, specifying an IIP3 for each stage, instead of an OIP3.
%   
%   You can alternately specify one more properties using name-value pairs.
%   For example: OBJ = RFCHAIN('Gain',[10 -5 7],'OIP3',[15 Inf 5])
%
%PROPERTIES:
%   NumStages - The number of stages within the RF chain
%
%   Name - A cell array containing the name for each stage in the RF
%   chain
%
%   Gain - A vector containing the gain in dB for each stage of the RF
%   chain
%
%   NoiseFigure - A vector containing the noise figure for each stage
%   of the RF chain
%
%   OIP3 - A vector containing the output referred 3rd order intercept
%   point in dB for each stage of the RF chain
%
%   IIP3 - A vector containing the input referred 3rd order intercept point
%   in dB for each stage of the RF chain
%
%EXAMPLES:
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   o3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % View the results in a table
%   worksheet(ch)
%
% See also addstage, setstage, rfchain/plot, rfchain/worksheet
    
    % User Visible
    properties(Dependent)
        Gain
        NoiseFigure
        OIP3
        IIP3
        Name
    end
    properties(SetAccess = private,Dependent)
        NumStages
    end
    
    % Infrastruture
    properties(Access = private)
        NameMap
        ChainData = struct
        UseOIP3 = logical.empty
        CascadedGain = []
        CascadedNoiseFigure = []
        CascadedIIP3 = []
        Dirty = true
    end
    properties(Dependent,Access = private)
        CascadedOIP3 = []
    end
    properties(Constant,Access = private)
        DefaultGain = 0;
        DefaultNoiseFigure = 0;
        DefaultOIP3 = Inf;
        DefaultIIP3 = Inf;
    end
    
    % public
    methods
        function setstage(obj,idx,varargin)
%SETSTAGE Update the values of a stage in an RF chain
%   SETSTAGE(OBJ,IDX,G,NF,O3,'Name',NM) updates the values of an rfchain
%   object OBJ in the stage or stages specified by IDX.  IDX can be a
%   integer or a vector of integers. The stage is specified by a gain of G,
%   a noise figure of NF, and an output referred 3rd order intercept point
%   of O3.  The stage will have the name NM. You can only change the name
%   of one stage at a time.
%
%   You can alternately specify one more properties using name-value pairs.
%   For example: SETSTAGE(OBJ,2,'IIP3',10,'Name','lna1')
%
%EXAMPLES:
%
%   % Create an rfchain object using the following values
%   g = [11 -3];
%   nf = [25 3];
%   o3 = [30 Inf];
%   nm = {'amp1','filt1'};
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % Change the noise figure in the second stage to 20 dB.  All other
%   % values in that stage will be unchanged.
%   setstage(ch,2,'NoiseFigure',20)
%   
%   % Show the results in a worksheet
%   worksheet(ch)
%
% See also rfchain, addstage, rfchain/plot, rfchain/worksheet
            
            narginchk(3,10)
            
            % Error if rfchain is empty
            nstages = obj.NumStages;
            if nstages == 0
                % error('Cannot use the setstage function on an empty rfchain object.')
                error(message('rf:shared:RFChainSetStageOnEmpty'))
            end
            
            % Validate idx
            validateattributes(idx,{'numeric'},...
                {'vector','real','integer','positive','<=',nstages},...
                '','Stage Index')
            nidx = numel(idx);
            if nidx ~= numel(unique(idx))
                error(message('rf:shared:RFChainUniqueStageIndex'))
            end
            idx = idx(:).';
            
            % Parse inputs
            res = parseStageInput(varargin{:});
            res = updateParserResults(obj,res,nidx);
            
            % Update user visible properties
            % Must set Name first because errors may be thrown
            if ~(res.UsingDefault.Name)
                if nidx > 1
                    error(message('rf:shared:RFChainSetStageTooManyNames'))
                end
                % Update Name and throw error is name swap is not possible
                replaceName(obj.NameMap,obj.Name{idx},res.Name{1})
                obj.ChainData.Name{idx} = res.Name{1};
            end
            if ~(res.UsingDefault.Gain)
                obj.ChainData.Gain(idx) = res.Gain(:).';
            end
            if ~(res.UsingDefault.NoiseFigure)
                obj.ChainData.NoiseFigure(idx) = res.NoiseFigure(:).';
            end
            if ~(res.UsingDefault.OIP3)
                obj.ChainData.IP3(idx) = res.IP3(:).';
                obj.UseOIP3(idx) = true;
            end
            if ~(res.UsingDefault.IIP3)
                obj.ChainData.IP3(idx) = res.IP3(:).';
                obj.UseOIP3(idx) = false;
            end
            
            % Update Dirty
            obj.Dirty = true;
        end
        
        function addstage(obj,varargin)
%ADDSTAGE Append one or more new stages onto an RF chain object
%   ADDSTAGE(OBJ,G,NF,O3,'Name',NM) appends one or more new stage onto an
%   rfchain object OBJ.  The new stages can be specified by a gain of G, a
%   noise figure of NF, and an output referred 3rd order intercept point of
%   O3. G, NF, and O3 can be either scalars or vectors of the same length.
%   The new stage will have a name NM.  NM can be a string or a cell array
%   of strings.
%
%   ADDSTAGE(OBJ,G,NF,'IIP3',I3,'Name',NM) appends new stages onto the RF
%   chain object OBJ using an IIP3 value instead of an OIP3 value.
%
%   You can alternately specify one more properties using name-value pairs.
%   For example: ADDSTAGE(OBJ,'Gain',10,'Name','lna1')
%
%EXAMPLES:
%
%   % Create an rfchain object
%   ch = rfchain;
% 
%   % Add stage 1: G = 11 dB, NF = 25 dB, and default IP3 and Name
%   addstage(ch,11,25)
% 
%   % Add stage 2: G = -3 dB, Name = 'filt1', default values for NF and IP3
%   addstage(ch,-3,'Name','filt1')
%   
%   % Show the results in a worksheet
%   worksheet(ch)
%
% See also rfchain, setstage, rfchain/plot, rfchain/worksheet
            
            narginchk(2,9)
            res = parseStageInput(varargin{:});
            N = max([numel(res.Gain),numel(res.NoiseFigure),...
                numel(res.IP3),numel(res.Name)]);
            res = updateParserResults(obj,res,N);
            obj.ChainData.Gain(end+1:end+N) = res.Gain;
            obj.ChainData.NoiseFigure(end+1:end+N) = res.NoiseFigure;
            obj.ChainData.IP3(end+1:end+N) = res.IP3;
            obj.UseOIP3(end+1:end+N) = res.UsingDefault.IIP3;
            for n = 1:N
                newname = insertName(obj.NameMap,res.Name{n});
                obj.ChainData.Name{end+1} = newname;
            end
            
            % Update Dirty
            obj.Dirty = true;
        end
        
        function varargout = plot(obj)
% PLOT Plots the cascade analysis results in a figure
%    PLOT(OBJ) plots the cascaded gain, noise figure, OIP3, and IIP3 of the
%    rfchain in a figure window.
%
%    H = PLOT(OBJ) returns a column vector of lineseries handles, where H
%    contains one handle per line plotted.
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   o3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % Plot the results
%   plot(ch)
%
% See also rfchain, addstage, rfchain/worksheet, rfchain/cumgain,
% rfchain/cumnoisefig, rfchain/cumoip3, rfchain/cumiip3
            
            % Return if NumStages = 0
            nstages = obj.NumStages;
            if nstages == 0
                if nargout
                    varargout{1} = plot([]);
                end
                return
            end
            stagevec = 1:nstages;
            
            % Calculate the values to be plotted
            g = cumgain(obj);
            nf = cumnoisefig(obj);
            o3 = cumoip3(obj);
            i3 = cumiip3(obj);
            
            % Plot data
            h1 = plot(stagevec,g,'-x');
            hstate = ishold;
            hold on
            h2 = plot(stagevec,nf,'-o');
            % Only plot ip3 is it is non-Inf somewhere
            if isinf(o3(end))
                out = [h1;h2];
                legend('Gain','Noise Figure','Location','Southwest')
            else
                h3 = plot(stagevec,o3,'-^');
                h4 = plot(stagevec,i3,'-s');
                out = [h1;h2;h3;h4];
                legend('Gain','Noise Figure','OIP3','IIP3',...
                    'Location','Southwest')
            end
            if ~hstate
                hold off
            end
            
            % Set y-axis label and title
            ylabel('dB')
            title('Cascade Analysis')
            
            % Set x-axis tick marks as vertical names for each stage
            ax = h1.Parent;
            ax.XTick = stagevec;
            ax.XTickLabel = '';
            
            % Text height in "data" units
            y = ax.YLim(1) - (ax.YLim(2)-ax.YLim(1))/50;
            maxletters = 7; % To accomodate "stage10","stage11", etc.
            maxext = 0;
            for n = stagevec
                % Truncate if needed
                name = obj.Name{n};
                if numel(name) > maxletters
                    name = [name(1:(maxletters-1)),'...'];
                end
                % Underbars are a special char to the text object
                name = strrep(name,'_','\_');
                % Make a text object for each stage
                txt(n) = text(n,y,name); %#ok<AGROW>
                % Store maximum extent in pixels
                ext = getExtentInUnits(txt(n),'pixels');
                maxext = max(maxext,ext(3));
            end
            % Ensure the figure is wide enough to handle the longest name
            ax.Units = 'pixels';
            figpos = ax.Parent.Position;
            axpos = ax.Position;
            newaxbottom = max(axpos(2),1.3*maxext);
            delta = newaxbottom - axpos(2);
            axpos(2) = axpos(2) + delta;
            figpos = figpos + [0,-1*delta,0,delta];
            ax.Parent.Position = figpos;
            ax.Position = axpos;
            ax.Units = 'normalized';
            
            % Rotate all the text objects
            set(txt,'HorizontalAlignment','right')
            set(txt,'Rotation',90)
            
            if nargout
                varargout{1} = out;
            end
        end
        
        function varargout = worksheet(obj)
% WORKSHEET Displays the cascade analysis results in a tabular format
%    WORKSHEET(OBJ) shows both the original input values and the calculated
%    cascaded gain, noise figure, OIP3, and IIP3 of the rfchain in a
%    graphical table.
%
%    FIG = WORKSHEET(OBJ) returns a figure handle.
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   o3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % View the results in a table
%   worksheet(ch)
%
% See also rfchain, addstage, rfchain/plot, rfchain/cumgain,
% rfchain/cumnoisefig, rfchain/cumoip3, rfchain/cumiip3
            
            % Values to be put into the table
            cascG = cumgain(obj);
            cascNF = cumnoisefig(obj);
            cascO3 = cumoip3(obj);
            cascI3 = cumiip3(obj);
            G = obj.Gain;
            NF = obj.NoiseFigure;
            O3 = obj.OIP3;
            I3 = obj.IIP3;
            nstages = obj.NumStages;
            
            % Build full cell array
            dat = cell(9,nstages);
            cfmt = cell(1,nstages);
            for n = 1:nstages
                dat{1,n} = G(n);
                dat{2,n} = NF(n);
                dat{3,n} = O3(n);
                dat{4,n} = I3(n);
                dat{5,n} = '';
                dat{6,n} = cascG(n);
                dat{7,n} = cascNF(n);
                dat{8,n} = cascO3(n);
                dat{9,n} = cascI3(n);
                cfmt{n} = 'char';
            end
            
            rnames = {'Stage Gain';'Stage Noise Figure';'Stage OIP3';...
                'Stage IIP3';'';'Cascaded Gain';'Cascaded Noise Figure';...
                'Cascaded OIP3';'Cascaded IIP3'};
            
            % Create figure and table
            f = figure('Visible','off');
            t = uitable('Parent',f,'Data',dat,'ColumnName',obj.Name,...
                'RowName',rnames,'ColumnFormat',cfmt);
            t.Tag = 'rfchaintable';
            f.ResizeFcn = @rfchainresizefcn;
            rfchainresizefcn(f)
            fpos = f.Position;
            tpos = t.Position;
            f.Position = [fpos(1:3),tpos(4)+40];
            f.ToolBar = 'none';
            f.PaperPositionMode = 'auto';
            
            if nargout
                varargout{1} = f;
            end
            f.Visible = 'on';
        end
        
        function o3 = cumoip3(obj)
%CUMOIP3 Calculate the cascaded output referred 3rd order intercept point
%   O3 = CUMOIP3(OBJ) calculates the cascaded OIP3 value for each stage in
%   the RF chain OBJ using the forumla:
%
%   (Using linear values)
%   linearOIP3 = linearIIP3*linearGain
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   o3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % Get the calculated OIP3 value at each stage
%   O3 = cumoip3(ch);
%
% See also rfchain, addstage, rfchain/cumiip3, rfchain/cumgain,
% rfchain/cumnoisefig
            
            analyze(obj)
            o3 = obj.CascadedOIP3;
        end
        
        function i3 = cumiip3(obj)
%CUMIIP3 Calculate the cascaded input referred 3rd order intercept point
%   I3 = CUMIIP3(OBJ) calculates the cascaded IIP3 value for each stage in
%   the RF chain OBJ using the forumla:
%
%   (Using linear values)
%   1/linearIIP3(total) = 1/linearIIP3(1) + ...
%                         linearGain(1)/linearIIP3(2) + ...
%                         linearGain(1)*linearGain(2)/linearIIP3(3) + ...
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   i3 = [19 Inf 3];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,'IIP3',i3,'Name',nm);
%   
%   % Get the calculated IIP3 value at each stage
%   I3 = cumiip3(ch);
%
% See also rfchain, addstage, rfchain/cumoip3, rfchain/cumgain,
% rfchain/cumnoisefig
            
            analyze(obj)
            i3 = obj.CascadedIIP3;
        end
        
        function g = cumgain(obj)
%CUMGAIN Calculate the cascaded gain
%   G = CUMGAIN(OBJ) calculates the cascaded gain for each stage in the RF
%   chain OBJ.
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, IIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   i3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % Get the calculated IIP3 value at each stage
%   g = cumgain(ch);
%
% See also rfchain, addstage, rfchain/cumiip3, rfchain/cumoip3,
% rfchain/cumnoisefig
            
            analyze(obj)
            g = obj.CascadedGain;
        end
        
        function nf = cumnoisefig(obj)
%CUMNOISEFIG Calculate the cascaded noise figure
%   NF = CUMNOISEFIG(OBJ) calculates the cascaded noise figure for each
%   stage in the RF chain OBJ using the forumla:
%
%   (First calculate the noise factor)
%   noisefactor(total) = noisefactor(1) + (noisefactor(1)-1)/g1 + ...
%   noisefigure = 10*log10(noisefactor)
%
%EXAMPLES:
%
%   % Stage-by-stage values for Gain, Noise Figure, OIP3, and stage names
%   g = [11 -3 7];
%   nf = [25 3 5];
%   o3 = [30 Inf 10];
%   nm = {'amp1','filt1','lna1'};
%   
%   % Create an rfchain object
%   ch = rfchain(g,nf,o3,'Name',nm);
%   
%   % Get the calculated IIP3 value at each stage
%   nf = cumnoisefig(ch);
%
% See also rfchain, addstage, rfchain/cumiip3, rfchain/cumoip3,
% rfchain/cumgain
            
            analyze(obj)
            nf = obj.CascadedNoiseFigure;
        end
    end
    
    % constructor
    methods
        function obj = rfchain(varargin)
            obj.NameMap = rf.internal.NameMap;
            
            % Initialize ChainData structure
            obj.ChainData.Gain = [];
            obj.ChainData.NoiseFigure = [];
            obj.ChainData.IP3 = [];
            obj.ChainData.Name = {};
            if nargin
                addstage(obj,varargin{:})
            end
        end
    end
    
    % set
    methods
        function set.Gain(obj,newGain)
            valGain(newGain)
            N = numel(newGain);
            nstages = obj.NumStages;
            if nstages == 0
                obj.ChainData.Name = defaultNames(nstages,N);
                obj.ChainData.NoiseFigure = ...
                    repmat(obj.DefaultNoiseFigure,1,N);
                obj.ChainData.IP3 = repmat(obj.DefaultOIP3,1,N);
                obj.UseOIP3 = true(1,N);
            else
                if N ~= nstages
                    error(message('rf:shared:RFChainBadDotSet','Gain'))
                end
            end
            obj.ChainData.Gain = newGain(:).';
            obj.Dirty = true;
        end
        
        function set.NoiseFigure(obj,newNF)
            valNF(newNF)
            N = numel(newNF);
            nstages = obj.NumStages;
            if nstages == 0
                obj.ChainData.Name = defaultNames(nstages,N);
                obj.ChainData.Gain = repmat(obj.DefaultGain,1,N);
                obj.ChainData.IP3 = repmat(obj.DefaultOIP3,1,N);
                obj.UseOIP3 = true(1,N);
            else
                if N ~= nstages
                    error(message('rf:shared:RFChainBadDotSet',...
                        'NoiseFigure'))
                end
            end
            obj.ChainData.NoiseFigure = newNF(:).';
            obj.Dirty = true;
        end
        
        function set.OIP3(obj,newOIP3)
            valGain(newOIP3)
            N = numel(newOIP3);
            nstages = obj.NumStages;
            if nstages == 0
                obj.ChainData.Name = defaultNames(nstages,N);
                obj.ChainData.Gain = repmat(obj.DefaultGain,1,N);
                obj.ChainData.NoiseFigure = ...
                    repmat(obj.DefaultNoiseFigure,1,N);
            else
                if N ~= nstages
                    error(message('rf:shared:RFChainBadDotSet','OIP3'))
                end
            end
            obj.ChainData.IP3 = newOIP3(:).';
            obj.UseOIP3 = true(1,N);
            obj.Dirty = true;
        end
        
        function set.IIP3(obj,newIIP3)
            valGain(newIIP3)
            N = numel(newIIP3);
            nstages = obj.NumStages;
            if nstages == 0
                obj.ChainData.Name = defaultNames(nstages,N);
                obj.ChainData.Gain = repmat(obj.DefaultGain,1,N);
                obj.ChainData.NoiseFigure = ...
                    repmat(obj.DefaultNoiseFigure,1,N);
            else
                if N ~= nstages
                    error(message('rf:shared:RFChainBadDotSet','IIP3'))
                end
            end
            obj.ChainData.IP3 = newIIP3(:).';
            obj.UseOIP3 = false(1,N);
            obj.Dirty = true;
        end
        
        function set.Name(obj,newName)
            valName(newName)
            if ischar(newName)
                newName = {newName};
            end
            N = numel(newName);
            nstages = obj.NumStages;
            if nstages == 0
                obj.ChainData.Gain = repmat(obj.DefaultGain,1,N);
                obj.ChainData.NoiseFigure = ...
                    repmat(obj.DefaultNoiseFigure,1,N);
                obj.ChainData.IP3 = repmat(obj.DefaultOIP3,1,N);
                obj.UseOIP3 = true(1,N);
                obj.Dirty = true;
            else
                if N ~= nstages
                    error(message('rf:shared:RFChainBadDotSet','Name'))
                end
                obj.NameMap = rf.internal.NameMap;
            end
            obj.ChainData.Name = cell(1,N);
            for n = 1:N
                obj.ChainData.Name{n} = insertName(obj.NameMap,newName{n});
            end
        end
    end
    
    % get
    methods
        function g = get.Gain(obj)
            g = obj.ChainData.Gain;
        end
        
        function nf = get.NoiseFigure(obj)
            nf = obj.ChainData.NoiseFigure;
        end
        
        function nm = get.Name(obj)
            nm = obj.ChainData.Name;
        end
        
        function nstages = get.NumStages(obj)
            nstages = numel(obj.Gain);
        end
        
        function o3 = get.OIP3(obj)
            o3 = obj.ChainData.IP3 + (~obj.UseOIP3).*(obj.Gain);
        end
        
        function i3 = get.IIP3(obj)
            i3 = obj.ChainData.IP3 - (obj.UseOIP3).*(obj.Gain);
        end
        
        function o3 = get.CascadedOIP3(obj)
            o3 = obj.CascadedIIP3 + obj.CascadedGain;
        end
    end
    
    % disp
    methods(Access = protected)
        function footer = getFooter(obj)
            if ~isscalar(obj)
                footer = getFooter@matlab.mixin.CustomDisplay(obj);
            else
                footer = sprintf('  Use %s or %s for cascade results\n',...
                    sprintf('<a href="matlab:worksheet(%s)">worksheet</a>',inputname(1)),...
                    sprintf('<a href="matlab:plot(%s)">plot</a>',inputname(1)));
            end
        end
    end
    
    % private utility
    methods(Hidden,Access = private)
        function res = updateParserResults(obj,res,numnewstg)
            
            % Gain
            if isscalar(res.Gain)
                res.Gain = repmat(res.Gain,1,numnewstg);
            else
                if numel(res.Gain) ~= numnewstg
                    error(message('rf:shared:RFChainLengthMismatch','Gain',num2str(numnewstg)))
                end
            end
            % Noise Figure
            if isscalar(res.NoiseFigure)
                res.NoiseFigure = repmat(res.NoiseFigure,1,numnewstg);
            else
                if numel(res.NoiseFigure) ~= numnewstg
                    error(message('rf:shared:RFChainLengthMismatch','Noise Figure',num2str(numnewstg)))
                end
            end
            % IP3
            if isscalar(res.IP3)
                res.IP3 = repmat(res.IP3,1,numnewstg);
            else
                if numel(res.IP3) ~= numnewstg
                    if res.UsingDefault.OIP3
                        errstr = 'IIP3';
                    else
                        errstr = 'OIP3';
                    end
                    error(message('rf:shared:RFChainLengthMismatch',errstr,num2str(numnewstg)))
                end
            end
            % Name
            if res.UsingDefault.Name
                numoldstg = obj.NumStages;
                res.Name = cell(1,numnewstg);
                for n = 1:numnewstg
                    res.Name{n} = sprintf('stage%d',numoldstg+n);
                end
            else
                numnewnames = numel(res.Name);
                if numnewnames > 1
                    if numnewnames ~= numnewstg
                        error(message('rf:shared:RFChainLengthMismatch','Name',num2str(numnewstg)))
                    end
                else
                    name = res.Name{1};
                    res.Name = cell(1,numnewstg);
                    for n = 1:numnewstg
                        res.Name{n} = name;
                    end
                end
            end
        end
        
        function analyze(obj)
            % Function that updates the CascadedGain, CascadedNoiseFigure,
            % and CascadedIIP3 properties
            
            % Return if current
            if ~obj.Dirty
                return
            end
            
            % Calc cascaded gain
            % All calculations are power - thus 10's and not 20's
            obj.CascadedGain = cumsum(obj.Gain);
            gainprod = 10.^(obj.CascadedGain/10);
            
            % Calc Noise Figure via the noise factor
            nfact = 10.^(obj.NoiseFigure/10);
            nfact(2:end) = (nfact(2:end)-1)./gainprod(1:(end-1));
            obj.CascadedNoiseFigure = 10*log10(cumsum(nfact));
            
            % Calc IIP3 in dB via linear terms
            linIIP3 = 10.^(obj.IIP3/10);
            linIIP3 = 1./linIIP3;
            linIIP3(2:end) = linIIP3(2:end).*gainprod(1:(end-1));
            obj.CascadedIIP3 = 10*log10(1./cumsum(linIIP3));
            
            % Update Dirty
            obj.Dirty = false;
        end
    end
end

function res = parseStageInput(varargin)
    % Validates "varargin" inputs for addstage and setstage

    % Parse and validate inputs
    p = inputParser;
    addOptional(p,'gain',0,@(x)valGain(x));
    addOptional(p,'noisefigure',0,@(x)valNF(x));
    addOptional(p,'oip3',Inf,@(x)valOIP3(x));
    addParameter(p,'name','stagename',@(x)valName(x));
    addParameter(p,'iip3',Inf,@(x)valIIP3(x));
    parse(p,varargin{:})

    % Store which properties are using their defaults
    res.UsingDefault.Gain = any(strcmp('gain',p.UsingDefaults));
    res.UsingDefault.NoiseFigure = ...
        any(strcmp('noisefigure',p.UsingDefaults));
    res.UsingDefault.Name = any(strcmp('name',p.UsingDefaults));
    res.UsingDefault.OIP3 = any(strcmp('oip3',p.UsingDefaults));
    res.UsingDefault.IIP3 = any(strcmp('iip3',p.UsingDefaults));

    % Ensure only one IP3 was given
    if ~(res.UsingDefault.OIP3) && ~(res.UsingDefault.IIP3)
        error(message('rf:shared:RFChainIP3Clash'))
    end

    % Store results
    res.Gain = p.Results.gain;
    res.NoiseFigure = p.Results.noisefigure;
    if ischar(p.Results.name)
        res.Name = {p.Results.name};
    else
        res.Name = p.Results.name;
    end
    if ~(res.UsingDefault.IIP3)
        res.IP3 = p.Results.iip3;
    else
        res.IP3 = p.Results.oip3;
    end
end

function valGain(g)
    validateattributes(g,{'numeric'},{'nonempty','vector','real'},...
        '','Gain')
end

function valNF(nf)
    validateattributes(nf,{'numeric'},...
        {'nonempty','vector','real','nonnegative'},'','NoiseFigure')
end

function valName(nm)
    if ischar(nm)
        nm = {nm};
    end
    validateattributes(nm,{'cell','char'},{'nonempty','vector'},...
        '','Stage Name')
    for k = 1:numel(nm)
        rf.internal.validateMLname(nm{k},'Stage Name')
    end
    if numel(nm) ~= numel(unique(nm))
        error(message('rf:shared:RFChainUniqueName'))
    end
end

function valOIP3(o3)
    validateattributes(o3,{'numeric'},{'nonempty','vector','real'},...
        '','OIP3')
end

function valIIP3(i3)
    validateattributes(i3,{'numeric'},{'nonempty','vector','real'},...
        '','IIP3')
end

function names = defaultNames(numStages,numNames)
    names = cell(1,numNames);
    for n = 1:numNames
        names{n} = sprintf('stage%d',numStages+n);
    end
end

function rfchainresizefcn(f,~)
% Figure callback to keep the table aligned with the figure

c = f.Children;
if isscalar(c)
    t = c;
else
    % Customer did something
    for n = 1:numel(c)
        if isprop(c(n),'Tag')
            if strcmp(c(n).Tag,'rfchaintable')
                t = c(n);
                break
            end
        end
    end
end
fpos = f.Position;
tpos = t.Position;
ext = t.Extent;

tpos(4) = ext(4);
if ext(3) <= (fpos(3) - 40)
    tpos(3) = ext(3);
else
    tpos(3) = fpos(3) - 40;
    tpos(4) = tpos(4) + 15;
end

t.Position = tpos;
end