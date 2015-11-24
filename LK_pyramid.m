%Function LK_pyramid
% This function calculates LK pyramidal optical flow from two
% input image I1 and I2.
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/19/2015
% Modified: 11/22/2015 

function [u,v] = LK_pyramid(I1,I2,P_level,N_iter,windowSize,tau)
    % Normalize images to 0-1
    I1 = (I1 - min(I1(:)))./(max(I1(:))-min(I1(:)));
    I2 = (I2 - min(I2(:)))./(max(I2(:))-min(I2(:)));
    w = (windowSize-1)/2;
    
    % get the pyramidal representation of input images I1 and I2
    [Ia Ib] = pyramidInit(I1,I2,P_level);
    
    u = zeros(size(Ia{P_level}));
    v = u;
    for l = P_level:-1:1
        fprintf('Pyramid level: %d\n',l);
        I1 = expandBorder(Ia{l},w);
        for iter = 1:N_iter
            fprintf('\tIteration %d\n',iter);
            I2 = expandBorder(Ib{l},w);
            us = expandBorder(u,w);
            vs = expandBorder(v,w);
            I2 = imShift(us,vs,I2);
            [ut vt] = opticalFlow(I1,I2,windowSize,tau);
            u = u + ut(w+1:size(ut,1)-w,w+1:size(ut,2)-w);
            v = v + vt(w+1:size(vt,1)-w,w+1:size(vt,2)-w);
        end
        if(l > 1)
            u = imresize(2.*u,size(Ia{l-1}),'bilinear');
            v = imresize(2.*v,size(Ia{l-1}),'bilinear');
        end
    end
end