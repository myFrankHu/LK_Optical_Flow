%% load data
Synth1 = imread('synth\synth_000.png');
Synth2 = imread('synth\synth_001.png');
Sphere1 = rgb2gray(imread('sphere\sphere.0.png'));
Sphere2 = rgb2gray(imread('sphere\sphere.1.png'));
Corridor1 = imread('corridor\bt.000.png');
Corridor2 = imread('corridor\bt.001.png');

%% 1. Dense Optical Flow
figure;
I1 = double(Synth1);
I2 = double(Synth2);
[u,v,hitMap] = opticalFlow(I1,I2,3,0.01);
[x,y] = meshgrid(1:5:size(I1,1),1:5:size(I1,2));
subplot(2,3,1); quiver(x,y,u(1:5:size(I1,1),1:5:size(I1,2)),v(1:5:size(I1,1),1:5:size(I1,2)));
axis([0,size(I1,2),0,size(I1,1)]);
title('Needlemap, windowsize: 3');
subplot(2,3,4); imagesc(hitMap);
title('Valid area, windowsize: 3');
[u,v,hitMap] = opticalFlow(I1,I2,7,0.01);
subplot(2,3,2); quiver(x,y,u(1:5:size(I1,1),1:5:size(I1,2)),v(1:5:size(I1,1),1:5:size(I1,2)));
axis([0,size(I1,2),0,size(I1,1)]);
title('Needlemap, windowsize: 9');
subplot(2,3,5); imagesc(hitMap);
title('Valid area, windowsize: 9');
[u,v,hitMap] = opticalFlow(I1,I2,29,0.01);
hitMap(1,1) = 0;
subplot(2,3,3); quiver(x,y,u(1:5:size(I1,1),1:5:size(I1,2)),v(1:5:size(I1,1),1:5:size(I1,2)));
axis([0,size(I1,2),0,size(I1,1)]);
title('Needlemap, windowsize: 29');
subplot(2,3,6); imagesc(hitMap);
title('Valid area, windowsize: 29');
%% 2. Sparse Optical Flow
I1 = double(Corridor1);
I2 = double(Corridor2);
[u,v,hitMap] = opticalFlow(I1,I2,99,0.01);
[e corners] = CornerDetect(I1,50,1,7);
figure; 
subplot(1,2,1);
imagesc(I1);colormap(gray);
hold on; plot(corners(:,1),corners(:,2),'ro','markersize',8,'linewidth',2);
title('(a) Result of the corner detection problem on the corridor image.');
subplot(1,2,2);
imagesc(I1);colormap(gray);
hold on; plot(corners(:,1),corners(:,2),'ro','markersize',8,'linewidth',2);
drawArrow = @(x,y,props) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0,props{:});
hold on;
for i = 1:50
    drawArrow([corners(i,1),corners(i,1)+20*u(corners(i,2),corners(i,1))],[corners(i,2),corners(i,2)+20*v(corners(i,2),corners(i,1))],{'MaxHeadSize',10,'color','b','linewidth',2});
end
title('(b) Result of sparse optical ow algorithm on the corridor image.');

%% 3. Coarse to fine
Flower1 = double(rgb2gray(imread('flower\00029.png')));
Flower2 = double(rgb2gray(imread('flower\00030.png')));
I1 = Flower1;
I2 = Flower2;
figure;
[u,v,hitMap] = opticalFlow(double(I1),double(I2),29,0.015);
[y,x] = meshgrid(1:3:size(I1,1),1:3:size(I1,2));
subplot(1,2,1); quiver(x',y',u(1:3:size(I1,1),1:3:size(I1,2)),v(1:3:size(I1,1),1:3:size(I1,2)));
axis([0,size(I1,2),0,size(I1,1)]);
title({'(a) Result of dense optical flow on the flower sequence','windowsize: 29'});
[u,v] = LK_pyramid(I1,I2,3,3,29,0.015);
subplot(1,2,2); quiver(x',y',u(1:3:size(I1,1),1:3:size(I1,2)),v(1:3:size(I1,1),1:3:size(I1,2)));
axis([0,size(I1,2),0,size(I1,1)]);
title({'(a) Result of LK optical flow on the flower sequence','windowsize: 29'});
