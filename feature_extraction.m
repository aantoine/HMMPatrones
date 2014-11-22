function [Init,Last,Type] = feature_extraction(X,Y,bool)
b=zeros(1,4);
[x_min,y_min,x_max,y_max]=bounds(X,Y);
d_total=distance(x_min,y_min,x_max,y_max);
b(1)=x_min;
b(2)=y_min;
b(3)=x_max;
b(4)=y_max;
prev = 1;

Type=[];
Init=[];
Last=[];


for i=1:length(X)
    if (strcmp(bool(i), 'false') && i~=1)
        
        types = local_features(X(prev:i-1),Y(prev:i-1),b);
        [init,last,type]=shrink(types,X(prev:i-1),Y(prev:i-1),d_total);        
        
        Type=[Type,type];
        Init=[Init,init+prev-1];
        Last=[Last,last+prev-1];
        
        prev = i;
    end
    
end

types = local_features(X(prev:i-1),Y(prev:i-1),b);
[init,last,type]=shrink(types,X(prev:i-1),Y(prev:i-1),d_total);

Type=[Type,type];
Init=[Init,init+prev-1];
Last=[Last,last+prev-1];

end

function t = local_features(X,Y,B)

len = length(X);
t=zeros(1,len);

%% Global features vars
grad_tres = 10;
factor = 1900/300;

%% Loops features vars (ellipse)

error_d=0.032;
error_a=0.2;
error_rmin_rmax = 0.4;

a_loop=Inf;
b_loop=Inf;
i_end=-1;
i_init = -1;

loop_init=-1;
loop_end=-1;

%% Loops features vars (interesction)
count_inter=1;
init=[];
last=[];
a_gral=abs(B(1)-B(3))*abs(B(2)-B(4));
area_error = 0.0007;

for i=1:len
    %% Carácterísticas globales (Asc, Desc, None)
    if(i~=len)
    %% Calculo de la característica
    x = X(i)/factor;
    y = Y(i);
    a = X(i+1)/factor;
    b = Y(i+1);
    
    g = atand(abs(y-b)/abs(x-a));
    
    if a==x && b>y                  %Acendente
        t(i) = 1;
    elseif a==x && b<y              %Descendiente
        t(i) = -1; 
    elseif(b>y && g>=45+grad_tres)  %Acendente
        t(i) = 1;
    elseif(y>b && g>=45+grad_tres)  %Descendiente
        t(i) = -1;
    else                            %Nada (horizontal?)
        t(i) = 0;
    end
    end
    
    %% Loops por elipses
    d_init = distance(X(1), Y(1), X(i), Y(i));
    d_end = distance(X(len), Y(len), X(i), Y(i));
    
    p_init = d_init/distance(B(1),B(2),B(3),B(4));
    p_end = d_end/distance(B(1),B(2),B(3),B(4));
    if i>5 && p_init<error_d && a_loop>d_init;
        a_loop=d_init;
        i_init = i;
    end
    
    if i<len-9 && p_end<error_d && b_loop>d_end
        b_loop=d_end;
        i_end = i;
    end
    
    %% Loops por intersección
    if i<len-3
    for j = i+2:len-1
        
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
            area = polyarea(X2,Y2)/a_gral;
            [sz1,sz2]=size(x);
            [xx,yy]=straight(X(i+1:j),Y(i+1:j),x,y);
            dx_max=max_dx(xx);
            dy_max=max_dx(yy);
            d1 = min(dx_max,dy_max);
            d2 = max(dx_max,dy_max);
            err = d1/d2;
            if (sz1==1 && sz2==1 && (area>area_error) && (err) >(error_rmin_rmax))
            %plot(X(i+1:j),Y(i+1:j),'-xr');
            %plot(xx,yy,'-xr');
            init(count_inter)=i;
            last(count_inter)=j+1;
            count_inter=count_inter+1;
            end
        end 
        
        
    end
    end
    
end

%% Verificación presencia elipse
if(i_init ~= -1 && i_end ~= -1)
    [error1,r_min1,rmax1,area1]=loop_error(X(1:i_init),Y(1:i_init));
    [error2,r_min2,rmax2,area2]=loop_error(X(i_end:len),Y(i_end:len));
    e1=r_min1/rmax1;
    e2=r_min2/rmax2;
    area1=area1/a_gral;
    area2=area2/a_gral;
    
    if(i_init<=i_end) 
        u=1;
        if(error1<error_a && e1>error_rmin_rmax)
            loop_init(u)=1;
            loop_end(u)=i_init;
            u=u+1;
        end
        if(error2<error_a && e2>error_rmin_rmax)
            loop_init(u)=i_end;
            loop_end(u)=len;
        end
    else
        if(error1<error2 && error1<error_a && e1>error_rmin_rmax)
            %e1
            loop_init=1;
            loop_end=i_init;
        elseif (error2<error_a && e2>error_rmin_rmax)
            %e2
            loop_init=i_end;
            loop_end=len;
        end
    end
        
elseif(i_init ~= -1)
    [error,r_min,rmax,area1]=loop_error(X(1:i_init),Y(1:i_init));
    e1=r_min/rmax;
    if (error < error_a && e1>error_rmin_rmax)
        %e1
        loop_init=1;
        loop_end=i_init;
    end

elseif(i_end ~= -1)
    [error,r_min,rmax,area1]=loop_error(X(i_end:len),Y(i_end:len));
    e1=r_min/rmax;
    if (error<error_a && e1>error_rmin_rmax)
        %e1
        loop_init=i_end;
        loop_end=len;
    end
end

%% Loops por inter
if(~isempty(init))
    for h = 1:length(init)
        t(init(h):last(h)-1)=2;
    end
end

[s_loop1,s_loop2]=size(loop_init);

if(s_loop1==1 && s_loop2==1 && loop_init~=-1 && loop_end~=-1)
    if(~has_loop(t(loop_init:loop_end)))
        t(loop_init:loop_end-1)=2;
    end
elseif (s_loop1~=1 || s_loop2~=1)
    if(~has_loop(t(loop_init(1):loop_end(1))))
        t(loop_init(1):loop_end(1)-1)=2;
    end
    if(~has_loop(t(loop_init(2):loop_end(2))))
        t(loop_init(2):loop_end(2)-1)=2;
    end
    
end

%t(length(t))=t(length(t)-1);
end

function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end


function dx_max = max_dx(X)
min_x = min(X);
max_x = max(X);
dx_max = abs(min_x-max_x);
end

function b = has_loop(t)
b = 0;
for i = 1:length (t)
    if t(i) == 2
        b = 1;
        return 
    end
end
end