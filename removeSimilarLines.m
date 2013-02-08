function new_lines = removeSimilarLines(lines)

    epsilonRho = 60;
    epsilonTheta = 10;
    
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
            
            if(abs(lines(i).rho - lines(j).rho)<epsilonRho && ...
                abs(lines(i).theta - lines(j).theta)<epsilonTheta)
                
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