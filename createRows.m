function rows = createRows(x,y,x2,y2)

    rows = [x y 1 0 0 0 -x2*x -x2*y -x2;
              0 0 0 x y 1 -y2*x -y2*y -y2];
          
end


