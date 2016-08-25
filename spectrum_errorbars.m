function [l,u] = spectra_errorbars(m,signal)

%error bars for 95% confidence intervals for spectral density plots
% m is the length of the blocks. Signal is the signal that was spectrized
% returns l and u, lower and upper levels of error bars

% Calculate confidence limits
chitab= [2 0.05064 7.378;         %for 2 degrees of freedom
    4 0.8312 12.83;
    6 1.237 14.45;          %for 6 degrees of freedom
    8 2.180 17.53;
    10 3.247 20.48;
    12 4.404 23.34;
    14 5.629 26.12;
    16 6.908 28.85;
    18 8.231 31.53;
    20 9.591 34.17;
    22 10.98 36.78;
    24 12.40 39.36;
    26 13.84 41.92;
    28 15.31 44.46;
    30 16.79 46.98;
    40 24.43 59.34;
    50 32.36 71.42;
    60 40.48 83.30;
    70 48.76 90.53;
    80 57.15 106.63;
    90 65.65 118.14;
    100 74.22 129.56];

% Plot error bars
% On a log plot you should only have to plot 1 line, since it represents
% a ratio of estimated power(f) to true power(f). A log of a ratio represents
% the difference, so it will be independent of frequency.

l = ones(size(1:(m/2+1)));
u = ones(size(1:(m/2+1)));
N = length(signal);
block = 2*fix(N/m);

chi = interp1(chitab(:,1),chitab(:,2:3),block); %replace with interp1q
l = l .* chi(1);
u = u .* chi(2);

