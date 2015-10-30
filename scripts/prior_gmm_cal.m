function [ y ] = prior_gmm_cal(x)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% if x == 1||x==0
%    y = realmin; 
% else
%    alpha = 0.5;
%    beta_f = 0.5;
%    x = x*0.99+0.005;
%    y = 4.52-x^(alpha - 1) * (1-x)^(beta_f-1) /beta(alpha,beta_f);
% end
y = atan(x * 10) / atan(10);
end

