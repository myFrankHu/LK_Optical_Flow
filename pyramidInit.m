%Function pyramid
% This function init pyramidal representation of
% input images
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/21/2015
% Modified: 11/22/2015 

function [ Ia, Ib ] = pyramidInit( I1, I2, p_level)
    Ia = {I1};
    Ib = {I2};
    if p_level > 1
        for k = 2:p_level
            Ia{k} = impyramid( Ia{k-1}, 'reduce' );
            Ib{k} = impyramid( Ib{k-1}, 'reduce' );
        end
    end
end
