function project(img, turn);
clc;

% Step #1: Edge Detection
% Use canny edge detection, line structuring element to dilate the edges,
% and a line hough transform to detect edges of the board.
% Rev. #1: Only tested (and works) for 'supereasy.jpg' which represents 
% the image of a board we will use.
angle = 0; % any angle to rotate board for testing
% img = imread('image/supereasywithbluedot.jpg');
img = imread(img);
%img = imresize(img, 1,'bilinear');
%img = imrotate(img, angle);

board  = imread('board_empty.png');
board = imrotate(board,90);
% imtool(board);
colors = [0 0 0;
          190 60 20]; 
% imtool(img)

lines = findLines(img);

% plotLines(img, lines);

lines = removeSimilarLines(lines);
plotLines(img,lines);

% imtool(img);
 
corners = getCorners(img,lines);

img= recoverParrallelLines(img,corners);
% imtool(img);

img = imrotate(img, 90);

pieces = detectPieces(img,board,colors);
checkersToFEN(pieces, turn);
system(['Checkerboard/checkerboard.exe ' clipboard('paste')]);
