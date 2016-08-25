function [fm,pxx,upbar,lowbar] = spectrum_dc(signal,time,m,color);

%function [fm,Pxx,upbar,lowbar] = spectrum_dc(signal,time,m,color);
%calculates spectrum and plots in loglog
%calls the function error_bars.m to calculate error bars and plot them.
%m = length of block average for calculating spectrum (power of 2) 

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
         
pxx = pwelch(signal,m); %Power Spectral Density estimate via Welch's method.
[low,up] = spectrum_errorbars(m,signal); %calculate errorbars for 95% confidence interval 

a = pxx(length(fm)-20); %choose value near end of spectrum to displays errorbars from

lowbar = a.*low;
upbar = a.*up;

%example plot
% loglog(fm,pxx,'color',color)
% 
% hold on
% 
% a = pxx(length(fm)-20); %choose value near end of spectrum to displays errorbars from
% 
% lowbar = a.*low;     
% upbar = a.*up;
% 
% lengthEB = 1:10; %length of error bar along x-axis
% 
% loglog(fm(lengthEB),upbar(lengthEB),'color',color);
% loglog(fm(lengthEB),lowbar(lengthEB),'color',color);
% 
% axis('auto');
% axis('square');
% 
