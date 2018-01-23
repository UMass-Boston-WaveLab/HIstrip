% Intermediate Frequency Planner
% (R2017a) 16-Feb-2017
%
%   OpenIF - A MATLAB object which calculates spur free intermediate
%   frequencies (IF).  After specifying IF characteristics, RF
%   characteristics, and an intermodulation table for each RF, the OpenIF
%   object will calculate which IFs are free of spurs (if any).
%
%     Properties
%       IFLocation  - Can be set to 'MixerInput' or 'MixerOutput' (default)
%       SpurFloor   - OpenIF will only consider spurs above this value
%       Mixers      - Objects that hold mixer and RF information
%       NumMixers   - Number of mixers
%       IFBW        - The optional system-wide IF bandwidth
%
%     Methods
%       addMixer            - Add mixer and RF information to the object
%       getSpurData         - Returns information about the mixer spurs
%       getSpurFreeZoneData - Returns information about spur free zones
%       report              - Display an overall textual summary
%       show                - Display a graphical summary
%
%   See also RF, RFDEMOS

% Copyright 2011-2017 The MathWorks, Inc.
