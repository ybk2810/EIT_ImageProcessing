function [ X,a ] = FxEIT_FFT( data, Fs, a )
if nargin == 2
    figure(66); plot(sum(data,1));

    xlabel('scan num'); %ylabel('Magnitude'); title('Voltage raw data');
    zoom on; pause();
    [a, ~] = ginput(2);
end
    temp = data(:,round(a(1)):round(a(2)));

% temp = data(:,round(a(1)):round(a(1))+50*60*5);

temp = sum(temp,1);
x = temp;
N=length(x); %get the number of points
k=0:N-1;     %create a vector from 0 to N-1
T=N/Fs;      %get the frequency interval
freq=k/T;    %create the frequency range
X=fft(x)/N*2; % normalize the data

%only want the first half of the FFT, since it is redundant
cutOff = ceil(N);

%take only the first half of the spectrum
X = X(1:cutOff);
freq = freq(1:cutOff);

set(figure(66), 'Position', [550 300 500 200]);
stem(freq,abs(X),'r'); xlabel('Freq (Hz)');ylabel('Amplitude');

set(gca,'xlim',([0 Fs/2]));
max_value = max(abs(X(5:end)));
axis([0 Fs/2 0 max_value]);
% axis([0 1 0 200000]);
grid on;

end
