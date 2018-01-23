classdef OpenIF < hgsetget
%OpenIF Intermediate Frequency (IF) Planner
%   h = OpenIF returns an object that helps to identify clear areas
%   of spectrum that are suitable for use as IFs for a single- or
%   multi-band radio system.
%
%   h = OpenIF(propname,propval) returns an IF planning object and sets the
%   specified properties to the provided values.
%
%   h = OpenIF(ifbwval) returns an IF planning object that uses a single
%   value for the IF bandwidth of every mixer added using the
%   <a href="matlab:help OpenIF.addMixer">addMixer</a> method, instead of 
%   specifying an IF bandwidth for each individual mixer.  ifbwval is the 
%   IF bandwidth in Hz.
%
%   h = OpenIF(ifbwval,propname,propval) returns an IF planning object with
%   all IF bandwidths set to ifbwval and the specified properties set to
%   the provided values.
%
%   ----------
%   Properties
%   ----------
%
%   IFLocation - Specify whether the IF is at the input of the system
%   (upconversion) or at the output of the system (downconversion). Can be
%   set to 'MixerInput' or 'MixerOutput'.
%
%   SpurFloor - The maximum spur value to be considered.
%
%   IFBW - The system-wide IF bandwidth. If you specify the IF bandwidth
%   when you create the OpenIF object, that value will be used for every
%   mixer added with the <a href="matlab:help OpenIF.addMixer">addMixer</a>
%   method.  If you do not specify a value for the IF bandwidth when you
%   create the OpenIF object, you must specify one for each mixer.
%
%   --------------------
%   Read Only Properties
%   --------------------
%
%   Mixers - Property which holds the information of each Mixer/RF
%   combination.  You can add a Mixer to the OpenIF object using the
%   <a href="matlab:help OpenIF.addMixer">addMixer</a> method.
%
%   NumMixers - The number of Mixers in the OpenIF object.
%
%   --------------
%   OpenIF Methods
%   --------------
%
%   addMixer(h,newIMT,newRFCF,newRFBW,newMixType)
%       For more information type:
%       help <a href="matlab:help OpenIF.addMixer">OpenIF/addMixer</a>
%
%   allfreqs = getSpurFreeZoneData(h)
%       For more information type:
%       help <a href="matlab:help OpenIF.getSpurFreeZoneData">OpenIF/getSpurFreeZoneData</a>
%
%   [allfreqs, dBs, mixers, MNs] = getSpurData(h)
%       For more information type:
%       help <a href="matlab:help OpenIF.getSpurData">OpenIF/getSpurData</a>
%
%   report(h)
%       For more information type:
%       help <a href="matlab:help OpenIF.report">OpenIF/report</a>
%
%   show(h)
%       For more information type:
%       help <a href="matlab:help OpenIF.show">OpenIF/show</a>
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF(50e6,'IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low')
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high')
%
%       % Check for spur-free zones
%       report(h)

%#ok<*AGROW>
    properties
        IFLocation = 'MixerOutput'
        SpurFloor = 99
        IFBW = 'Specified in each Mixer'
    end
    
    properties (Hidden)
        FreqUnits = 'Hz'
    end
    
    properties(Hidden, SetAccess = private)
        Mixers = []
    end
    
    properties(Dependent)
        NumMixers
    end
    
    properties(Dependent, GetAccess = private, SetAccess = private)
        SpurFreeZoneList = []
        AllSpurs = []
    end
    
    methods % Set methods
        function set.FreqUnits(theObj, newFreqUnit)
            if ~(ischar(newFreqUnit) && isvector(newFreqUnit))
                % error('FreqUnits must a character array')
                error(message('rf:openif:openif:setfrequnits:NotCharVector'))
            end
            
            switch lower(newFreqUnit)
                case 'hz'
                    theObj.FreqUnits = 'Hz';
                case 'khz'
                    theObj.FreqUnits = 'kHz';
                case 'mhz'
                    theObj.FreqUnits = 'MHz';
                case 'ghz'
                    theObj.FreqUnits = 'GHz';
                otherwise
                    % error('FreqUnits must be Hz, kHz, MHz, or GHz')
                    error(message('rf:openif:openif:setfrequnits:InvalidFreqUnits'))
            end
        end
        
        function set.SpurFloor(theObj, newSpurFloor)
            if ~(isscalar(newSpurFloor) && isnumeric(newSpurFloor) && ...
                 isreal(newSpurFloor) && (newSpurFloor <= 99))
                % error('SpurFloor must a real numeric scalar and be no greater than 99')
                error(message('rf:openif:openif:setspurfloor:InvalidSpurFloor'))
            end
            
            theObj.SpurFloor = newSpurFloor;
        end
        
        function set.IFLocation(theObj, newIFLoc)
            switch lower(newIFLoc)
                case 'mixerinput'
                    theObj.IFLocation = 'MixerInput';
                case 'mixeroutput'
                    theObj.IFLocation = 'MixerOutput';
                otherwise
                    % error('IFLocation must be a character array set to ''MixerInput'' or ''MixerOutput''.')
                    error(message('rf:openif:openif:setiflocation:InvalidIFLocation'))
            end
            theObj.makeallspursnotcurrent;
        end
        
    end
    
    methods % Get methods
        function allsfz = get.SpurFreeZoneList(theObj)
            allsfz = [];
            allspursobj = theObj.AllSpurs;
            if isempty(allspursobj)
                return
            end
            
            [allspurfreqs, allspurdbs] = theObj.getSpurData;
            
            [~,idx] = sort(allspurfreqs(:,1));
            allspurfreqs = [allspurfreqs(idx,1), allspurfreqs(idx,2)];
            allspurdbs = allspurdbs(idx);
            
            RFmin = Inf;
            for nn = 1:theObj.NumMixers
                RFmin = min(RFmin, ...
                     theObj.Mixers(nn).RFCF - 0.5*theObj.Mixers(nn).RFBW);
            end
            
            k = 2;
            lastfreq = allspurfreqs(1,2);
            if(allspurfreqs(1) > 0)
                newSFZ = rf.openif.OpenIFSpurFreeZone(0, allspurfreqs(1), 99);
                allsfz = [allsfz; newSFZ];
            end
            while((k <= length(allspursobj)) && (lastfreq < RFmin))
                if allspurdbs(k) < theObj.SpurFloor
                    if(allspurfreqs(k,1) > lastfreq)
                        newSFZ = rf.openif.OpenIFSpurFreeZone(lastfreq, allspurfreqs(k,1), theObj.SpurFloor);
                        allsfz = [allsfz; newSFZ];
                    end

                    lastfreq = max(lastfreq, allspurfreqs(k,2));
                end
                k = k + 1;
            end
            
        end
        
        function mixercount = get.NumMixers(theObj)
            mixercount = length(theObj.Mixers);
        end
        
        function allthespurs = get.AllSpurs(theObj)
            allthespurs = [];
            for nn = 1:theObj.NumMixers
                theObj.Mixers(nn).calcspurs(theObj.IFLocation);
                allthespurs = vertcat(allthespurs, theObj.Mixers(nn).SpurVector); 
            end
        end
    end
    
    methods % Constructor
        function thisObj = OpenIF(varargin)
            if nargin == 0 % Use IFBW default
                propstartidx = 1;
            else
                if mod(nargin,2) == 1
                    newIFBW = varargin{1};
                    
                    if ~(isscalar(newIFBW) && isnumeric(newIFBW) && ...
                         isreal(newIFBW) && (newIFBW>0))
                        % error('IFBW must a positive real scalar')
                        error(message('rf:openif:openif:openif:InvalidIFBW'))
                    end

                    thisObj.IFBW = newIFBW;
                    propstartidx = 2;
                else
                    propstartidx = 1;
                end            
            end
            
            for nn = (propstartidx):2:nargin
                if(~ischar(varargin{nn}) || ...
                   nargin == nn          || ...
                   ~any(strcmpi(varargin{nn}, properties(thisObj))) )
                    % error(['For the OpenIF class, input number ' num2str(nn) ' must be the name of a parameter (expressed as a character array) and it must be followed by the value you wish to set that parameter to.'])
                    error(message('rf:openif:openif:openif:BadParamValuePair', num2str(nn)))
                end
                set(thisObj, varargin{nn}, varargin{nn+1})
            end
        end
    end
    
    methods(Access = private) % Private util methods
        
        function makeallspursnotcurrent(theObj)
            for nn = 1:theObj.NumMixers
                theObj.Mixers(nn).makespurvectornotcurrent;
            end
        end
        
        function validateopenifinputs(theObj)
            for nn = 1:theObj.NumMixers
                
                switch lower(theObj.IFLocation)
                    case 'mixerinput'
                        if any(strcmp(theObj.Mixers(nn).MixingType, {'low', 'high'}))
                            % error('If IFLocation is set to ''MixerInput'', MixerType must be set to either ''sum'' or ''diff''. If IFLocation is set to ''MixerOutput'', MixerType must be set to either ''low'' or ''high''.')
                            error(message('rf:openif:openif:validateopenifinputs:IFLocationvsMixingType'))
                        end
                    case 'mixeroutput'
                        if any(strcmp(theObj.Mixers(nn).MixingType, {'sum', 'diff'}))
                            % Same error as above
                            error(message('rf:openif:openif:validateopenifinputs:IFLocationvsMixingType'))
                        end
                    otherwise
                        % error('Invalid setting for IFLocation.')
                        error(message('rf:openif:openif:validateopenifinputs:InvalidIFLocation'))
                end
            end
        end
    end
    
    methods % Public util methods
        
        function report(theObj)
%REPORT Summarize IF planning results in the command window.
%   report(h)
%   Provides a textual summary of all the current values stored
%   within the object, as well as a list of open spur-free zones.
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF('IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low',50e6)
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high',50e6)
%
%       % Check for spur-free zones
%       report(h)


            spc = '     ';
            tempFloor = theObj.SpurFloor;
            s = sprintf('\n%sIntermediate Frequency (IF) Planner',spc);
            s = sprintf('%s\n%sIF Location: %s\n%s',s,spc,theObj.IFLocation,spc);
            if theObj.NumMixers == 0
                s = sprintf('%s\n%sThere are no Mixers defined.',s,spc);
                s = sprintf('%s\n%sUse the addMixer method to add mixers.',s,spc);
                s = sprintf('%s\n%sType %s for more information.\n%s',s,spc,rf.internal.makehelplinkstr('OpenIF','help OpenIF'),spc);
            else
                for mm = 1:theObj.NumMixers
                    [r,c] = size(theObj.Mixers(mm).IMT);
                    s = sprintf('%s\n%s-- MIXER %d --',s,spc,mm);
                    [y,~,u] = engunits(theObj.Mixers(mm).RFCF);
                    s = sprintf('%s\n%sRF Center Frequency: %g %sHz',s,spc,y,u);
                    [y,~,u] = engunits(theObj.Mixers(mm).RFBW);
                    s = sprintf('%s\n%sRF Bandwidth: %g %sHz',s,spc,y,u);
                    [y,~,u] = engunits(theObj.Mixers(mm).IFBW);
                    s = sprintf('%s\n%sIF Bandwidth: %g %sHz',s,spc,y,u);
                    s = sprintf('%s\n%sMixerType: %s',s,spc,theObj.Mixers(mm).MixingType);
                    s = sprintf('%s\n%sIntermodulation Table: ',s,spc);
                    for rr = 1:r
                        for cc = 1:c
                            s = sprintf('%s%4d',s,theObj.Mixers(mm).IMT(rr,cc));
                        end
                        s = sprintf('%s\n%s                       ',s,spc);
                    end
                end
                if isempty(theObj.SpurFreeZoneList)
                    s = sprintf('%s\n%sThere are no spur-free zones.',s,spc);
                    allspurdBs = [];
                    for nn = 1:theObj.NumMixers
                        allspurdBs = [allspurdBs;theObj.Mixers(nn).IMT(:)];
                    end
                    allspurdBs = sort(unique(allspurdBs),'descend');
                    k = 1;
                    while((k <= length(allspurdBs)) && isempty(theObj.SpurFreeZoneList))
                        k = k + 1;
                        theObj.SpurFloor = allspurdBs(k);
                    end
                s = sprintf('%s\n%sThe best attainable spur-free zone has a SpurFloor of %g.\n%s',s,spc,allspurdBs(k),spc);
                else
                    s = sprintf('%s\n%sSpur-Free Zones:\n%s',s,spc,spc);
                    for nn = 1:length(theObj.SpurFreeZoneList)
                        [val1,mult1,units1] = ...
                            engunits(theObj.SpurFreeZoneList(nn).FreqRange(1));
                        val2 = mult1*theObj.SpurFreeZoneList(nn).FreqRange(2);
                        s = sprintf('%s%7.2f - %7.2f %sHz\n%s',s,val1,val2,units1,spc);
                    end
                end
            end
            theObj.SpurFloor = tempFloor;
            disp(s)
        end

        function [allfreqs,varargout] = getSpurData(theObj)
%getSpurData Return data related to the spurs
%   allfreqs = getSpurData(h);
%   [allfreqs,dBs,mixers,MNs] = getSpurData;
%   Return relevant data for all the spurs calculated by OpenIF. If K
%   spurs are calculated:
%       * allfreqs is a K-by-2 matrix where each row gives the
%       start and stop frequencies of that spur.
%       * dBs is a K-by-1 vector where each entry is the dBc value
%       (relative to the output) of that spur. 
%       * mixers is a K-by-1 vector where each entry identifies the
%       mixer that caused the spur.
%       * MNs is a K-by-2 matrix containing the values of M and N that
%       were used to calculate this spur.
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF('IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low',50e6)
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high',50e6)
%
%       % Check for spur-free zones
%       allspurs = getSpurData(h);

            allspursobj = theObj.AllSpurs;
            [allfreqs,dBs,mixers,~,MNs] = allspursobj.getData;
            
            if nargout > 1
                varargout{1} = dBs;
                if nargout > 2
                    mixeridx = zeros(length(mixers),1);
                    for nn = 1:theObj.NumMixers,
                        mixeridx = mixeridx + nn*(mixers == theObj.Mixers(nn));
                    end
                    varargout{2} = mixeridx;
                    if nargout > 3
                        varargout{3} = MNs;
                    end
                end
            end
        end
        
        function allfreqs = getSpurFreeZoneData(theObj)
%getSpurFreeZoneData Return frequency data related to the spur-free zones
%   allfreqs = getSpurFreeZoneData(h);
%   Calculate spur-free zones. The output allfreqs is a K-by-2
%   matrix, where K is the number of spur-free zones, and each row
%   contains the start and stop frequency of that zone.
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF('IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low',50e6)
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high',50e6)
%
%       % Check for spur-free zones
%       sfzfreqs = getSpurFreeZoneData(h);
            allfreqs = zeros(length(theObj.SpurFreeZoneList),2);
            for nn = 1:length(theObj.SpurFreeZoneList)
                allfreqs(nn,:) = theObj.SpurFreeZoneList(nn).FreqRange;
            end
        end
        
        function addMixer(theObj,varargin)
%addMixer Add an additional mixer/RF specification
%   addMixer(h,newIMT,newRFCF,newRFBW,newMixType,newIFBW) Add a new
%   Mixer to the OpenIF object. 
%
%   The method accepts five inputs: an intermodulation table, an RF center
%   frequency, an RF bandwidth, a Mixer type, and an IF bandwidth.  If the
%   IFLocation property is set to 'MixerInput', then the Mixer type must be
%   'sum' or 'diff'.  If the IFLocation property is set to 'MixerOutput',
%   then the Mixer type must be 'low' or 'high'.
%
%   newIMT must be a matrix of size 2x2 or greater; it does not have to be
%   square.  Values in the matrix are intermodulation levels in dB. Columns
%   of the matrix represent integer multiples of the local oscillator (LO)
%   of the mixer, where column one is 0*LO, column 2 is 1*LO, etc.
%   Rows of the matrix represent multipliers for the input frequency to the
%   mixer.  newIMT(2,2) must be 0, which is the reference level for the
%   output of the mixer.  Positive values represent greater attenuation.
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF('IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low',50e6)
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high',50e6)
            if nargin == 2
                if ~isa(varargin{1},'rf.openif.OpenIFMixer')
                    % Same error as below
                    error(message('rf:openif:openif:addmixer:WrongNumberOfInputs'))
                end
                newMixer = varargin{1}; 
            elseif nargin == 5
                if ischar(theObj.IFBW)
                    % error('You must specify the IF Bandwdith for this Mixer.')
                    error(message('rf:openif:openif:addmixer:NoIFBWGiven'))
                end
                newMixer = rf.openif.OpenIFMixer(varargin{1}, ...
                       varargin{2},varargin{3},varargin{4},theObj.IFBW);
            elseif nargin == 6
                newMixer = rf.openif.OpenIFMixer(varargin{1}, ...
                       varargin{2},varargin{3},varargin{4},varargin{5});
            else
                % error('The addMixer method requires four inputs: an Intermodulation Table, an RF Center Frequency, an RF Bandwidth, and a character array describing the Mixer Type. A fifth optional input representing the IF Bandwidth is allowed.')
                error(message('rf:openif:openif:addmixer:WrongNumberOfInputs'))
            end
            theObj.Mixers = vertcat(theObj.Mixers,newMixer);
            theObj.validateopenifinputs;
        end
        
        function varargout = show(theObj)
%show Summarize IF planning results in the command window.
%   show(h)
%   Provides a graphical summary of all relevant spurs and spur-free zones
%
%   EXAMPLE:
%       % Set up the object
%       h = OpenIF('IFLocation','MixerOutput');
%
%       % Add two mixers to the system
%       IMT1 = [99 0 21 17 26; 11 0 29 29 63; ...
%               60 48 70 65 41; 90 89 74 68 87; 99 99 95 99 99];
%       addMixer(h,IMT1,2400e6,100e6,'low',50e6)
%
%       IMT2 = [99 0 9 12 15; 20 0 26 31 48; ...
%               55 70 51 70 53; 85 90 60 70 94; 96 95 94 93 92];
%       addMixer(h,IMT2,3700e6,150e6,'high',50e6)
%
%       % Check for spur-free zones
%       show(h)
            if theObj.NumMixers == 0
                % error('To show the graphical IF Planner, you must add at least one Mixer')
                error(message('rf:openif:openif:show:NoMixers'))
            end
            
            hfig = get(0,'CurrentFigure');
            if(isempty(hfig)),
                hfig = figure;
            end
            
            % Obliterate current axis
            cla;
            
            % Constants used for plotting
            splen = 0.015*theObj.SpurFloor; % Height of spurs in graph
            spcols = [1 0 0;0 0 1;1 1 0;1 0 1;0 1 1];
            
            allspurs = theObj.AllSpurs;
            
            % Store Patches for legend
            hpL = zeros(theObj.NumMixers,1);
            
            for spidx = 1:length(allspurs)
                
                x1 = min(allspurs(spidx).FreqRange);
                x2 = max(allspurs(spidx).FreqRange);
                y1 = -1*allspurs(spidx).dBLevel;
                y2 = y1 + splen;
                
                mixidx = find(allspurs(spidx).SourceMixer == theObj.Mixers);
                hp = patch([x1 x1 x2 x2], [y1 y2 y2 y1], ...
                               spcols(1+mod(mixidx-1,size(spcols,1)),:));
                
                hpL(mixidx) = hp;
                
                ud.isspur = 1;
                ud.htext = [];
                ud.whichmix = mixidx;
                ud.RFCF = allspurs(spidx).SourceMixer.RFCF;
                ud.M = allspurs(spidx).Midx;
                ud.N = allspurs(spidx).Nidx;
                % ud.LOrng = allspurs(spidx).LORange;
                ud.FreqRng = allspurs(spidx).FreqRange;
                ud.DB = allspurs(spidx).dBLevel;
                
                set(hp,'UserData',ud);
                set(hp,'ButtonDownFcn',@patchbuttondown);
                
            end
            
            allsfz = theObj.SpurFreeZoneList;
            y1 = -1*theObj.SpurFloor;
            y2 = 0;
            sfzcolor = [0.5 1 0.5];
            
            for sfzidx = 1:length(allsfz)
                
                x1 = min(allsfz(sfzidx).FreqRange);
                x2 = max(allsfz(sfzidx).FreqRange);
                
                hp = patch([x1 x1 x2 x2],[y1 y2 y2 y1],sfzcolor);
                
                ud.isspur = 0;
                ud.htext = [];
                ud.FreqRng = allsfz(sfzidx).FreqRange;
                ud.DB = allsfz(sfzidx).dBLevel;
                
                set(hp,'UserData',ud);
                set(hp,'ButtonDownFcn',@patchbuttondown);
                
            end
            
            minFreq = Inf;
            legendtext = cell(theObj.NumMixers,1);
            for nn = 1:theObj.NumMixers
                % Find smallest Freq of interest
                minFreq = min(theObj.Mixers(nn).RFCF - 0.5*theObj.Mixers(nn).RFBW,minFreq);
                % Create text for legend
                legendtext{nn} = sprintf('Mixer %d',nn);
            end
            
            axis([0,minFreq,y1,y2]);
            xlabel('IF Center Frequencies (Hz)');
            ylabel('Spurious Regions (dBc)');
            title('OpenIF Spur Graph')
            
            legend(hpL,legendtext);
            
            grid on
            
            if nargout
                varargout{1} = hfig;
            end
            
        end
    end
    
end

% Supporting callback functions
function patchbuttondown(src,~)

    ud = get(src,'UserData');

    if isempty(ud.htext)
        cp = get(gca,'CurrentPoint');
        
        textstring = openifcreatetextstring(ud);

        ud.htext = text(cp(1,1),cp(1,2),textstring);

        set(ud.htext,'UserData',src);
        set(ud.htext,'ButtonDownFcn',@textbuttondown);
        set(ud.htext,'BackgroundColor',[1 1 1])
        set(ud.htext,'EdgeColor',[0 0 0])
    else
        delete(ud.htext);
        ud.htext = [];
    end
    
    set(src,'UserData',ud);

end

function textbuttondown(src,~)

    hp = get(src,'UserData');
    ud = get(hp,'UserData');
    
    delete(ud.htext);
    ud.htext = [];
    
    set(hp,'UserData',ud);
end

function textstring = openifcreatetextstring(ud)

    if ud.isspur % For Spur
        textstring = cell(5,1);
        textstring{1} = sprintf('Mixer %d',ud.whichmix);
        [y1,~,u1] = engunits(ud.RFCF);
        textstring{2} = sprintf('RF Center Freq = %g %sHz',y1,u1);
        textstring{3} = sprintf('M = %d, N = %d',ud.M,ud.N);
        textstring{4} = sprintf('Spur Level = %g dBc',ud.DB);
        [y1,~,u1] = engunits(min(ud.FreqRng));
        [y2,~,u2] = engunits(max(ud.FreqRng));
        textstring{5} = sprintf('Freq Range: %g %sHz - %g %sHz',y1,u1,y2,u2);
    else % For SFZ
        textstring = cell(3,1);
        textstring{1} = 'Spur Free Center Frequencies:';
        [y1,~,u1] = engunits(min(ud.FreqRng));
        [y2,~,u2] = engunits(max(ud.FreqRng));
        textstring{2} = sprintf('Min IFCF = %g %sHz',y1,u1);
        textstring{3} = sprintf('Max IFCF = %g %sHz',y2,u2);
    end

end