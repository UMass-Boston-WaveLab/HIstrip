function [seriesChalf, shuntC] = nbyncapABCD(h1, h2, w1, w2, eps1, eps2, gap, N, freq)
%NBYNCAPABCD calculates the nxn generalized abcd matrix for simultaneous
%gaps in multiple parallel microstrip lines (or a gap in multiple
%microstrip-like conductors of a multiconductor transmission line). this
%assumes that there is one line above multiple identical parallel lines, like
%microstrip above an HIS.  as such, only two heights, two width values, and
%two epsilon values are needed.  We assume all the lines except the upper
%line have a gap at the same longitudinal location, and the gaps are all
%the same width. N is the number of non-ground lines (it is an N+1
%conductor MTL, where the +1 is ground).  The name of this function is a
%little incorrect because technically the output ABCD matrix is 2N by 2N.
%it may or may not be necessary to account for a shunt capacitance between
%the top line and the middle layer, as well.  But even if it is, this 
%microstrip gap capacitance model doesn't support it.  And my best guess at
%the value of that capacitance is very small, so that the reactance has
%negligible effect compared with the other capacitances.  That capacitance
%value would also be different for each of the middle-layer lines,
%depending on its distance from the upper line.

[Cgap, Cp] = microstripGapCap2(w2, h2,eps2,gap, freq);

omega = 2*pi*freq;

%can add radiative loss from gap
a1 = 1/(j*omega*Cgap*2+real((harringtonslotY((freq),gap/2,w2))));
b = j*omega*Cp;


%build ABCD matrix for half of series capacitor (since unit cell boundary
%is at center of gap)
A=eye(N);
B=a1*eye(N);
B(1,1)=0; %no capacitor in top line
C=zeros(N);
D=eye(N);

seriesChalf=[A B; C D];

%build shunt capacitance from HIS layer to ground
A=eye(N);
B=zeros(N);
C=b*eye(N);
C(1,1)=0;
D=eye(N);

shuntC=[A B; C D];


end

