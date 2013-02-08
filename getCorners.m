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
    ThetaR = (rightLine.theta+bottomLine.theta)*pi/360;
    
    % Find crossing lines
    p1 = bottomLeftCorner+10000*[cos(ThetaL) sin(ThetaL)];
    bl2trLine = [bottomLeftCorner; p1];
    
    p2 = bottomRightCorner+10000*[cos(ThetaR) sin(ThetaR)];
    br2tlLine = [bottomRightCorner; p2];
    
    % Find intersections
    topLeftCorner = findLineIntersection([leftLine.point1;leftLine.point2],br2tlLine);
    topRightCorner = findLineIntersection([rightLine.point1;rightLine.point2],bl2trLine);
    
    corners = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
    
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
