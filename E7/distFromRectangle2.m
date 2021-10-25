function [dist] = distFromRectangle2(x,y,rect)
    if x > rect(1) & x < (rect(1)+rect(3)) & y > rect(2) & y < (rect(2)+rect(4))
        dist = 0;
    else
        rectCenter = [rect(1)+(rect(3)/2),rect(2)+(rect(4)/2)];
        dist = norm([x,y]-rectCenter);
    end
end

