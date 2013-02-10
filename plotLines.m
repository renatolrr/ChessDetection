function []=plotLines(img,lines)

figure, imshow(img), hold on;

nLines =  length(lines);

for k = 1:nLines
    
    xy = [lines(k).point1; lines(k).point2];
    
    plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    
    % intersection detection. TODO: could just put this in the
    % findintersects file and concat the intersections
    %line1 = [xy(1,1) xy(1,2) xy(2,1) xy(2,2)];
    %      %for o = 1:length(lines)
    %         if o ~= k
    %            az =  [lines(o).point1;lines(o).point2];
    %            line2 = [az(1,1) az(1,2) az(2,1) az(2,2)];
    %            [interX,interY] = findintersects(line1,line2); % INTERSECTION DETECTION
    %            if isnan(interX)==0 & size(interX)>0
    %               plot(interX,interY,'o','Color','blue','LineWidth',4);
    %            end
    %         end
end



hold off;
end