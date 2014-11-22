function [x_min,y_min,x_max,y_max]=bounds(X,Y)

x_min = Inf;
y_min = Inf;
x_max = -Inf;
y_max = -Inf;

for i = 1:length(X)
    if(x_min>X(i))
        x_min = X(i);
    end
    
    if(x_max<X(i))
        x_max = X(i);
    end
    
    if(y_min>Y(i))
        y_min = Y(i);
    end
    
    if(y_max<Y(i))
        y_max = Y(i);
    end

end

end