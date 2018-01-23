function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.
%
%   See also RFCKT.RLCGLINE

%   Copyright 2003-2007 The MathWorks, Inc.

% Check the properties
freq = get(h, 'Freq');
R = get(h, 'R');
L = get(h, 'L');
C = get(h, 'C');
G = get(h, 'G');
n = length(freq);
m1 = length(R);
m2 = length(L);
m3 = length(C);
m4 = length(G);

rferrhole2 = '';
if ~(((n==1||n==0)&&(m1==1))||(n>1)&&(m1==1||n==m1))
    rferrhole2 = 'R';
end
if ~(((n==1||n==0)&&(m2==1))||(n>1)&&(m2==1||n==m2))
    rferrhole2 = 'L';
end
if ~(((n==1||n==0)&&(m3==1))||(n>1)&&(m3==1||n==m3))
    rferrhole2 = 'C';
end
if ~(((n==1||n==0)&&(m4==1))||(n>1)&&(m4==1||n==m4))
    rferrhole2 = 'G';
end

if ~isempty(rferrhole2)
    rferrhole1 = '';
    if isempty(h.Block)
        rferrhole1 = [h.Name, ': '];
    end
    error(message('rf:rfckt:rlcgline:checkproperty:WrongDataSize',      ...
        rferrhole1, rferrhole2));
end

if n~= 0
    [freq, index] = sort(freq);
    if n==length(R)
        R = R(index);
    end
    if n ==length(L)
        L = L(index);
    end
    if n==length(C)
        C = C(index);
    end
    if n==length(G)
        G = G(index);
    end
end
set(h, 'Freq', freq, 'R', R, 'L', L, 'C', C, 'G', G);

checkstubmode(h);