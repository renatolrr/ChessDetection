clear;
clc;

% Step #1: Edge Detection
% Use canny edge detection, line structuring element to dilate the edges,
% and a line hough transform to detect edges of the board.
% Rev. #1: Only tested (and works) for 'supereasy.jpg' which represents 
% the image of a board we will use.
angle = 0; % any angle to rotate board for testing
% img = imread('image/supereasywithbluedot.jpg');
img = imread('image/checkers/board8.png');
%img = imresize(img, 1,'bilinear');
%img = imrotate(img, angle);
board  =imread('image/board_empty.png');
colors = [0 0 0;
          190 60 20]; 


imtool(rgb2hsv(img));


lines = findLines(img);

 
lines = removeSimilarLines(lines);
% plotLines(img,lines);

% imtool(img);
 
corners = getCorners(img,lines);
[img,corners] = recoverParrallelLines(img,corners);


pieces = detectPieces(img,board,colors);
% imtool(img);