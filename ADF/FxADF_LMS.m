function [e,w] = FxADF_LMS(N,x,d,delta)
% Least Mean Squares
% [e,w]=FxADF_LMS(N,x,d,delta);
%
% Input arguments:
% M = filter length, dim 1x1
% u = input signal, dim Nx1
% d = desired signal, dim Nx1
% delta = gradient step
%
% Output arguments:
% e = a priori estimation error, dim Nx1
% w = final filter coefficients, dim Mx1

M = length(x);
y = zeros(1,M);
e = zeros(1,M);
w = zeros(1,N);

for n = N:M
    x1 = x(n:-1:n-N+1);
    y = w*x1';
    e(n) = d(n) - y;
    w = w + delta*e(n)*x1;
end

% index = (1:length(x)) - 1;
% figure; plot(index, x, 'r', index, d, 'k-->', index, e, 'b:.'); grid on;
