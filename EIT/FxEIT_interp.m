function [ sigma2 ] = FxEIT_interp( sigma, int_num, w )
% k = ones(1, w) / w;
for cntTri = 1:size(sigma,1)
    sigma2(cntTri,:) = interp1(1:size(sigma,2),sigma(cntTri,:),1:1/(int_num):size(sigma,2),'spline'); % spline ³»»ð(º¸°£¹ý)
%     sigma2(cntTri,:) = conv(sigma2(cntTri,:),k,'same');
end
end

