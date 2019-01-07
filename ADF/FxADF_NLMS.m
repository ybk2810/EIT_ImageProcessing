function [e,w] = FxADF_NLMS(N,x,d,delta)
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
x = x';
L = length(x);
w = zeros(N,1);
d_hat = zeros(L,1);
e = zeros(L,1);
px = ones(L,1);
p = ones(L,1);
mu_hat = zeros(L,1);
mu_hatx = zeros(L,1);
beta = 0.9;

for n = N:L
    d_hat(n) = w'*x(n:-1:n-(N-1));
    e(n) = d(n) - d_hat(n);
    px(n) = beta*px(n-1) + (1-beta)*x(n:-1:n-(N-1))'*x(n:-1:n-(N-1));
    p(n) = x(n:-1:n-(N-1))'*x(n:-1:n-(N-1));
    mu_hatx(n) =  (1 - beta)/(px(n) + delta);
    mu_hat(n) =  (1 - beta)/(p(n) + delta);
    
    w = w + mu_hatx(n)*e(n).*x(n:-1:n-(N-1));
end
