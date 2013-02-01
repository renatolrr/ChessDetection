function new_image = recoverParrallelLines(img,points);
    
    X = points;
    
    A = zeros(9,9);
    
    p = [0 0; 0 1; 1 0; 1 1]*1024;
    
    for i=1:4
        A((2*i-1):2*i,1:9) = createRows(X(i,1),X(i,2),p(i,1),p(i,2));
    end

    h = null(A);

    H = zeros(3,3);
    
    
    for i=1:3
        for j=1:3
            H(i,j) = h(3*(i-1)+j);
        end
    end

    %normalizes
    H = H/H(3,3);
    
    % Applies the transformation to the image
    T = maketform('projective', H');
    
    R = makeresampler({'cubic','cubic'},'fill');
    new_image = imtransform(img,T);%,R, 'XData', [-600 600], 'YData', [-600 600]);


end