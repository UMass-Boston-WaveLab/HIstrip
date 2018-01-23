function data = getdata(h)
%GETDATA Get the data.
%   DATA = GETDATA(H) gets the RFDATA property of the RFCKT object.
%
%   See also RFCKT

%   Copyright 2003-2009 The MathWorks, Inc.

% Get the result
data =  get(h, 'AnalyzedResult');
if(isempty(data))
    cktname = get(h, 'Name');
    error(message('rf:rfckt:rfckt:getdata:NoData', cktname));
end