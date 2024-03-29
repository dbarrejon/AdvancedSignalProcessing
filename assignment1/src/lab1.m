 close all; clear all clc;

% data processing
load('LDAdata.mat');


%% SETUP
K = 5;
max_iter = 100;
n_init = 5;
epsilon = 1e-3;
MAP = false; 
debug = false;

print_setup(MAP,max_iter,n_init,epsilon)

%% Create Folder for ML and MAP Inference

if MAP
  img_folder = './images/MAP';
  if exist('./images/MAP','dir') ~= 7, mkdir(img_folder), end
else
  img_folder = './images/ML';
  if exist('./images/ML','dir') ~= 7, mkdir(img_folder), end  
end


%%  BAG OF WORDS - mu: (Term Frequency Matrix)
fprintf('Computing Term Frequency Matrix...\n')
N = length(LDAdata); % number of documents
I = length(dictionary); % number of categories
mu = tf_matrix_computer(LDAdata,dictionary);
fprintf('Done!')
% TODO: BIC CRITERION FOR K SELECTION

%% LISTS FOR DIFFERENT k
pi_opt_k = cell(1,K-1);
theta_opt_k = cell(1,K-1);
Q_opt_k = cell(1,K-1);
r_opt_k = cell(1,K-1);
labels_opt_k = cell(1,K-1);
ll_opt_k = zeros(1,K-1);
aic_list = zeros(1,K-1);
bic_list = zeros(1,K-1);

for k = 2:K
    
    %% LISTS
    pi_cells = cell(1,n_init);
    theta_cells = cell(1,n_init);
    Q_cells = cell(1,n_init);
    r_cells = cell(1,n_init);
    labels_cells = cell(1,n_init);
    ll = zeros(1,n_init);
    
    for i = 1:1:n_init

        fprintf('------------------------------- \n');
        fprintf('Initialization %d\n',i);    
        % initialization
        [pi,theta,prior] = initialization(k,I,MAP);
        fprintf('Done! %d\n',i);

        % EM
        fprintf('------------------------------- \n');
        fprintf('Running EM\n');

        [Q_cells{i},pi_cells{i},theta_cells{i},r_cells{i},labels_cells{i}] = ...
                                  EM(k,N,I,pi,theta,prior,mu,epsilon,max_iter,MAP);
        ll(i) = Q_cells{i}(end);
    end
    
    % Obtain optimal for initializations 
    [ll_opt_k(k-1), idx_opt] = max(ll);
    pi_opt_k{k-1} = pi_cells{idx_opt};
    theta_opt_k{k-1}  = theta_cells{idx_opt};
    r_opt_k{k-1} = r_cells{idx_opt};
    labels_opt_k{k-1} = labels_cells{idx_opt};
    Q_opt_k{k-1} = Q_cells{idx_opt};
    [aic_list(k-1), bic_list(k-1)] = model_selection(ll_opt_k(k-1),k,I,N);
    
    % Plot Q
    fprintf('------------------------------- \n');
    fprintf('Plotting Q: \n');
    plot_Q(Q_opt_k{k-1},k,MAP)
    fprintf('Done!\n');
    
    % Visualize R
    fprintf('------------------------------- \n');
    fprintf('Visualize R: \n');
    visualize_R(r_opt_k{k-1},k,MAP)
    fprintf('Done!\n'); 
    
    % Visualize theta
%     fprintf('------------------------------- \n');
%     fprintf('Visualize theta: \n');
%     visualize_theta(theta_opt_k{k},k,MAP)
%     fprintf('Done!\n'); 
    
    % Word Cloud
    fprintf('------------------------------- \n');
    fprintf('Visualize Word Cloud: \n');
    create_wordcloud(k,dictionary,mu,labels_opt_k{k-1},MAP)
    fprintf('Done!\n');     
    
    
end


%% Plot BIC

figure
plot(2:K,bic_list,'LineWidth',0.2)
title('Bic Model Criterion','Interpreter','latex')
xlabel('K','Interpreter','latex')
ylabel('BIC', 'Interpreter','latex')
xticks(2:k)
labels = string(2:k);
xticklabels(labels);
if MAP
    saveas(gcf,sprintf('./images/MAP/BIC_MAP.png'))
else
    saveas(gcf,sprintf('./images/ML/BIC_ML.png'))
end

% Plot LL increasing with K
figure
plot(2:K,ll_opt_k,'LineWidth',0.2)
title('Log-likelihood w.r.t $K$','Interpreter','latex')
xlabel('$K$','Interpreter','latex')
xticks(1:k)
labels = string(1:k);
xticklabels(labels);
if MAP
    saveas(gcf,sprintf('./images/MAP/ll_MAP.png'))
else
    saveas(gcf,sprintf('./images/ML/ll_ML.png'))
end



close all;






