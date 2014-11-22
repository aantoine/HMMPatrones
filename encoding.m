function t = encoding(X,Y,init,last,t)
n = 9;
[x_min,y_min,x_max,y_max]=bounds(X,Y);
low_bse=y_min;
upper_bse=y_max;
y_prom=(abs(y_max-y_min)/2)+y_min;

hold on 
[x1,y1,x2,y2] =  mins_maxs(X,Y,n,y_prom);
%plot(x1,y1,'xr');
%plot(x2,y2,'xg');
[x1,y1] = trasehold(x1,y1,0);
[x2,y2] = trasehold(x2,y2,1);
%plot(x1,y1,'or');
%plot(x2,y2,'og');

y1 = min(y1);
y2 = max(y2);
d_y = abs(y_min - y_max);
err1 = (abs(y1-y_min))/d_y;
err2 = (abs(y2-y_max))/d_y;
if(err1>0.15 && y1<(y_max-(d_y/2)))
    low_bse=y1;
end
if(err2>0.15 && y2>(y_min+(d_y/2)))
    upper_bse=y2;
end

y_prom=(abs(upper_bse-low_bse)/2)+low_bse;
%plot([x_min,x_max],[upper_bse,upper_bse],'g');
%plot([x_min,x_max],[low_bse,low_bse],'r');
%plot([x_min,x_max],[y_prom,y_prom],'c');


e=zeros(1,length(t));
g=zeros(1,length(t));
for i = 1 : length(t)
    if(t(i)~=0)
    y1 = min(Y(init(i):last(i)));
    y2 = max(Y(init(i):last(i)));
    [a,b,c,d] = line_percent(y1,y2,upper_bse,low_bse,y_prom);
    [a,b,c,d] = normalize(a,b,c,d);
    %Característica espacial
    e_code = espacial_codification(a,b,c,d);
    %Caracteristica geométrica
    g_code = geom_codification(y1,y2,upper_bse,low_bse,y_prom);
    %display(translation(t(i)+1,e_code,g_code));
    k=NaN;
    if(t(i)==-1)
        k=0;
    elseif(t(i)==1)
        k=1;
    else
        k=2;
    end
    t(i)=e_code+(8*g_code)+(24*k);
    else
        %display('Nada');
        t(i)=72;
    end
end

end

function msg = translation(t,e,g)
msg = '';
if(g==0)
    msg = strcat(msg,'small-');
elseif(g==1)
    msg = strcat(msg,'median-');
else
    msg = strcat(msg,'big-');
end

if(t==0)
    msg = strcat(msg,'descendant in the-');
elseif(t==1)
    msg = strcat(msg,'horizontal in the-');
elseif(t==2)
    msg = strcat(msg,'acsendant in the-');
else
    msg = strcat(msg,'loop in the-');
end

if(e==0)
    msg = strcat(msg,'Superior region');
elseif(e==1)
    msg = strcat(msg,'Inferior region');
elseif(e==2)
    msg = strcat(msg,'Medio-Superior region');
elseif(e==3)
    msg = strcat(msg,'Medio-Inferior region');
elseif(e==4)
    msg = strcat(msg,'Medio region');
elseif(e==5)
    msg = strcat(msg,'Medio-Alto region');
elseif(e==6)
    msg = strcat(msg,'Medio-Bajo region');    
else
    msg = strcat(msg,'Mega region');
end
end

function c = geom_codification(y1,y2,up,low,mid)
d = abs(y1-y2);
small_d = abs(mid-low);
median_d = abs(up-low);
if(d<=small_d)
    c = 0;
elseif(d<=median_d)
    c = 1;
else
    c = 2;
end
end

function c = espacial_codification(a,b,c,d)
if(a && ~b && ~c && ~d)
    c=0; %Superior
elseif(~a && ~b && ~c && d)
    c=1; %Inferior
elseif(~a && b && ~c && ~d)
    c=2; %Medio-Superior
elseif(~a && ~b && c && ~d)
    c=3; %Medio-Inferior
elseif(~a && b && c && ~d)
    c=4; %Medio
elseif(a && b && ~d)
    c=5; %Medio Alto
elseif(~a && c && d)
    c=6; %Medio Bajo
elseif(a && b && c && d)
    c=7; %Mega
else
    error('Espacial code cannot be NaN');
end
end

function [a,b,c,d] = normalize(a,b,c,d)
t = 0.05;
if(a>=t)
    a=1;
else
    a=0;
end
if(b>=t)
    b=1;
else
    b=0;
end
if(c>=t)
    c=1;
else
    c=0;
end
if(d>=t)
    d=1;
else
    d=0;
end
end

function [a,b,c,d] = line_percent(y_min,y_max,up,low,mid)
dis = abs(y_max-y_min);
%Extremo superior
if(y_max>=up && y_min>=up)
    a = 1;
elseif (y_max>=up)
    a = (abs(y_max-up)/dis);
else
    a = 0;
end

%Zona media superior
if(y_max>=up)
    if(y_min>=up)
        b=0;
    elseif(y_min>=mid)
        b=(abs(up-y_min)/dis);
    else
        b=(abs(up-mid)/dis);
    end
elseif(y_max>=mid)
    if(y_min>=mid)
        b=(abs(y_max-y_min)/dis);
    else
        b=(abs(y_max-mid)/dis);
    end
else
    b=0;
end

%Zona media inferior
if(y_max>=mid)
    if(y_min>=mid)
        c=0;
    else
        c=(abs(mid-y_min)/dis);
    end
elseif(y_max>=low)
    if(y_min>=low)
        c=(abs(y_max-y_min)/dis);
    else
        c=(abs(y_max-low)/dis);
    end
else
    c=0;
end

%Extremo inferior
if(y_max<=low && y_min<=low)
    d = 1;
elseif (y_min<=low)
    d = (abs(low-y_min)/dis);
else
    d = 0;
end

end

function [x1,y1,x2,y2] = mins_maxs(X,Y,n,prom)
[x_min,~,x_max,~]=bounds(X,Y);
d_total=x_max-x_min;
x1 = [];
y1 = [];
x2 = zeros(1,n);
y2 = zeros(1,n);
xy(:,1)=X;
xy(:,2)=Y;

[~,I]=sort(xy(:,1));
s = xy(I,:);
a = floor(d_total/n);
sortedX = s(:,1);
sortedY = s(:,2);
count = 1;
countY = 1;
prev = 1;
for i = 1:length(X)
    if ((sortedX(i)>x_min+(a*count) && count~=n) || i==length(X))
        delta_x = sortedX(prev:i-1);
        delta_y = sortedY(prev:i-1);
        [y_m,m] = min(delta_y);
        [~,m2] = max(delta_y);
        if(prom>y_m)
            x1(countY)=delta_x(m);
            y1(countY)=delta_y(m);
            countY = countY + 1;
        end
        x2(count)=delta_x(m2);
        y2(count)=delta_y(m2);
        count=count+1;
        prev = i;
    end
    
end
end

function [x1,y1] = trasehold(x,y,up)
m = mean(y);
s = std(y);
k = 1;
for i = 1:length(y)
    if((up && y(i)<= m) || (~up && y(i) >= (m-s/10)))
        x1(k)=x(i);
        y1(k)=y(i);
        k = k+1;
    end
end
end
