clear;
clc;

% Step #1: Edge Detection
% Use canny edge detection, line structuring element to dilate the edges,
% and a line hough transform to detect edges of the board.
% Rev. #1: Only tested (and works) for 'supereasy.jpg' which represents 
% the image of a board we will use.
angle = 20; % any angle to rotate board for testing
% img = imread('image/supereasywithbluedot.jpg');
img = imread('image/test.png');
img = imresize(img, 1.0,'bilinear');
img = imrotate(img, angle);


% imtool(img);

bw = im2bw(img); 
bwedge = edge(bw,'canny');

se = strel('line',20,mod(angle+45,360)); % angle+45 for line structuring element
bwedge = imclose(imdilate(bwedge,se),se);
[H,theta,rho]=hough(bwedge);
P = houghpeaks(H,22); % 18 lines from a chess board + 4 for outside
lines = houghlines(bwedge,theta,rho,P);
figure, imshow(img), hold on

nLines =  length(lines);

 for k = 1:nLines
     
     xy = [lines(k).point1; lines(k).point2];
     
     plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');
     % Plot beginnings and ends of lines
     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

     % intersection detection. TODO: could just put this in the
     % findintersects file and concat the intersections
     line1 = [xy(1,1) xy(1,2) xy(2,1) xy(2,2)];
     for o = 1:length(lines)
        if o ~= k
           az =  [lines(o).point1;lines(o).point2];
           line2 = [az(1,1) az(1,2) az(2,1) az(2,2)];
           [interX,interY] = findintersects(line1,line2); % INTERSECTION DETECTION
           if isnan(interX)==0 & size(interX)>0
              plot(interX,interY,'o','Color','blue','LineWidth',4); 
           end
        end
    end
 end

imtool(img);
 
corners = getCorners(img,lines);
[img,corners] = recoverParrallelLines(img,corners);

imtool(img);