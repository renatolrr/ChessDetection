function corners = getCorners(img,lines)
    
    nLines =  length(lines);
    [bottomLeftCorner, bottomRightCorner] = getBottomCorners(img);
    
    closestPointL = 0; % closest
    secondClosestPointL = 0; % second closest
    closestPointR = 0;
    secondClosestPointR = 0;
    
    closestDistanceL = max(size(img)); 
    closestDistanceR = max(size(img));
    secondClosestDistanceL = max(size(img)); 
    secondClosestDistanceR = max(size(img));
    
    for k=1:nLines
        point1 = lines(k).point1;
        point2 = lines(k).point2;
        
        point1distL = getDistance(point1, bottomLeftCorner);
        point1distR = getDistance(point1, bottomRightCorner);
        point2distL = getDistance(point2, bottomLeftCorner);
        point2distR = getDistance(point2, bottomRightCorner);
        
        if(point1distL < secondClosestDistanceL)
            if(point1distL < closestDistanceL)
                secondClosestPointL = closestPointL;
                secondClosestDistanceL = closestDistanceL;
                closestPointL = point1;
                closestDistanceL = point1distL;
            else
                secondClosestPointL = point1;
                secondClosestDistanceL = point1distL;
            end
        elseif(point2distL < secondClosestDistanceL)
            if(point2distL < closestDistanceL)
                secondClosestPointL = closestPointL;
                secondClosestDistanceL = closestDistanceL;
                closestPointL = point2;
                closestDistanceL = point1distL;
            else
                secondClosestPointL = point2;
                secondClosestDistanceL = point1distL;
            end
        end
        
        if(point1distR < secondClosestDistanceR)
            if(point1distR < closestDistanceR)
                secondClosestPointR = closestPointR;
                secondClosestDistanceR = closestDistanceR;
                closestPointR = point1;
                closestDistanceR = point1distR;
            else
                secondClosestPointR = point1;
                secondClosestDistanceR = point1distR;
            end
        elseif(point2distR < secondClosestDistanceR)
            if(point2distR < closestDistanceR)    
                secondClosestPointR = closestPointR;
                secondClosestDistanceR = closestDistanceR;
                closestPointR = point2;
                closestDistanceR = point2distR;
            else
                secondClosestPointR = point2;
                secondClosestDistanceR = point2distR;
            end
        end
    end
    
    for k=1:nLines
        point1 = lines(k).point1;
        point2 = lines(k).point2;
        
        point1InLeftCorner = (point1 == closestPointL | point1 == secondClosestPointL);
        point1InRightCorner = (point1 == closestPointR | point1 == secondClosestPointR);   
        point2InLeftCorner = (point2 == closestPointL | point2 == secondClosestPointL);
        point2InRightCorner = (point2 == closestPointR | point2 == secondClosestPointR);
        
        if(point1InLeftCorner & ~point2InRightCorner)
            topLeftCorner = point2;
        elseif(point1InRightCorner & ~point2InLeftCorner)
            topRightCorner = point2;
        elseif(point2InLeftCorner & ~point1InRightCorner)
            topLeftCorner = point1;
        elseif(point2InRightCorner & ~point1InRightCorner)
            topRightCorner = point1;
        end
    end
    
    corners = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
    
end

function dist = getDistance(point1, point2)
dist = sqrt(sum((point1 - point2) .^ 2));
end

function [leftcentroid, rightcentroid]=getBottomCorners(img)

    hsvImg = rgb2hsv(img);
    
    leftmask = hsvImg(:,:,1)>0.35 & hsvImg(:,:,1)<0.40;
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
