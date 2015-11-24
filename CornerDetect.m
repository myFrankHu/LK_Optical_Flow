%Function CornerDetect
% This function detect corner points in input image
% Author:   Zhongze Hu
% Email:    myfrankhu@foxmail.com
% Created:  11/1/2015
% Modified: 11/2/2015 

function [e corners] = CornerDetect(image,nCorners,smoothSTD,windowSize)
    corners = zeros(nCorners,2);
    dx = [-1 0 1;-1 0 1;-1 0 1]; 
    Ix2 = imfilter(image,dx,'replicate','same').^2;   
    Iy2 = imfilter(image,dx','replicate','same').^2;                                         
    Ixy = imfilter(image,dx,'replicate','same').*imfilter(image,dx','replicate','same');
    G=fspecial('gaussian',[windowSize,windowSize],smoothSTD);
    Ix2=filter2(G,Ix2);
    Iy2=filter2(G,Iy2);
    Ixy=filter2(G,Ixy);
    [r,c] = size(image);
    e = zeros(r,c);    
    for i = 3:r-2
        for j = 3:c-2
            C = [sum(sum(Ix2(i-2:i+2,j-2:j+2))),sum(sum(Ixy(i-2:i+2,j-2:j+2)));...
                sum(sum(Ixy(i-2:i+2,j-2:j+2))),sum(sum(Iy2(i-2:i+2,j-2:j+2)))];
            [~,S,~] = svd(C);
            e(i,j) = min(S(1,1),S(2,2));
        end
    end
    cnt = 1;
    e_sort = sort(e(:),'descend');
    idx = 1;
    neibor_size = 7;
    while(cnt<nCorners+1)
       [y,x] = find(e == e_sort(idx));
        neibor = e(max(y-neibor_size,1):min(y+neibor_size,size(e,1)),max(x-neibor_size,1):min(x+neibor_size,size(e,2)));
        if(isLocalMaximum(neibor,e(y,x)) == 1)
           corners(cnt,:) = [x,y];
           cnt = cnt + 1;
        end
        idx = idx + 1;
    end
end