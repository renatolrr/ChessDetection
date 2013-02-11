function piece = detectPieceAt(coordinates,hsvImg,colors)
    
    x = floor(coordinates(1));
    y = floor(coordinates(2));
    
    
    % boxR = img(x-2:x+2,y-2:y+2,1);
    boxS = hsvImg((y-2):(y+2),(x-2):(x+2),2);
    
    % boxB = img(x-2:x+2,y-2:y+2,3);
    
    % avgRed = mean(boxR(:));
    avgSaturation = sum(boxS(:))/25;
    % avgBlue = mean(boxB(:));
    
    % avgColor = [avgRed avgGreen avgBlue];
    
    % distances = computeDistance(colors, repmat(avgColor, size(colors,1),1));
    
    pieceT = avgSaturation>0.5;
    pieceR = getRow(y);
    pieceC = getColumn(x);
    
    piece = [pieceT pieceR pieceC];
    
end

function row = getRow(value)
    row = floor((value-20)/64)+1;
end


function col = getColumn(value)

    col = floor((value-20)/64)+1;
end

