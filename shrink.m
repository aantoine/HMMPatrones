function [init,last,type] = shrink(t,X,Y,d_t)
len = length(t);
init_type = [NaN,NaN];
d=0;
count=1;
prob_tres = 0.032;
init=[];
last=[];
type=[];

for i=1:len-1

%% Reducción de los trazos a segmentos
    if(~isnan(init_type(2)))% no es el primer elemento
        if(init_type(2) == t(i)) %si mantiene el tipo aumenta la distancia
            d=d+distance(X(i),Y(i),X(i+1),Y(i+1));
        else
            p = d/d_t;
            if (init_type(2) == 2 || p>=prob_tres)
                %p
                init(count)=init_type(1);
                last(count)=i;
                if i == init_type(1)
                   i=i+0; 
                end
                type(count)=init_type(2);
                %prob(count)=p;
                %dis(count)=d;
                
                count=count+1;
            end
            
            %reset parameters
            init_type(2) = t(i);
            init_type(1) = i;
            d=distance(X(i),Y(i),X(i+1),Y(i+1));
        end
    else %el primer elemento
        init_type(2) = t(i);
        init_type(1) = i;
        d=distance(X(i),Y(i),X(i+1),Y(i+1));
    end
end
p = d/d_t;
if (p>=prob_tres || init_type(2)==2)
    init(count)=init_type(1);
    last(count)=i+1;
    type(count)=init_type(2);
    %(count)=p;
    %dis(count)=d;
end
end

function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end
