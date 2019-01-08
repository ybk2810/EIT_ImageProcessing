function [ref] = FxEIT_mkvref(signal)
if size(signal,1) == 1 || size(signal,2) == 1
    ref = signal
else
    ref = mean(signal);
end
ref = detrend(ref);       % remove trend
[ref,]=remmean(ref);      % remove mean
ref = filtfilt(ones(30,1),1,ref);  % mov avg filt
ref = ref/norm(ref);
ref(ref>0) = 1;
ref(ref<0) = 0;

figure;
plot(signal); hold on;
plot(ref*(max(signal)-min(signal))+min(signal),'r'); hold off;


function [newVectors, meanValue] = remmean(vectors)
%REMMEAN - remove the mean from vectors
%
% [newVectors, meanValue] = remmean(vectors);
%
% Removes the mean of row vectors.
% Returns the new vectors and the mean.
%
% This function is needed by FASTICA and FASTICAG

% @(#)$Id: remmean.m,v 1.2 2003/04/05 14:23:58 jarmo Exp $

newVectors = zeros (size (vectors));
meanValue = mean (vectors')';
newVectors = vectors - meanValue * ones (1,size (vectors, 2));