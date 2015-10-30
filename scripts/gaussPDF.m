function prob = gaussPDF(Data, Mu, Sigma)
%
% This function by me computes the Probability Density Function (PDF) of a
% multivariate Gaussian representedans and covariance matrix.
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Data:  D x N array representing N datapoints of D dimensions.
%   o Mu:    D x K array representing the centers of the K GMM components.
%   o Sigma: D x D x K array representing the covariance matrices of the 
%            K GMM components.
% Outputs ----------------------------------------------------------------
%   o prob:  1 x N array representing the probabilities for the 
%            N datapoints.     

% D = 7 
% N = 800
% K = 1

% disp('-----------------')
% size(Mu)
% size(Sigma)

[nbVar,nbData] = size(Data);

Data = Data' - repmat(Mu',nbData,1);

% Data

prob = sum((Data*inv(Sigma)).*Data, 2);
prob = exp(-0.5*prob) / sqrt((2*pi)^nbVar * (abs(det(Sigma))+realmin));

% size(prob)
