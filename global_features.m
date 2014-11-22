function [init, last, type] = global_features(X,Y,bool)

%distancia entre punto máximo y mínimo en la imágen
[x_min,y_min,x_max,y_max]=bounds(X,Y);
d_total=distance(x_min,y_min,x_max,y_max);

prev = 1;

for i=1:length(X)
    if (strcmp(bool(i), 'false') && i~=1)
        
        [init,last,type, d, p] =global_types(X(prev:i-1),Y(prev:i-1),d_total,prev);
        %[~,~,type, d, p] = reduce(X(prev:i-1),Y(prev:i-1),t,);
        
        for k=1:length(type)
            x=X(init(k)+prev-1:last(k)+prev-1);
            y=Y(init(k)+prev-1:last(k)+prev-1);
            if(type(k)==-1)
                plot(x,y,'r');
            elseif type(k) == 0
                plot(x,y,'k');
            else
                plot(x,y,'g');
            end
        end
        tdp=[];
        tdp(:,1)=type;
        tdp(:,2)=d;
        tdp(:,3)=p;
        display(tdp');
        
        prev = i;
    end
    
end

[init,last,type, ~, ~] =global_types(X(prev:i-1),Y(prev:i-1),d_total);

for k=1:length(type)
    x=X(init(k)+prev-1:last(k)+prev-1);
    y=Y(init(k)+prev-1:last(k)+prev-1);
    if(type(k)==-1)
        plot(x,y,'r');
    elseif type(k) == 0
        plot(x,y,'k');
    else
        plot(x,y,'g');
    end
end

end


function [init,last,type,dis,prob] = global_types(X,Y,d_t,prev)
len = length(X);
grad_tres = 10;
%type = zeros(1,len-1);
%gr = zeros(1,len-1);
factor = 1900/300;

init_type = [NaN,NaN];
d=0;
count=1;
prob_tres = 0.045;

for i=1:len-1
    %% Cálculo del tipo de un trazo (carácterísticas globales)
    x = X(i)/factor;
    y = Y(i);
    a = X(i+1)/factor;
    b = Y(i+1);
    
    g = atand(abs(y-b)/abs(x-a));
    
    if a==x && b>y                  %Acendiente
        t = 1;
    elseif a==x && b<y              %Descendiente
        t = -1; 
    elseif(b>y && g>=45+grad_tres)   %Acendiente
        t = 1;
    elseif(y>b && g>=45+grad_tres)   %Descendiente
        t = -1;
    else                            %Nada
        t = 0;
    end
    
    %% Reducción de los trazos a segmentos
    if(~isnan(init_type(2)))% no es el primer elemento
        if(init_type(2) == t) %si mantiene el tipo aumenta la distancia
            d=d+distance(X(i),Y(i),X(i+1),Y(i+1));
        else
            p = d/d_t;
            if p>=prob_tres
                
                init(count)=init_type(1);
                last(count)=i;
                type(count)=init_type(2);
                prob(count)=p;
                dis(count)=d;
                
                count=count+1;
            end
            
            %reset parameters
            init_type(2) = t;
            init_type(1) = i;
            d=distance(X(i),Y(i),X(i+1),Y(i+1));
        end
    else %el primer elemento
        init_type(2) = t;
        init_type(1) = i;
        d=distance(X(i),Y(i),X(i+1),Y(i+1));
    end
    
end

p = d/d_t;
if p>=prob_tres
    init(count)=init_type(1);
    last(count)=i;
    type(count)=init_type(2);
    prob(count)=p;
    dis(count)=d;
end

end



function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end