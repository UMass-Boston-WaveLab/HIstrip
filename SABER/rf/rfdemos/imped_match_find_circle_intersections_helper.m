function [i1, i2] = imped_match_find_circle_intersections_helper(x1p, r1, x2p, r2)
%IMPED_MATCH_FIND_CIRCLE_INTERSECTIONS_HELPER Find intersections of two circles.
%   IMPED_MATCH_FIND_CIRCLE_INTERSECTIONS_HELPER returns the two
%   intersections, I1 and I2 of two circles with centers located at X1P and
%   X2P and radii R1 and R2. If the two intersections do not exist, NaNs
%   are returned.
%
%   Each of I1, I2, X1P and X2P is a vector of two real numbers. The two
%   numbers are the x and y coordinates of a point in the Cartesian plane.
%
%   IMPED_MATCH_FIND_CIRCLE_INTERSECTIONS_HELPER is a helper function of RF
%   Toolbox demo: Designing Matching Networks (Part 2: Single Stub
%   Transmission Lines).

%   Copyright 2007-2008 The MathWorks, Inc.

x1 = x1p(1);
y1 = x1p(2);
x2 = x2p(1);
y2 = x2p(2);

% Distance between centers
d2 = (x2-x1)^2 + (y2-y1)^2;
d1 = sqrt(d2);
if d1>(r1+r2)
    disp('Circles do not intersect, circle centers to far apart');
    i1 = [NaN NaN];
    i2 = [NaN NaN];
    return
elseif d1<abs(r1-r2)
    disp('Circles do not intersect, larger circle encloses smaller circle');
    i1 = [NaN NaN];
    i2 = [NaN NaN];
    return
elseif x1==x2 && y1==y2
    disp('Circles are identical, infinite number of solutions');
    i1 = [NaN NaN];
    i2 = [NaN NaN];
    return
end

K  = (1/4)*sqrt(((r1+r2)^2-d2)*(d2-(r1-r2)^2));

xp = (1/2)*(x2+x1) + (1/2)*(x2-x1)*(r1^2-r2^2)/d2 + 2*(y2-y1)*K/d2;
yp = (1/2)*(y2+y1) + (1/2)*(y2-y1)*(r1^2-r2^2)/d2 - 2*(x2-x1)*K/d2;
i1 = [xp yp];

if K==0
    disp('Circles have only one point of intersection')
    i2 = [NaN NaN];
    return
end

xm = (1/2)*(x2+x1) + (1/2)*(x2-x1)*(r1^2-r2^2)/d2 - 2*(y2-y1)*K/d2;
ym = (1/2)*(y2+y1) + (1/2)*(y2-y1)*(r1^2-r2^2)/d2 + 2*(x2-x1)*K/d2;
i2 = [xm ym];