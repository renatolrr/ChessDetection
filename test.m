img = imread('easy.jpg');
imshow(img);
corners = corner(rgb2gray(img));
hold on
miny = min(corners(:,1));
maxy = max(corners(:,1));
minx = min(corners(:,2));
maxx = max(corners(:,2));

plot(miny, minx, 'r*', 'color', 'green');
plot(miny, maxx, 'r*', 'color', 'green');
plot(maxy, minx, 'r*', 'color', 'green');
plot(maxy, maxx, 'r*', 'color', 'green');

img = img(minx:maxx, miny:maxy, :);

clear minx maxx miny maxy corners;


