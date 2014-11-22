function plot_prety(X,Y,bool)
len = length(X);
prev=1;
for i=1:len
    if(strcmp(bool(i),'false') && i~=1)
        plot(X(prev:i-1),Y(prev:i-1));
        hold on;
        prev = i;
    end
end
plot(X(prev:len),Y(prev:len));