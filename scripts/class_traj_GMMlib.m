function loglike = class_traj_GMMlib( Traj, GMM_lib )
%%%% Traj = D*N, D is the feature dimension
%%%% classify a given trajectory. use the whole trajectory
num_class = length(GMM_lib);
num_length = size(Traj,2);
loglike = zeros(1,num_class);
    for ind_class = 1:1:num_class
       %%%% calculate for each class
       prior = GMM_lib{ind_class}.prior;
       mu = GMM_lib{ind_class}.mu;
       sigma = GMM_lib{ind_class}.sigma;
       num_states = size(prior,2);
       Pxi = zeros(num_length,num_states);
       for ind_state = 1:1:num_states
           Pxi(:,ind_state) = gaussPDF(Traj, mu(:,ind_state),sigma(:,:,ind_state));
       end
       
       F = Pxi * prior';
       F(find(F<realmin)) = realmin;
       loglike(1,ind_class) = mean(log(F));
    end
end


