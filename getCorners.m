function corners = getCorners(img,lines)
    
    nLines =  length(lines);
    [bottomLeftCorner, bottomRightCorner] = getBottomCorners(img);
    
    distanceThreshold = 180;   

    for k=1:nLines
        point1 = lines(k).point1;
        point2 = lines(k).point2;
        point1distL = sqrt(sum((point1 - bottomLeftCorner) .^ 2));
        point1distR = sqrt(sum((point1 - bottomRightCorner) .^ 2));
        point2distL = sqrt(sum((point2 - bottomLeftCorner) .^ 2));
        point2distR = sqrt(sum((point2 - bottomRightCorner) .^ 2));

        fprintf('DistR1: %f | DistR2: %f | DistL1: %f | DistL2: %f\n', point1distR, point2distR, point1distL, point2distL)
        
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
   
    corners = [bottomRightCorner; topRightCorner; bottomLeftCorner; topLeftCorner];
    
end


function [leftcentroid, rightcentroid]=getBottomCorners(img)

    hsvImg = rgb2hsv(img);

    leftmask = hsvImg(:,:,1)>0.5 & hsvImg(:,:,1)<0.6;
    rightmask = hsvImg(:,:,1)>0.1 & hsvImg(:,:,1)<0.2;

    leftcentroid = getCorner(leftmask);
    rightcentroid = getCorner(rightmask);


end

function corner = getCorner(mask)

    mask = imerode(mask,ones(3));

    center = regionprops(mask,'centroid');
    
    corner(1) = center(1).Centroid(1);
    corner(2) = center(1).Centroid(2);

end
