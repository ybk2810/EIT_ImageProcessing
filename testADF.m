% filter coefficients
% h=0.5.^[0:4]';

% generate signal
t = 0:0.001:3
d = sin(2*pi*t);
x = d + 0.01*randn(size(d));
% d = 0.1*randn(size(d));

% d = filtfilt(h,1,x);
figure;
plot(x); hold on;
plot(d,'r');
legend('S + n','S');

N = 10;
%%
% LMS
delta = 1e-3;
[xi,w]=FxADF_LMS(N,x,d,delta);
x_filt = filtfilt(w,1,x);

subplot(121);
plot(x); hold on;
plot(x_filt,'r');
plot(xi,'k'); hold off;
legend('input','output','error');
title('LMS');

% LMS
delta = 1e-3;
[xi,w]=FxADF_NLMS(N,x,d,delta);
x_filt = filtfilt(w,1,x);

subplot(121);
plot(x); hold on;
plot(x_filt,'r');
plot(xi,'k'); hold off;
legend('input','output','error');
title('LMS');

% RLS
delta = 1e-7;
[xi,w]=FxADF_RLS(1,N,x,d,delta);
x_filt = filtfilt(w,1,x);

subplot(122);
plot(x); hold on;
plot(x_filt,'r');
plot(xi,'k'); hold off;
legend('input','output','error');
title('RLS');