function corners = getCorners(img,lines)
    

    distanceThreshold = 1;
    nLines =  length(lines);
    [bottomLeftCorner, bottomRightCorner] = getBottomCorners(img);
    
    distancesFromBL = arrayfun(@(c)(distanceFromPointToLine(bottomLeftCorner,c)),lines);
    distancesFromBR = arrayfun(@(c)(distanceFromPointToLine(bottomRightCorner,c)),lines);
    
    blLines = lines(distancesFromBL<distanceThreshold);
    brLines = lines(distancesFromBR<distanceThreshold);
    
    % Checks which is the bottom line
    a = isSameLine(blLines(1),brLines(1));
    b = isSameLine(blLines(1),brLines(2));
    c = isSameLine(blLines(2),brLines(1));
    d = isSameLine(blLines(2),brLines(2));
    
    lineMatrix = [blLines; brLines];
    equalityMatrix = [a b; c d];
    
    bottomLine = lineMatrix(equalityMatrix);
    rightLine = brLines((1-sum(equalityMatrix))==1);
    leftLine = blLines((1-sum(equalityMatrix,2))==1);
    
    % Finds the mid angles (in radians)
    
    ThetaL = (leftLine.theta+bottomLine.theta)*pi/360;
    p1 = bottomLeftCorner+size(img,1)*[cos(ThetaL) sin(ThetaL)];
    
    while(p1(1)>size(img,1) || p1(2)>size(img,2) || p1(1)<0 || p1(2)<0)
        ThetaL = ThetaL+pi/2;
        p1 = bottomLeftCorner+size(img,1)*[cos(ThetaL) sin(ThetaL)];
    end
    
    bl2trLine = [bottomLeftCorner; p1];
    
    ThetaR = (rightLine.theta+bottomLine.theta)*pi/360;
    p1 = bottomRightCorner+size(img,1)*[cos(ThetaR) sin(ThetaR)];
    
    while(p1(1)>size(img,1) || p1(2)>size(img,2) || p1(1)<0 || p1(2)<0)
        ThetaR = ThetaR+pi/2;
        p1 = bottomRightCorner+size(img,1)*[cos(ThetaR) sin(ThetaR)];
    end
    
    br2tlLine = [bottomRightCorner; p1];
    
     
    
    % Find intersections
    topLeftCorner = findLineIntersection([leftLine.point1;leftLine.point2],br2tlLine);
    topRightCorner = findLineIntersection([rightLine.point1;rightLine.point2],bl2trLine);
    
    corners = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
    
    plotFoundLines(img,corners); 
    
    
end

function isit = isSameLine(line1,line2)
    
    isit = line1.rho==line2.rho && line1.theta==line2.theta;
    
end

function dist = getDistance(point1, point2)
    dist = sqrt(sum((point1 - point2) .^ 2));
end

function d = distanceFromPointToLine(point, line)

    p  = [point 0];
    l1 = [line.point1 0];
    l2 = [line.point2 0];
    
    d = abs(cross(l2-l1,p-l1))/abs(l2-21);

end

function [leftcentroid, rightcentroid]=getBottomCorners(img)

    hsvImg = rgb2hsv(img);
    leftmask = hsvImg(:,:,1)>0.35 & hsvImg(:,:,1)<0.40 & hsvImg(:,:,2)>0.5;
    rightmask = hsvImg(:,:,1)>0.95 & hsvImg(:,:,1)<1.00;
    
    leftcentroid = getCorner(leftmask);
    rightcentroid = getCorner(rightmask);


end

function corner = getCorner(mask)

    mask = imerode(mask,ones(7));
    center = regionprops(mask,'centroid');
    
    corner(1) = center(1).Centroid(1);
    corner(2) = center(1).Centroid(2);
end

function point=findLineIntersection(line1, line2)
    
    x0 = line1(1,1);
    y0 = line1(1,2);
    x1 = line1(2,1);
    y1 = line1(2,2);
    
    
    x2 = line2(1,1);
    y2 = line2(1,2);
    x3 = line2(2,1);
    y3 = line2(2,2);
    
    a = (y1-y0)/(x1-x0);
    b = (y3-y2)/(x3-x2);
    
    
    point(1) = (a*x0-b*x2-(y0-y2))/(a-b);
    
    
    point(2) = y0+a*(point(1)-x0);
    
end 


function plotFoundLines(img,corners)

   
    figure, imshow(img), hold on;
   
    lines(:,:,1) = [corners(1,:); corners(2,:)];
    lines(:,:,2) = [corners(1,:); corners(3,:)];
    lines(:,:,3) = [corners(1,:); corners(4,:)];
    lines(:,:,4) = [corners(3,:); corners(2,:)];
    lines(:,:,5) = [corners(3,:); corners(4,:)];
    lines(:,:,6) = [corners(2,:); corners(4,:)];
   
    
    figure, imshow(img), hold on;
    for i=1:6
        line =lines(:,:,i);
        plot(line(:,1),line(:,2),'LineWidth',3,'Color','green');
        % Plot beginnings and ends of lines
        plot(line(1,1),line(1,2),'x','LineWidth',2,'Color','yellow');
        plot(line(2,1),line(2,2),'x','LineWidth',2,'Color','red');   
    end

end
