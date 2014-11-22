function t = init(file_name)
fid = fopen(file_name);
A=textscan(fid,'%n%f64%s','\t');
%hold on;
%plot_prety(A{1},-A{2},A{3});
n = 7;
[x,y] = minimos(A{1},-A{2}, n);
%plot(x,y,'or')
[x,y] = trasehold(x,y);
%plot(x,y,'xg')
[x_min,~,x_max,~]=bounds(A{1},-A{2});
poli = polyfit(x,y,1);
x1 = [x_min,x_max];
y1 = polyval(poli,x1);
%plot(x1,y1,'r')

p = atan(abs(y1(2)-y1(1))/abs(x_max-x_min));
y_p1=x1*sin(p) + y1*cos(p);
y_p2=x1*sin(-p) + y1*cos(-p);
dy1=abs(y_p1(1)-y_p1(2));
dy2=abs(y_p2(1)-y_p2(2));
if(dy1>dy2)
    p=-p;
end
%plot(x1*cos(p) - y1*sin(p),x1*sin(p) + y1*cos(p),'g')
x=A{1}; y=-A{2};

xp = x*cos(p) - y*sin(p);
yp = x*sin(p) + y*cos(p);

plot_prety(xp,yp,A{3});
[i,l,t]=feature_extraction(xp,yp,A{3});
plot_features(xp,yp,i,l,t);
t = encoding(xp,yp,i,l,t);


end

function [x1,y1] = trasehold(x,y)
m = mean(y);
s = std(y);
k = 1;
for i = 1:length(y)
    if(y(i) >= m-s)
        x1(k)=x(i);
        y1(k)=y(i);
        k = k+1;
    end
end
end


function [x,y] = minimos(X,Y, n)
[x_min,y1,x_max,y2]=bounds(X,Y);
media = (abs(y2-y1)/2)+y1;
d_total=x_max-x_min;
x = [];
y = [];
xy(:,1)=X;
xy(:,2)=Y;

[~,I]=sort(xy(:,1));
s = xy(I,:);
a = floor(d_total/n);
sortedX = s(:,1);
sortedY = s(:,2);
count = 1;
c=1;
prev = 1;
for i = 1:length(X)
    if ((sortedX(i)>x_min+(a*count) && count~=n) || i==length(X))
        delta_x = sortedX(prev:i-1);
        delta_y = sortedY(prev:i-1);
        [y_m,m] = min(delta_y);
        if((media)>y_m)
            x(c)=delta_x(m);
            y(c)=delta_y(m);
            c=c+1;
            
        end
        prev = i;
        count=count+1;
    end
    
end
end