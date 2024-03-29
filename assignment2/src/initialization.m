function [pi,theta,A] = initialization(K,I)
%INITIALIZATION Summary of this function goes here
%   Detailed explanation goes here

% K number of mixture components
% epsilon: Tolerance value for convergence.

% Parameter Initialization
fprintf('Initializing parameters\n');

% if MAP
%     
%     % TODO: CHOOSE APPROPRIATE VALUES ALPHA, BETA
%     
%     % Prior on pi
%     beta = rand(1,K) + rand(1,K);
%     beta = 2*ones(1,K);
%     pi = drchrnd(beta,1);
%     
%     % Prior on alpha
%     alpha = rand(1,I) + rand(1,I);
%     alpha = 2*ones(1,I);
%     theta= drchrnd(alpha,K);
%     
%     prior.alpha = alpha;
%     prior.beta = beta;
%     
% else
    
% pi
pi = rand(K,1);
pi = pi/sum(pi); % probabilities of the mixture components

% theta = B: emission probabilities 
theta = rand([K,I]); 
theta = theta./sum(theta,2); % probabilities of the categories

% A: transition probabilities
A = rand(K);
A = A./sum(A,2);
% end

end

