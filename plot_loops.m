function plot_loops(X,Y,init,last,fmat)

for i=1:length(init)
    plot(X(init(i):last(i)), Y(init(i):last(i)), fmat);
    hold on;
end
end