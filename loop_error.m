function [error,r,rm,a2] = loop_error(X,Y)

try
    XY(:,1)=X;
    XY(:,2)=Y;

    A= EllipseDirectFit(XY);
    %a=A(1); b=A(2); c=A(3); d=A(4); e=A(5); f=A(6);
    %ax^2 + bxy + cy^2 + dx + ey + f = 0,

    X(length(X)+1)=X(1);
    Y(length(Y)+1)=Y(1);
    
    a1 = polyarea(X,Y);
    [r1,r2]=imellipse(A);
    a2 = pi*r1*r2;
    r=min(r1,r2);
    rm=max(r1,r2);
    
    error = abs(a1-a2);
    error = error/max(a1,a2);
catch exception
    error = Inf;
    r = 0;
    rm=0;
    a2=0;
end
end

function [semi_a,semi_b] = imellipse(p)
a = p(1);
b = 0.5 * p(2);
c = p(3);
d = 0.5 * p(4);
f = 0.5 * p(5);
g = p(6);

q = 2*(a*f^2+c*d^2+g*b^2-2*b*d*f-a*c*g)/(b^2-a*c);
r = realsqrt((a-c)^2+4*b^2);
semi_a = realsqrt(q/(r-(a+c)));   % major axis
semi_b = realsqrt(q/(-r-(a+c)));  % minor axis
end