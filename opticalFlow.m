%Function opticalFlow
% This function calculates dense optical flow from two input 
% image I1 and I2.
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/19/2015
% Modified: 11/19/2015 

function [u, v, hitMap] = opticalFlow(I1, I2, windowSize, tau)
    I1 = (I1 - min(I1(:)))./(max(I1(:))-min(I1(:)));
    I2 = (I2 - min(I2(:)))./(max(I2(:))-min(I2(:)));
    [H,W] = size(I1);
    hitMap = zeros(size(I1));
    u = zeros(size(I1));
    v = zeros(size(I1));
    w = (windowSize-1)/2;
    dx = [-1 0 1]./2; 
    dy = dx';
    IX = imfilter(I1,dx,'replicate','same');
    IY = imfilter(I1,dy,'replicate','same');
    for i = 1:H
       for j = 1:W 
           Ix = IX(max(1,i-w):min(H,i+w),max(1,j-w):min(W,j+w));
           Iy = IY(max(1,i-w):min(H,i+w),max(1,j-w):min(W,j+w));
           It = I1(max(1,i-w):min(H,i+w),max(1,j-w):min(W,j+w))-I2(max(1,i-w):min(H,i+w),max(1,j-w):min(W,j+w));
           b = [sum(sum(It.*Ix));sum(sum(It.*Iy))];
           G = [sum(sum(Ix.^2)),sum(sum(Ix.*Iy));...
                sum(sum(Ix.*Iy)),sum(sum(Iy.^2))];
           t = G(1,1)+G(2,2);
           d = G(1,1)*G(2,2)-G(1,2)*G(2,1);
           e1 = t/2 + sqrt((t^2)/4-d);
           e2 = t/2 - sqrt((t^2)/4-d);
           if(e2 < tau || e1/e2 > 10)
              continue; 
           end
           hitMap(i,j) = 1;
           flow = G\b;
           u(i,j) = flow(1);
           v(i,j) = flow(2);
       end
    end
end
