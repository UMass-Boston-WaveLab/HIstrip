function updateflag(h, index, iflag, nflags)
%UPDATEFLAG Update the Flag.
%   UPDATEFLAG(H, INDEX, IFLAG, NFLAGS) updates the property FLAG.
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

% Check the input
if (index < 1) || (index >= nflags)
    error(message('rf:rfckt:rfckt:updateflag:IndexOutOfRange'));
end
if (iflag ~= 0) && (iflag ~= 1)
    error(message('rf:rfckt:rfckt:updateflag:WrongFlag'));
end

% Set the flag
cflag = get(h, 'Flag');
cflag = bitset(cflag, index, iflag);
set(h, 'Flag', cflag);