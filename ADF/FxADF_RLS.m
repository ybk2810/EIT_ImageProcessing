function [e,w]=FxADF_RLS(lambda,N,x,d,delta)
% Recursive Least Squares
% [e,w]=FxADF_RLS(lambda,N,x,d,delta);
%
% Input arguments:
% lambda = forgetting factor, dim 1x1
% M = filter length, dim 1x1
% u = input signal, dim Nx1
% d = desired signal, dim Nx1
% delta = initial value, P(0)=delta^-1*I, dim 1x1
%
% Output arguments:
% e = a priori estimation error, dim Nx1
% w = final filter coefficients, dim Mx1
% inital values
w=zeros(N,1);
P=eye(N)/delta;
% make sure that u and d are column vectors
x=x(:);
d=d(:);
% input signal length
M=length(x);
% error vector
e=d;
% Loop, RLS
for n=N:M
    uvec=x(n:-1:n-N+1);
    k=lambda^(-1)*P*uvec/(1+lambda^(-1)*uvec'*P*uvec);
    e(n)=d(n)-w'*uvec;
    w=w+k*conj(e(n));
    P=lambda^(-1)*P-lambda^(-1)*k*uvec'*P;
end
