function [leftcentroid, rightcentroid]=getBottomCorners(img);

hsvImg = rgb2hsv(img);


leftmask = hsvImg(:,:,1)>0.5 & hsvImg(:,:,1)<0.6;
rightmask = hsvImg(:,:,1)>0.1 & hsvImg(:,:,1)<0.2;


leftmask = imerode(leftmask,ones(3));
rightmask = imerode(rightmask,ones(5));
imtool(rightmask);

leftcircle = bwlabel(leftmask);
rightcircle = bwlabel(rightmask);

leftcenter = regionprops(leftcircle,'centroid');
rightcenter = regionprops(rightcircle,'centroid');

leftcentroid(1) = leftcenter(1).Centroid(1);
leftcentroid(2) = leftcenter(1).Centroid(2);

rightcenter

rightcentroid(1) = rightcenter(1).Centroid(1);
rightcentroid(2) = rightcenter(1).Centroid(2);
