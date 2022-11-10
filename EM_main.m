clc;
clear;
close all;

% load data
filename = ['.\GaAs_Laser.xlsx'];
data = xlsread(filename);

% select one unit as test unit
test_unit_ind = 15;
% truncation time
truncation_time = 3;
% sample size of training units
n = 14;
M = size(data,1);
% number of total observations
m = M-truncation_time+1;
% prepare the training data
T = data(truncation_time:M,1)-data(truncation_time,1);
t = repmat(T,1,n+1);
column = 2:1:16;
index = column(find(column~=test_unit_ind+1));
X = data(truncation_time:M,index);
X = X';
t = t';

% parameter estimation
% educated guess of parameter estimates
[alpha0,beta0,tau0,kai0,phi0] = guess_EM(t,X);
% set the number of iterations
n_em = 100;

% EM algorihtm
for j = 2:m
    % s indicates the number of iterations
    for s = 1
        alpha(j,s) = alpha0;
        beta(j,s) = beta0;
        tau(j,s) = tau0;
        phi(j,s) = phi0;
        kai(j,s) = kai0;
    end
    for s = 2:n_em
        % E-step
        for  i = 1:n
            for k = 1
                dt(i,k,s) = tau(j,s-1)+t(i,k);
                dX(i,k,s) = X(i,k);
            end
            for k = 2:j
                dt(i,k,s) = t(i,k)-t(i,k-1);
                dX(i,k,s) = X(i,k)-X(i,k-1);
            end
            p(i,j,s) = -(j+1)./2;
            C(i,1,s) = beta(j,s-1)+(dX(i,1,s)-phi(j,s-1)).^2./(kai(j,s-1).^2.*dt(i,1,s));
            C(i,j,s) = beta(j,s-1)+(dX(i,1,s)-phi(j,s-1)).^2./(kai(j,s-1).^2.*dt(i,1,s))+sum(dX(i,2:j,s).^2./(kai(j,s-1).^2.*dt(i,2:j,s)));
            D(i,1,s) = beta(j,s-1)./alpha(j,s-1).^2+dt(i,1,s)./kai(j,s-1).^2;
            D(i,j,s) = beta(j,s-1)./alpha(j,s-1).^2+dt(i,1,s)./kai(j,s-1).^2+sum(dt(i,2:j,s)./kai(j,s-1).^2);
            E_v(i,j,s) = besselk(p(i,j,s)+1,(C(i,j,s).*D(i,j,s)).^0.5)./besselk(p(i,j,s),(C(i,j,s).*D(i,j,s)).^0.5).*(C(i,j,s)./D(i,j,s)).^0.5;
            E_v_inv(i,j,s) = besselk(p(i,j,s)+1,(C(i,j,s).*D(i,j,s)).^0.5)./besselk(p(i,j,s),(C(i,j,s).*D(i,j,s)).^0.5).*(D(i,j,s)./C(i,j,s)).^0.5-2.*p(i,j,s)./C(i,j,s);
            kai_sub1(i,j,s) = sum(dX(i,2:j,s).^2./dt(i,2:j,s));
            kai_sub2(i,j,s) = sum(dt(i,2:j,s));
            kai_sub3(i,j,s) = sum(dX(i,2:j,s));
        end
        % M-step
        alpha(j,s) = sum(E_v(1:n,j,s))./n;
        beta(j,s) = 1./(sum(E_v_inv(1:n,j,s))./n-1./alpha(j,s));
        phi(j,s) = (sum(E_v_inv(1:n,j,s).*dX(1:n,1,s)./dt(1:n,1,s))-n)./sum(E_v_inv(1:n,j,s)./dt(1:n,1,s));
        kai(j,s) = (sum(E_v_inv(1:n,j,s).*(dX(1:n,1,s)-phi(j,s)).^2./dt(1:n,1,s)+E_v(1:n,j,s).*dt(1:n,1,s)-2.*(dX(1:n,1,s)-phi(j,s))+...
            E_v_inv(1:n,j,s).*kai_sub1(1:n,j,s)+E_v(1:n,j,s).*kai_sub2(1:n,j,s)-2.*kai_sub3(1:n,j,s))./(n.*j)).^0.5;
        f = @(x)n.*j.*log(sum(E_v_inv(1:n,j,s).*(dX(1:n,1,s)-phi(j,s)).^2./(x+t(1:n,1))+E_v(1:n,j,s).*(x+t(1:n,1))-2.*(dX(1:n,1,s)-phi(j,s))+...
            E_v_inv(1:n,j,s).*kai_sub1(1:n,j,s)+E_v(1:n,j,s).*kai_sub2(1:n,j,s)-2.*kai_sub3(1:n,j,s))./(n.*j))+sum(log(x+t(1:n,1)));
        [x,fval] = fminsearch(f,[tau(j,s-1)]);
        tau(j,s) = x;
        phi(j,s) = (sum(E_v_inv(1:n,j,s).*dX(1:n,1,s)./(tau(j,s)+t(1:n,1)))-n)./sum(E_v_inv(1:n,j,s)./(tau(j,s)+t(1:n,1)));
        kai(j,s) = (sum(E_v_inv(1:n,j,s).*(dX(1:n,1,s)-phi(j,s)).^2./(tau(j,s)+t(1:n,1))+E_v(1:n,j,s).*(tau(j,s)+t(1:n,1))-2.*(dX(1:n,1,s)-phi(j,s))+...
            E_v_inv(1:n,j,s).*kai_sub1(1:n,j,s)+E_v(1:n,j,s).*kai_sub2(1:n,j,s)-2.*kai_sub3(1:n,j,s))./(n.*j)).^0.5;
    end
    Alpha(j)=alpha(j,s);
    Beta(j)=beta(j,s);
    Phi(j)=phi(j,s);
    Kai(j)=kai(j,s);
    Tau(j)=tau(j,s);
    T(j)=t(i,j);
end

markersize = 2;

figure;
ha = tight_subplot(1,5,[.06 .06],[.15 .1],[.08 .02]);
axes(ha(1));
plot(alpha(end,:),'-*','markersize',markersize);hold on;
xlabel('Number of iterations','fontsize',10);
ylabel('Estimates','fontsize',10);
title('\alpha','fontsize',10);

axes(ha(2));
plot(beta(end,:),'-*','markersize',markersize);hold on;
xlabel('Number of iterations','fontsize',10);
ylabel('Estimates','fontsize',10);
title('\beta','fontsize',10);

axes(ha(3));
plot(phi(end,:),'-*','markersize',markersize);hold on;
xlabel('Number of iterations','fontsize',10);
ylabel('Estimates','fontsize',10);
title('\phi','fontsize',10);

axes(ha(4));
plot(kai(end,:),'-*','markersize',markersize);hold on;
xlabel('Number of iterations','fontsize',10);
ylabel('Estimates','fontsize',10);
title('\kappa','fontsize',10);

axes(ha(5));
plot(tau(end,:),'-*','markersize',markersize);hold on;
xlabel('Number of iterations','fontsize',10);
ylabel('Estimates','fontsize',10);
title('\tau','fontsize',10);

set(gcf,'unit','centimeters','position',[4 4 20 6]);
