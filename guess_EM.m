function [alpha0,beta0,tau0,kai0,phi0] = guess_EM(t,X)
% calculate the degradation increment
% sample size
n = size(X,1);
% number of observations
m = size(X,2);

for i = 1:n
    for j = 2:m
        dt(i,j) = t(i,j)-t(i,j-1);
        dx(i,j) = X(i,j)-X(i,j-1);
    end
    v(i) = sum(dx(i,2:m))./sum(dt(i,2:m));
end
v_mean = sum(sum(dx(1:n,2:m)))./sum(sum(dt(1:n,2:m)));
sigma_mean = sum(sum((dx(1:n,2:m)-v_mean.*dt(1:n,2:m)).^2))./sum(sum(dt(1:n,2:m)));
x01 = [1,1];
[x] = fmincon(@(x)ig_likeli(x,v),x01);
alpha0 = x(1);
beta0 = x(2);
kai0 = sqrt(sigma_mean/v_mean);
phi0 = mean(X(1:n,1));
x02 = 0;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0;
ub = [];
tau0 = fmincon(@(x)partial_likeli_tau(x,t,X,alpha0,kai0,phi0),x02,A,b,Aeq,beq,lb,ub);
end


