function [Init, Last] = loops_ellipse(X,Y,bool)
b=zeros(4);
[x1,y1,x2,y2] = bounds(X,Y);
b(1)=x1;
b(2)=y1;
b(3)=x2;
b(4)=y2;
prev = 1;
count = 1;
Init=[];
Last=[];

for i=1:length(X)
    if (strcmp(bool(i), 'false') && i~=1)
        
        [init,last] = find_loops(X(prev:i-1),Y(prev:i-1),b);
        if(init~=-1 && last ~= -1)
            Init(count)=init+prev-1;
            Last(count)=last+prev-1;
            count = count+1;
        end
        prev = i;
    end
    
end

[init,last] = find_loops(X(prev:length(X)),Y(prev:length(X)),b);
if(init~=-1 && last ~= -1)
    Init(count)=init+prev-1;
    Last(count)=last+prev-1;
end
end

function d = distance(x1,y1,x2,y2)

d = sqrt((x1 - x2)^2 + (y1 - y2)^2);

end

function [init, last] = find_loops(X,Y,B)

error_d=0.045;
error_a=0.3;

a=Inf;
b=Inf;
i_end=-1;
i_init = -1;
l = length(X);
init=-1;
last=-1;
for i=1:l
    d_init = distance(X(1), Y(1), X(i), Y(i));
    d_end = distance(X(l), Y(l), X(i), Y(i));
    
    p_init = d_init/distance(B(1),B(2),B(3),B(4));
    p_end = d_end/distance(B(1),B(2),B(3),B(4));
    if i>9 && p_init<error_d && a>d_init;
        a=d_init;
        i_init = i;
    end
    
    if i<l-9 && p_end<error_d && b>d_end
        b=d_end;
        i_end = i;
    end
    
  
end

if(i_init ~= -1 && i_end ~= -1)
    error1=loop_error(X(1:i_init),Y(1:i_init));
    error2=loop_error(X(i_end:l),Y(i_end:l));
    %plot(X(1:i_init),Y(1:i_init),'xg');
    if(error1<error2 && error1<error_a)
        init=1;
        last=i_init;
        %plot(X(1:i_init),Y(1:i_init),'xg');
    elseif error2<error_a
        init=i_end;
        last=l;
        %plot(X(i_end:l),Y(i_end:l),'xg');
    end
        
elseif(i_init ~= -1)
    error=loop_error(X(1:i_init),Y(1:i_init));
    if error < error_a
        init=1;
        last=i_init;
        %plot(X(1:i_init),Y(1:i_init),'xg');
    end

elseif(i_end ~= -1)
    error=loop_error(X(i_end:l),Y(i_end:l));
    %plot(X(1:i_init),Y(1:i_init),'xg');
    if error<error_a
        init=i_end;
        last=l;
        %plot(X(i_end:l),Y(i_end:l),'xg');
    end
end
    
end



