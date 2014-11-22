function [x,y] = straight(x,y,X,Y)

d = -Inf;
i_max = NaN;

for i = 1:length(x)-1
    d2=distance(X,Y,x(i),y(i));
    if(d2>d)
        d=d2;
        i_max=i;
    end
end
%plot([X,x(i_max)],[Y,y(i_max)],'c*')
p = pi/2 - atan(abs(Y-y(i_max))/abs(X-x(i_max)));



x = x*cos(p) - y*sin(p);
y = x*sin(p) + y*cos(p);


end

function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end