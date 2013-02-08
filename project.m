clear;
clc;

% Step #1: Edge Detection
% Use canny edge detection, line structuring element to dilate the edges,
% and a line hough transform to detect edges of the board.
% Rev. #1: Only tested (and works) for 'supereasy.jpg' which represents 
% the image of a board we will use.
angle = 0; % any angle to rotate board for testing
% img = imread('image/supereasywithbluedot.jpg');
img = imread('image/easy_pieces1.jpg');
img = imresize(img, 0.5,'bilinear');
% img = imrotate(img, angle);


% imtool(img);

bw = im2bw(img); 
bwedge = edge(bw,'canny');

se = strel('line',20,mod(angle+45,360)); % angle+45 for line structuring element
bwedge = imclose(imdilate(bwedge,se),se);
[H,theta,rho]=hough(bwedge);
P = houghpeaks(H,22); % 18 lines from a chess board + 4 for outside
lines = houghlines(bwedge,theta,rho,P);
% plotLines(img,lines)

 
lines = removeSimilarLines(lines);
% plotLines(img,lines);

% imtool(img);
 
corners = getCorners(img,lines);
[img,corners] = recoverParrallelLines(img,corners);

imtool(img);