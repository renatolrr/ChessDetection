function corners = getCorners(img,lines)
    

    distanceThreshold = 20;
    nLines =  length(lines);
    [bottomLeftCorner, bottomRightCorner] = getBottomCorners(img);
    
    distancesFromBL = arrayfun(@(c)(distanceFromPointToLine(bottomLeftCorner,c)),lines);
    distancesFromBR = arrayfun(@(c)(distanceFromPointToLine(bottomRightCorner,c)),lines);
    blLines = lines(distancesFromBL<distanceThreshold);
    brLines = lines(distancesFromBR<distanceThreshold);
    
    % plotLines(img,brLines);
    % Checks which is the bottom line
    a = isSameLine(blLines(1),brLines(1));
    b = isSameLine(blLines(1),brLines(2));
    c = isSameLine(blLines(2),brLines(1));
    d = isSameLine(blLines(2),brLines(2));
    
    
    equalityMatrix = [a b; c d];
    
    bottomLine = brLines((1-sum(equalityMatrix))==0);
    rightLine = brLines((1-sum(equalityMatrix))==1);
    leftLine = blLines((1-sum(equalityMatrix,2))==1);
    
    
    % plotLines(img,[bottomLine rightLine leftLine]);
    
    % Finds the mid angles (in radians)
    
    figure, imshow(img), hold on;
    
    %================
%     line =[bottomLine.point1;bottomLine.point2];
%     plot(line(:,1),line(:,2),'LineWidth',3,'Color','green');
%     
%     line =[rightLine.point1;rightLine.point2];
%     plot(line(:,1),line(:,2),'LineWidth',3,'Color','green');
%     
%     line =[leftLine.point1;leftLine.point2];
%     plot(line(:,1),line(:,2),'LineWidth',3,'Color','green');
    %================
    
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
   
    %================
%     line =bl2trLine;
%     plot(line(:,1),line(:,2),'--r','LineWidth',3);
%     
%     line =br2tlLine;
%     plot(line(:,1),line(:,2),'--r','LineWidth',3);
    
    %================
     
        
    % Find intersections
    topLeftCorner = findLineIntersection([leftLine.point1;leftLine.point2],br2tlLine);
    topRightCorner = findLineIntersection([rightLine.point1;rightLine.point2],bl2trLine);
    
%     %=========
%     line =[topLeftCorner;topRightCorner];
%     plot(line(:,1),line(:,2),':r','LineWidth',2);
    %================
    
    topLine = findClosestLineTo(lines,[topLeftCorner;topRightCorner]);
    
    
    topLeftCorner = findLineIntersection([topLine.point1; topLine.point2],[leftLine.point1; leftLine.point2]);
    topRightCorner = findLineIntersection([topLine.point1; topLine.point2],[rightLine.point1; rightLine.point2]);
    
    %=======================
%     line =[topLeftCorner;topRightCorner];
%     plot(line(:,1),line(:,2),'--b','LineWidth',3);
%     
%     plot(topLeftCorner(1),topLeftCorner(2),'oy','LineWidth',5);
%     plot(topRightCorner(1),topRightCorner(2),'oy','LineWidth',5);
    %========================
    
    corners = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
    
    
    % plotFoundLines(img,corners); 
    
    
end

function isit = isSameLine(line1,line2)
    
    isit = line1.rho==line2.rho && line1.theta==line2.theta;
    
end

function d = distanceFromPointToLine(point, line)

    p  = [point 0];
    l1 = [line.point1 0];
    l2 = [line.point2 0];
    
    d = norm(cross(l2-l1,p-l1),2)/norm(l2-l1,2);

end

function d = distanceFromPointToLine2(point, linePoints)

    p  = [point 0];
    l1 = [linePoints(1,:) 0];
    l2 = [linePoints(2,:) 0];
    
    d = norm(cross(l2-l1,p-l1),2)/norm(l2-l1,2);

end



function closest_line = findClosestLineTo(lineVector, line)
    
    epsilonRho = 55;
    epsilonTheta = 14;
    
    rho = distanceFromPointToLine2([0 0],line);
    theta = tan((line(4)-line(2))/(line(3)-line(1)))*180/pi;
    
    i=1;
    
    while abs(lineVector(i).rho-rho)>epsilonRho || abs(lineVector(i).theta-theta)>epsilonTheta
        i=i+1;
    end
    
    lineVector(i).rho
    lineVector(i).theta
    
    closest_line = lineVector(i);
end


function [leftcentroid, rightcentroid]=getBottomCorners(img)

    hsvImg = rgb2hsv(img);
    leftmask = hsvImg(:,:,1)>0.45 & hsvImg(:,:,1)<0.55 & hsvImg(:,:,2)>0.5;
    rightmask = hsvImg(:,:,1)>0.65 & hsvImg(:,:,1)<0.75 & hsvImg(:,:,2) < 0.2 & hsvImg(:,:,3)>0.55 & hsvImg(:,:,3)<0.65;
    
    leftcentroid = getCorner(leftmask);
    rightcentroid = getCorner(rightmask);
    
end

function corner = getCorner(mask)

    mask = bwlabel(mask);
    pmask = mask;
    while(size(unique(mask(mask > 0)),1) > 1)
        mask = imerode(mask,ones(3));
        if(size(unique(mask(mask > 0)),1) == 0)
            mask = pmask; break;
        end
    end
    mask =im2bw(mask);
    
    mask = imdilate(mask,ones(5));
    
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
    
    if(x1==x0) 
        x1=x0+1;
    end
    
    if(x3==x2) 
        x3=x2+1;
    end
    a = (y1-y0)/(x1-x0);
    
    b = (y3-y2)/(x3-x2);
    
    point(1) = (a*x0-b*x2-(y0-y2))/(a-b);
    
    
    point(2) = y0+a*(point(1)-x0);
    
    
end 


function plotFoundLines(img,corners)

   
    figure, imshow(img), hold on;
   
    lines(:,:,1) = [corners(1,:); corners(2,:)];
    lines(:,:,2) = [corners(1,:); corners(3,:)];
    lines(:,:,3) = [corners(2,:); corners(3,:)];
    lines(:,:,4) = [corners(2,:); corners(3,:)];
    lines(:,:,5) = [corners(1,:); corners(4,:)];
    lines(:,:,6) = [corners(2,:); corners(4,:)];
   
    figure, imshow(img), hold on;
    for i=1:3
        line =lines(:,:,i);
        plot(line(:,1),line(:,2),'LineWidth',3,'Color','green');
    end
    
    for i=4:5
        line =lines(:,:,i);
        plot(line(:,1),line(:,2),'LineWidth',3,'Color','red');
    end
    
    line =lines(:,:,6);
    plot(line(:,1),line(:,2),'LineWidth',3,'Color','blue'); 

end


