function [locs_Rwave,RR_interval,ECG_freq,ref] = FxEIT_findRpeak(ECG_data,Fs,th_peak)
% input
%   ECG_data : ECG raw data
%   Fs : ECG sampling rate
%   th_peak(optional) : thresh hold level of ECG peak detection
% output
%   locs_Rwave : R peak location
%   RR_interval : RR interval
%   ECG_freq : fundamental ECG frequncy
%   ref : generate ECG reference signal

% detrend data
ECG_data = ECG_data.^2;
[p,~,mu] = polyfit((1:numel(ECG_data))',ECG_data,6);
f_y = polyval(p,(1:numel(ECG_data))',[],mu);
Detrend_ECG = ECG_data - f_y;        

if nargin < 3
    th_peak = 0.2*std(Detrend_ECG);
end

% find peak
[~,locs_Rwave] = findpeaks(Detrend_ECG,'MinPeakHeight',th_peak,...
    'MinPeakDistance',round(Fs/3));
RR_interval = mean(locs_Rwave(2:end)-locs_Rwave(1:end-1));

% figure; plot(Detrend_ECG);
% hold on; plot(locs_Rwave,Detrend_ECG(locs_Rwave),'rv'); hold off;

% generate rectangle pulse wave
ref = zeros(length(Detrend_ECG),1);
ref(locs_Rwave) = 1;

temp = ref;
for i = 1:round(RR_interval/2)
    temp = temp + circshift(ref,i);
end
ref = temp';

figure; 
plot(Detrend_ECG);
hold on; plot(locs_Rwave,Detrend_ECG(locs_Rwave),'kv');
plot(ref*(max(Detrend_ECG)-min(Detrend_ECG))+min(Detrend_ECG),'r'); hold off;
ECG_freq = length(locs_Rwave)/length(ECG_data)*Fs;
end