%Function CornerDetect
% This function judges if a point is local maximum in 
% given neibor box
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/2/2015
% Modified: 11/3/2015 

function m = isLocalMaximum(neibor,val)
    if(val == max(neibor(:)))
        m = 1; 
    else
        m = 0;
    end
end