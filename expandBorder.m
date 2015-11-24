%Function expandBorder
% This function expand image border in replicate manner
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/21/2015
% Modified: 11/22/2015 

function  Iout  = expandBorder( I, bordSize )

    Iout = zeros(size(I)+2*bordSize);
    Iout(bordSize+1:size(I,1)+bordSize, bordSize+1:size(I,2)+bordSize) = I;
    Iout(bordSize+1:size(Iout,1)-bordSize,1:bordSize) = repmat(I(1:size(I,1),1),1,bordSize);
    Iout(bordSize+1:size(Iout,1)-bordSize,size(Iout,2)-bordSize+1:size(Iout,2)) = ...
        repmat(I(1:size(I,1),size(I,2)),1,bordSize);
    Iout(1:bordSize,:) = repmat(Iout(bordSize+1,:),bordSize,1);
    Iout(size(Iout,1)-bordSize+1:size(Iout,1),:) = repmat(Iout(size(I,1)+bordSize,:),bordSize,1);

end
