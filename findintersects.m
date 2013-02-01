% Finds the intersections of two lines. Not the best implementation but 
% does the job.

function [x,y] = findintersects(line1,line2)
% slope = changeY/changeX
m_line1 = (line1(4)-line1(2))/(line1(3)-line1(1)); 
m_line2 = (line2(4)-line2(2))/(line2(3)-line2(1));
% b = x2 - m*x1
b_line1 = line1(2)-m_line1*line1(1);
b_line2 = line2(2)-m_line2*line2(1);
b = [b_line1;b_line2];
a=[1 -m_line1; 1 -m_line2];
% solve system of equations
xy = a\b;
x=xy(2); y=xy(1);

% create min and max thresholds since the calculations above were done
% for infinite lines.
l1min = [min([line1(1) line1(3)]), min([line1(2) line1(4)])];
l1max = [max([line1(1) line1(3)]), max([line1(2) line1(4)])];
l2min = [min([line2(1) line2(3)]), min([line2(2) line2(4)])];
l2max = [max([line2(1) line2(3)]), max([line2(2) line2(4)])];

% Make sure the intersections are on the lines
if ((x<l1min(1)) | (x>l1max(1)) | (y<l1min(2)) | (y>l1max(2)) |...
       (x<l2min(1)) | (x>l2max(1)) | (y<l2min(2)) | (y>l2max(2)) )
   x=NaN; y=NaN;
end
end