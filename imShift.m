%Function imshift
% This function shift an image with given direction u, v
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/22/2015
% Modified: 11/22/2015 


function Iout = imShift( u, v, I )
    [x y] = meshgrid(1:size(I,2),1:size(I,1));
    Iout = interp2(I, x+u, y+v, 'cubic');
    Iout(isnan(Iout)) = I(isnan(Iout));
end
