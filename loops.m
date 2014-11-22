function [xi,yi,init,last] = loops(X,Y,bool)
l=1;
xi=[];
yi=[];
init=[];
last=[];
len = length(X);
[x_min,y_min,x_max,y_max]=bounds(X,Y);
at=(x_max-x_min)*(y_max-y_min);
for i=1:len-3
    if strcmp(bool(i+1),'true')
    for j = i+2:len-1
        if strcmp(bool(j+1),'false')
            break;
        end
        x1 = X(i);
        y1 = Y(i);
        x2 = X(i+1);
        y2 = Y(i+1);
        
        x3 = X(j);
        y3 = Y(j);
        x4 = X(j+1);
        y4 = Y(j+1);
    
        [x, y] = polyxpoly([x1, x2], [y1, y2], [x3, x4], [y3, y4]);
        if (~isempty(x) && x3~=x2 && y3~=y2)
            X2=X(i+1:j); Y2=Y(i+1:j);
            X2(length(X2))=X2(1);
            Y2(length(X2))=Y2(1);
            area = polyarea(X2,Y2)/at;
            [sz1,sz2]=size(x);
            if (sz1==1 && sz2==1 && (area>0.00002))
            xi(l)=x;
            yi(l)=y;
            init(l)=i;
            last(l)=j+1;
            l=l+1;
            end
        end 
        
        
    end
    end
end

end

function p = perimeter(X,Y)
p = 0;
for i = 2:length(X)-2
    p=p+(sqrt((X(i) - X(i+1))^2 + (Y(i) - Y(i+1))^2));
end

end