function [freq,output] = FxPlotFFT(input,fs)
N=length(input); %get the number of points
k=0:N-1;     %create a vector from 0 to N-1
T=N/fs;      %get the frequency interval
freq=k/T;    %create the frequency range
X=fft(input)/N*2; % normalize the data

%only want the first half of the FFT, since it is redundant
cutOff = ceil(N);

%take only the first half of the spectrum
X = X(1:cutOff);
freq = freq(1:cutOff);

% figure;
% subplot(1,2,1);
% plot(T,input)
% subplot(1,2,2);
stem(freq,abs(X));
xlabel('Freq (Hz)')
ylabel('Amplitude')
% title('Using the positiveFFT function')
grid on

output = X;
