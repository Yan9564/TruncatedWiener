function [lnL] = ig_likeli(x,v)
x = [x(1),x(2)];
n = length(v);
lnL = 0;
mu = x(1);
lambda = x(2);
for i = 1:n
    lnL = lnL+...
        log(pdf('InverseGaussian',v(i),mu,lambda));
end
lnL = -lnL;

end