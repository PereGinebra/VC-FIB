function [dist] = distFromRectangle(x,y,rect)
    rx = rect(1);
    ry = rect(2);
    rxx = rect(1)+rect(3);
    ryy = rect(2)+rect(4);

    if x > rx & x < rxx
        if y > rect(2) && y < ryy
            dist = 0;
        else 
            dist = min(abs(y-rect(2)), abs(y-ryy));
        end
    elseif y > ry &  y < ryy
            dist = min(abs(x-rect(1)), abs(x-rxx));
    else 
        dist = min([norm([x,y]-[rx,ry]), norm([x,y]-[rx,ryy]), norm([x,y]-[rxx,ry]), norm([x,y]-[rxx,ryy])]);
    end
end

