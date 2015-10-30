function[] = UOLA_learn(model_dir, traj_dir)
%%Desprition
%%%% Final version 2015 July 15
%%%% Copy Right: Ruikun Luo & ARC lab@ wpi
%%%% Release version 2015 Oct 20
%%%% 2layer framework learn function, update the model or build the model
%%%% Used for robot experiment

%% Load model and Parameters
load(model_dir)

%% Load Traj
traj = Read_Traj(traj_dir);

%% Get a new trajectory
num_total_traj = num_total_traj + 1;
traj_palm = traj(:,[1,end-2:end]);%%%%%last three dimensions are for palm
traj_joint = traj;

%% Classification Layer(First Layer) & model update&build:
if size(GMM_lib_palm,2) ~= 0
    %%%% loglike for current palm traj
    loglike_palm = class_traj_GMMlib( traj_palm', GMM_lib_palm );
    num_gmm_palm = size(GMM_lib_palm,2);
    %%%% calculate whole trajectory prior
    prior_gmm = [];
    if strcmp(prior_choice_palm,'uniform')
    %%%% calculate uniform prior
        prior_gmm = 1 / num_gmm_palm;
    elseif strcmp(prior_choice_palm,'ratio')
    %%%% calculate ratio prior
        for ind_gmm_time = 1:1:num_gmm_palm
           rate_num_traj = size(GMM_lib_palm{1,ind_gmm_time}.stat,1) / (num_total_traj-1);
           prior_gmm(ind_gmm_time) = prior_gmm_cal(rate_num_traj);
        end
        prior_gmm = prior_gmm/sum(prior_gmm);                        
    else
    %%%% calculate none prior(MLE)
        prior_gmm = 1;
    end 
    loglike_palm = loglike_palm + log(prior_gmm);
else
    loglike_palm = threshold_GMM_palm-100;
end

%% First layer whole trajectory classification & update model- Palm
if ~isempty(find(loglike_palm > threshold_GMM_palm))
    %%%% traj belongs to one of the palm GMM models in palm GMM Lib
    [max_value, predict_gmm] = max(loglike_palm);
    %%%% predict_gmm :  palm GMM index
    GMM_lib_palm{predict_gmm}.stat = ...
        [GMM_lib_palm{predict_gmm}.stat;...
        num_total_traj,loglike_palm(predict_gmm)];
    %%%% Update palm GMM parameter
    [GMM_lib_palm{1,predict_gmm}.prior,...
        GMM_lib_palm{1,predict_gmm}.mu,...
        GMM_lib_palm{1,predict_gmm}.sigma,...
        GMM_lib_palm{1,predict_gmm}.pix] = ...
            EM_update_directMethod(traj_palm',...
                GMM_lib_palm{1,predict_gmm}.prior,...
                GMM_lib_palm{1,predict_gmm}.mu,...
                GMM_lib_palm{1,predict_gmm}.sigma,...
                GMM_lib_palm{1,predict_gmm}.pix);           

    traj_len_old_avg = GMM_lib_palm{1,predict_gmm}.traj_len;
    num_traj_old = GMM_lib_palm{1,predict_gmm}.num_traj;
    GMM_lib_palm{1,predict_gmm}.traj_len = (traj_len_old_avg * num_traj_old +size(traj_palm,1)) / (num_traj_old+1);
    GMM_lib_palm{1,predict_gmm}.num_traj = GMM_lib_palm{1,predict_gmm}.num_traj + 1;

%% Second layer whole trajectory classification - Joint
    %%%% loglike for current joint traj
    num_gmm_joint = length(GMM_lib_joint{1,predict_gmm});
    loglike_joint = class_traj_GMMlib( traj_joint', GMM_lib_joint{1,predict_gmm} );            

    prior_gmm_joint = [];
    if strcmp(prior_choice_joint,'uniform')
    %%%% calculate uniform prior
        prior_gmm_joint = 1 / num_gmm_joint;
    elseif strcmp(prior_choice_joint,'ratio')
    %%%% calculate ratio prior
        for ind_gmm_time = 1:1:num_gmm_joint
           rate_num_traj = size(GMM_lib_joint{1, predict_gmm}{1,ind_gmm_time}.stat,1) / (num_total_traj-1);
           prior_gmm_joint(ind_gmm_time) = prior_gmm_cal(rate_num_traj);
        end
        prior_gmm_joint = prior_gmm_joint/sum(prior_gmm_joint);
    else
    %%%% calculate none prior(MLE)
        prior_gmm_joint = 1;
    end
    loglike_joint = loglike_joint + log(prior_gmm_joint);

    if ~isempty(find(loglike_joint > threshold_GMM_joint))
        %%%% predict_gmm_joint : joint GMM index
        [max_value, predict_gmm_joint] = max(loglike_joint);
        GMM_lib_joint{predict_gmm}{predict_gmm_joint}.stat = ...
            [GMM_lib_joint{predict_gmm}{predict_gmm_joint}.stat; ...
                num_total_traj,loglike_joint(predict_gmm_joint)];
            
        [GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.prior,...
            GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.mu,...
            GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.sigma,...
            GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.pix] = ...
                EM_update_directMethod(traj_joint',...
                    GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.prior,...
                    GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.mu,...
                    GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.sigma,...
                    GMM_lib_joint{1,predict_gmm}{predict_gmm_joint}.pix);
    else
%% Second layer build - add new GMM to joint Lib 
    %%%% Train new joint GMM in that palm GMM
        new_train_joint = [traj_joint];
        rand_traj_joint = random_traj(traj_joint, num_random_traj_joint, threshold_DTW_joint);
        for ind_rand = 1:1:length(rand_traj_joint)
            new_train_joint = [new_train_joint;rand_traj_joint{ind_rand}];
        end
        ind_new_joint_gmm = length(GMM_lib_joint{1,predict_gmm}) + 1;
        [GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.prior,...
            GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.mu,...
            GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.sigma] = ...
                EM_init_kmeans(new_train_joint',num_states_joint);

        [GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.prior,...
            GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.mu,...
            GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.sigma,...
            GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.pix] = ...
                EM_boundingCov(new_train_joint',...
                    GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.prior,...
                    GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.mu,...
                    GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.sigma);   

        GMM_lib_joint{1,predict_gmm}{ind_new_joint_gmm}.stat = [num_total_traj,-100000];
    end
else
    %% First layer build - add new GMM to palm Lib
    new_train_palm = [traj_palm];
    ind_new_GMM = size(GMM_lib_palm,2)+ 1;
    rand_traj_palm = random_traj(traj_palm,num_random_traj_palm,threshold_DTW_palm);

    for ind_rand = 1:1:length(rand_traj_palm)
       new_train_palm = [new_train_palm;rand_traj_palm{ind_rand}]; 
    end
    
    [GMM_lib_palm{1,ind_new_GMM}.prior,...
        GMM_lib_palm{1,ind_new_GMM}.mu,...
        GMM_lib_palm{1,ind_new_GMM}.sigma] = ...
            EM_init_kmeans(new_train_palm',num_states_palm);

    [GMM_lib_palm{1,ind_new_GMM}.prior,...
        GMM_lib_palm{1,ind_new_GMM}.mu,...
        GMM_lib_palm{1,ind_new_GMM}.sigma,...
        GMM_lib_palm{1,ind_new_GMM}.pix] = ...
            EM_boundingCov(new_train_palm',...
                GMM_lib_palm{1,ind_new_GMM}.prior,...
                GMM_lib_palm{1,ind_new_GMM}.mu,...
                GMM_lib_palm{1,ind_new_GMM}.sigma);   

    GMM_lib_palm{1,ind_new_GMM}.stat = [num_total_traj,-100000];
    GMM_lib_palm{1,ind_new_GMM}.num_traj = 1;
    GMM_lib_palm{1,ind_new_GMM}.traj_len = size(traj_palm,1);
    %% Second layer build - initial new GMM to joint Lib
    new_train_joint = [traj_joint];
    rand_traj_joint = random_traj(traj_joint, num_random_traj_joint, threshold_DTW_joint);
    for ind_rand = 1:1:length(rand_traj_joint)
        new_train_joint = [new_train_joint;rand_traj_joint{ind_rand}];
    end
    [GMM_lib_joint{1,ind_new_GMM}{1}.prior,...
        GMM_lib_joint{1,ind_new_GMM}{1}.mu,...
        GMM_lib_joint{1,ind_new_GMM}{1}.sigma] = ...
            EM_init_kmeans(new_train_joint',num_states_joint);

    [GMM_lib_joint{1,ind_new_GMM}{1}.prior,...
        GMM_lib_joint{1,ind_new_GMM}{1}.mu,...
        GMM_lib_joint{1,ind_new_GMM}{1}.sigma,...
        GMM_lib_joint{1,ind_new_GMM}{1}.pix] = ...
            EM_boundingCov(new_train_joint',...
                GMM_lib_joint{1,ind_new_GMM}{1}.prior,...
                GMM_lib_joint{1,ind_new_GMM}{1}.mu,...
                GMM_lib_joint{1,ind_new_GMM}{1}.sigma);   

    GMM_lib_joint{1,ind_new_GMM}{1}.stat = [num_total_traj,-100000];
end
save(model_dir,'GMM_lib_palm','GMM_lib_joint','num_total_traj',...
    'prior_choice_palm','prior_choice_joint','threshold_GMM_palm','threshold_GMM_joint',...
    'threshold_DTW_palm','threshold_DTW_joint','num_random_traj_palm','num_random_traj_joint',...
    'num_states_palm','num_states_joint');
end









