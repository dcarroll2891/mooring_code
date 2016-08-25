function [fm,cxy,phase,cr] = coherence_squared_dc(signal1,signal2,time);

%function [fm,Cxy,Cr] = coherence_squared_dc(signal1,signal2,time,m,color);
%fm = frequency, cxy = coherence squared, cr = 95% significance level
%calculates coherence between two signals

%define sampling period, frequency, and Nyquist frequency

dt = nanmean(diff(time)); %in days
fcpd = 1/dt; %sampling frequency, in cpd
fc = 1 / (2*dt); %Nyquist frequency in cpd

m = 1024; %window must be an even power of two, this will be the length of the
%windowed time series. Make sure the length is enough for a decent
%average.

%m = 16384; %2^14
%m = 8192; %2^13
%m = 4096; %2^12;
%m = 1024; %2^10

%define the frequency vector from 0 to Nyquist freq.
%The length of fm is m/2, as 1/2 of fft for real-valued signal is
%redundant)

fm = fc .* (0:m/2) ./ (m/2);

cxy = mscohere(signal1,signal2,m); %coherence squared
pxy = cpsd(signal1,signal2,m); %cross spectrum for phase

phase = angle(pxy).*(180/pi);  %phase between signal1 and signal2
%remember that the phase angle of a complex vector (in this case Pxy) is
%arctan (Imag( )./Real(  ))

%calculate the 95% confidence level of significance
nd = 2.*fix(length(signal1)/m); %use fix for the lower estimate
cr = cohercritlevel(nd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function Cr=cohercritlevel(nd)
        %function [Cr,h]=cohercritlevel(nd)
        % from Brian Emery, 2003.
        % Computes 95%level of significance for cxy
        % Based on F distribution tabulated in Bendat
        % and Piersol page 526. 
        
        % Define n1, n2, and get F from pg 526
        N1=2;
        n2=[1:14 16:2:30 40:10:60 80 100 200 500];
        f=[200 19 9.55 6.94 5.79 5.14 4.74 4.46 4.26 4.1 3.98 3.89 3.81 3.74 3.63 3.55 3.49 ...
            3.44 3.40 3.37 3.34 3.32 3.23 3.18 3.15 3.11 3.09 3.04 3.01];
        % do a table lookup for nd (this looks up by linear interpolation which is
        % not perfectly exact.
        
        F=interp1(n2,f,nd);
        Cr=F/((nd-2/N1)+F);
    end

end