function pieces = detectPieces(img, board,colors)

    boardBW = im2bw(board);
    imgBW = im2bw(img);
    
    locations = imgBW-boardBW;
    locations = normalize(locations);
    
    locations = locations<10;
    locations = imerode(locations, ones(11));
       
    center = regionprops(locations,'centroid');
    %center
    
    pieces = zeros(size(center,1),3);
    
    hsvImg = rgb2hsv(img);
    
    for i=1:size(center,1)
        
        pieces(i,:) = detectPieceAt(center(i).Centroid,hsvImg,colors);
        
    end
    
    imtool(locations);

end

function normalizedMatrix = normalize(matrix)

    maxM = max(matrix(:));
    minM = min(matrix(:));
    normalizedMatrix = 255*(matrix-minM)/(maxM-minM);

end
