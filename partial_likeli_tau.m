function [plnL] = partial_likeli_tau(x,t,X,alpha0,kai0,phi0)
% x is the paraemter of tau0
x = [x];
n = size(X,1);
plnL = 0;
for i = 1:n
    (X(i,1)-phi0)^2/(2*kai0^2*(x+t(i,1))*alpha0)
    plnL = plnL-...
        0.5*log(x+t(i,1))-...
        (X(i,1)-phi0)^2/(2*kai0^2*(x+t(i,1))*alpha0)-...
        alpha0*(x+t(i,1))/(2*kai0^2);
end
plnL = -plnL;
end