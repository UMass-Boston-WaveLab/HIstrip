function [out, freq] = findABCDfromsim(thrufileS11, thrufileS11phase,thrufileS21, thrufileS21phase,testfileS11, testfileS11phase,testfileS21, testfileS21phase)
%uses hobbies simulation results to get ABCD parameters for a 2-port
%"under test."

[~, thruS11] = read_HOB_file(thrufileS11);
[~, thruS11phase] = read_HOB_file(thrufileS11phase);
[~, thruS21] = read_HOB_file(thrufileS21);
[~, thruS21phase] = read_HOB_file(thrufileS21phase);

[~, testS11] = read_HOB_file(testfileS11);
[~, testS11phase] = read_HOB_file(testfileS11phase);
[~, testS21] = read_HOB_file(testfileS21);
[freq, testS21phase] = read_HOB_file(testfileS21phase);

for ii = 1:length(freq)
    thru = getABCDfromS([thruS11(ii)*exp(j*thruS11phase(ii)) thruS21(ii)*exp(j*thruS21phase(ii));...
                         thruS21(ii)*exp(j*thruS21phase(ii)) thruS11(ii)*exp(j*thruS11phase(ii))],50);
    test = getABCDfromS([testS11(ii)*exp(j*testS11phase(ii)) testS21(ii)*exp(j*testS21phase(ii));...
                         testS21(ii)*exp(j*testS21phase(ii)) testS11(ii)*exp(j*testS11phase(ii))],50);
    out(:,:,ii) = (thru^0.5)^-1*test*(thru^0.5)^-1;
end