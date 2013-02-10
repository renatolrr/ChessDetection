function lines = findLines(img)

    bw = im2bw(img); 
    bwedge = edge(bw,'canny');
    se = strel('line',10,mod(45,360)); % angle+45 for line structuring element
    bwedge = imclose(imdilate(bwedge,se),se);
    [H,theta,rho]=hough(bwedge);
    P = houghpeaks(H,22); % 18 lines from a chess board + 4 for outside
    lines = houghlines(bwedge,theta,rho,P);

end