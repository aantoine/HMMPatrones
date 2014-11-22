function [init, last, type] = global_features(X,Y,bool)

%distancia entre punto máximo y mínimo en la imágen
[x_min,y_min,x_max,y_max]=bounds(X,Y);
d_total=distance(x_min,y_min,x_max,y_max);

prev = 1;

for i=1:length(X)
    if (strcmp(bool(i), 'false') && i~=1)
        
        [t,~] =global_types(X(prev:i-1),Y(prev:i-1));
        [~,~,type, d, p] = reduce(X(prev:i-1),Y(prev:i-1),t,d_total);
        
        for k=prev:length(t)+prev-1
            if(t(k-prev+1)==-1)
                plot(X(k),Y(k),'ro');
            elseif t(k-prev+1) == 0
                plot(X(k),Y(k),'ko');
            else
                plot(X(k),Y(k),'go');
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

[t,~] =global_types(X(prev:i-1),Y(prev:i-1));
[init,last,type, ~] = reduce(X(prev:i-1),Y(prev:i-1),t,d_total);

for k=prev:length(t)+prev-1
    if(t(k-prev+1)==-1)
        plot(X(k),Y(k),'ro');
    elseif t(k-prev+1) == 0
        plot(X(k),Y(k),'ko');
    else
        plot(X(k),Y(k),'go');
    end
end

end


function [type] = global_types(X,Y)
len = length(X);
%treshold de los grados en los cuales se acepta que un trazo
%asciende/desciende
treshold = 5;

%type = zeros(1,len-1);
factor = 1900/300;

init_type = [NaN,NaN];
d=0;
count=1;
prob_tres = 0.04;

for i=1:len-1
    x = X(i)/factor;
    y = Y(i);
    a = X(i+1)/factor;
    b = Y(i+1);
    
    g = atand(abs(y-b)/abs(x-a));
    
    if a==x && b>y                  %Acendiente
        type(i) = 1;
    elseif a==x && b<y              %Descendiente
        type(i) = -1; 
    elseif(b>y && g>=45+treshold)   %Acendiente
        type(i) = 1;
    elseif(y>b && g>=45+treshold)   %Descendiente
        type(i) = -1;
    else                            %Nada
        type(i) = 0;
    end
end

end

function [init,last,type,dis,p] = reduce(X,Y,t,d_t)
init_type = [NaN,NaN];
d=0;
count=1;
prob_tres = 0.04;
for j=1:length(t)
    if(~isnan(init_type(2)))
        if(init_type(2) == t(j))
            d=d+distance(X(j),Y(j),X(j+1),Y(j+1));
        else
            prob = d/d_t;
            if prob>=prob_tres
                init(count)=init_type(1);
                last(count)=j;
                type(count)=init_type(2);
                p(count)=prob;
                dis(count)=d;
                count = count+1;
            end
            %reset parameters
            init_type(2) = t(j);
            init_type(1) = j;
            d=distance(X(j),Y(j),X(j+1),Y(j+1));
        end
    else
        init_type(2) = t(j);
        init_type(1) = j;
        d=distance(X(j),Y(j),X(j+1),Y(j+1));
    end

end
prob = d/d_t;
if prob>=prob_tres
    init(count)=init_type(1);
    last(count)=j;
    type(count)=init_type(2);
    p(count)=prob;
    dis(count)=d;
end
end

function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end