function new_lines = removeSimilarLines(lines)

    epsilonRho = 60;
    epsilonTheta = 14;
    
    % x = [arrayfun(@(c)(lines(c).rho), 1:22)' arrayfun(@(c)(lines(c).theta), 1:22)']
    
    
    % Step 1 -> removes noise 
    
    nLines = size(lines,2);
    
    lineLengths = arrayfun(@(c)(norm(lines(c).point1-lines(c).point2,2)),1:nLines);
    lines = lines(lineLengths>200);
    
    
    % Step 2-> remove lines that are supposed to be the same, mantaining
    % the one with greater length
    nLines = size(lines,2);
    lineLengths = arrayfun(@(c)(norm(lines(c).point1-lines(c).point2,2)),1:nLines);
    
    i=1;
    
    while i<nLines-1
       
        j=i+1;
        
        while j<nLines
            
            
            
            if isSameLine(lines(i),lines(j),epsilonRho,epsilonTheta)  
                
                if(lineLengths(i)<lineLengths(j))
                    lines(i) = lines(j);
                    lineLengths(i) = lineLengths(j);
                end
                
                lines(j) = [];
                lineLengths(j)=[];
                
                nLines = nLines-1;
            
            end
            
            j=j+1;
        end
        
        i=i+1;
    end
    
    new_lines = lines;
    
end

function isit = isSameLine(line1,line2,epsilonRho,epsilonTheta)

    rho1 = line1.rho;
    theta1 = line1.theta;
    rho2 = line2.rho;
    theta2 = line2.theta;
    isit = 0;
    
    if abs(rho1-rho2) < epsilonRho && abs(theta1-theta2)<epsilonTheta
        
        isit=1;
    end
    
    if(90-abs(theta1)< epsilonTheta/2 && 90-abs(theta2)< epsilonTheta/2 ...
            && abs(abs(rho1)-abs(rho2))<epsilonRho)
        
        isit = 1;        
    end 

end