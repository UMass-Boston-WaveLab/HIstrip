function [Z_in, S11] = Zin2D( Zin_R,Zin_L, N, f )

%calculate Zin of 2D

% N number of connection between left and right

% f is Frequency

%Input ZL N*N*f matrix

%Input ZR N*N*f matrix

Z=Zin_L+Zin_R;

for ii = 1:length(f)

 A = Z([2:N],[2:N],ii);
 b = -Z([2:N],1,ii);
 x = A\b;
 b = -Z([2:N],1,ii);
 x = A\b;
Z_in(ii) = Z(1,1,ii) - b.'*x;
 end
 S11 = 20*log10(abs((Z_in-50)./(Z_in+50)));
    
end