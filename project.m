clear;
clc;

% Step #1: Edge Detection
% Use canny edge detection, line structuring element to dilate the edges,
% and a line hough transform to detect edges of the board.
% Rev. #1: Only tested (and works) for 'supereasy.jpg' which represents 
% the image of a board we will use.
angle = 80; % any angle to rotate board for testing
% img = imread('supereasy.jpg');
img = imread('supereasywithbluedot.jpg');
img = imrotate(img, angle);


[bottomLeftCorner, bottomRightCorner] = getBottomCorners(img);
% imtool(img);

bw = im2bw(img); 
bwedge = edge(bw,'canny');
% imshow(bwedge);


se = strel('line',20,mod(angle+45,360)); % angle+45 for line structuring element
bwedge = imdilate(bwedge,se);
[H,theta,rho]=hough(bwedge);
P = houghpeaks(H,22); % 18 lines from a chess board + 4 for outside
lines = houghlines(bwedge,theta,rho,P);
figure, imshow(img), hold on

nLines =  length(lines);

distanceThreshold = 25;


for k=1:nLines
    point1 = lines(k).point1;
    point2 = lines(k).point2;
    point1distL = sqrt(sum((point1 - bottomLeftCorner) .^ 2));
    point1distR = sqrt(sum((point1 - bottomRightCorner) .^ 2));
    point2distL = sqrt(sum((point2 - bottomLeftCorner) .^ 2));
    point2distR = sqrt(sum((point2 - bottomRightCorner) .^ 2));
   
    if(point1distL < distanceThreshold && point2distR > distanceThreshold)
        topLeftCorner = point2;
    elseif(point1distR < distanceThreshold && point2distL > distanceThreshold)
        topRightCorner = point2; 
    elseif(point2distL < distanceThreshold && point1distR > distanceThreshold)
        topLeftCorner = point1;
    elseif(point2distR < distanceThreshold && point1distL > distanceThreshold)
        topRightCorner = point1;
    end
end

points = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
for k = 1:nLines
    
    xy = [lines(k).point1; lines(k).point2];
    disp(' '); 
    
    plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

img = recoverParrallelLines(img,points);

imtool(img);