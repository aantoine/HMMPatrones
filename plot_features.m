function plot_features(X,Y,init,last,t)
hold on;
for i=1:length(t)
    if(t(i)==-1)
        plot(X(init(i):last(i)), Y(init(i):last(i)), 'or');
    elseif(t(i)==0)
        plot(X(init(i):last(i)), Y(init(i):last(i)), 'xk');
    elseif(t(i)==1)
        plot(X(init(i):last(i)), Y(init(i):last(i)), 'og');
    elseif(t(i)==2)
        plot(X(init(i):last(i)), Y(init(i):last(i)), 'ob');
    end
end
end