function [ y ] = prior_gmm_cal(x)
%ratio prior function
y = atan(x * 10) / atan(10);
end

