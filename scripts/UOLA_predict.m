function[] = UOLA_predict(model_dir,readDir,writeDir)
%%%% Version 1.1.0
%%%% Copy Right: Ruikun Luo & ARC lab@ wpi
%%%% Release Date 2015 Oct 22
%%%% 2layer framework prediction function
%%%% Used for robot experiment
%% Load model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(model_dir)
%% Load Traj
traj = Read_Traj(readDir);
%% get a new trajectory
traj_palm = traj(:,[1,end-2:end]);%%%%%last three dimensions are for palm
traj_joint = traj;
num_feature_joint = size(traj_joint,2);

%% Prediction:
%% first layer part trajectory classicifation - Palm
if num_total_traj>=1
    traj_len = size(traj_palm,1);
    num_gmm_palm = size(GMM_lib_palm,2);
    loglike_palm_p = class_traj_GMMlib( traj_palm', GMM_lib_palm );
    %%%% calculate part trajectory prior
    prior_gmm_p = [];
    if strcmp(prior_choice_palm,'uniform')
    %%%% calculate uniform prior
        prior_gmm_p = 1 / num_gmm_palm;
    elseif strcmp(prior_choice_palm,'ratio')
    %%%% calculate ratio prior
        for ind_gmm_time = 1:1:num_gmm_palm
           rate_num_traj = size(GMM_lib_palm{1,ind_gmm_time}.stat,1) / num_total_traj;
           prior_gmm_p(ind_gmm_time) = prior_gmm_cal(rate_num_traj);
        end
        prior_gmm_p = prior_gmm_p/sum(prior_gmm_p);                            
    else
    %%%% calculate none prior(MLE)
        prior_gmm_p = 1;
    end
    
    loglike_palm_p = loglike_palm_p + log(prior_gmm_p);
    [max_value,predict_gmm_p] = max(loglike_palm_p);
    
%% Second layer part trajectory classification - Joint                
    traj_len_old_avg = floor(GMM_lib_palm{1,predict_gmm_p}.traj_len);
    loglike_joint_p = class_traj_GMMlib( traj_joint',GMM_lib_joint{1, predict_gmm_p});
    num_gmm_joint = size(GMM_lib_joint{1, predict_gmm_p},2);
    prior_gmm_joint_p = [];
    if strcmp(prior_choice_joint,'uniform')
    %%%% calculate uniform prior
        prior_gmm_joint_p = 1 / num_gmm_joint;
    elseif strcmp(prior_choice_joint,'ratio')
    %%%% calculate ratio prior
        for ind_gmm_time = 1:1:num_gmm_joint
           rate_num_traj = size(GMM_lib_joint{1, predict_gmm_p}{1,ind_gmm_time}.stat,1) / num_total_traj;
           prior_gmm_joint_p(ind_gmm_time) = prior_gmm_cal(rate_num_traj);
        end
        prior_gmm_joint_p = prior_gmm_joint_p/sum(prior_gmm_joint_p);                                
    else
    %%%% calculate none prior(MLE)
        prior_gmm_joint_p = 1;
    end
    loglike_joint_p = loglike_joint_p + log(prior_gmm_joint_p);

    [max_value,predict_gmm_p_joint] = max(loglike_joint_p);
    if traj_len < traj_len_old_avg
        expData = [];
        expData(1,:) = traj_len:1:traj_len_old_avg;
        [expData(2:num_feature_joint,:), expSigma] = GMR( ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.prior, ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.mu, ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.sigma, ...
            expData(1,:), [1], [2:num_feature_joint]);
        expData = expData';
        expData = smooth_predict_traj( traj_joint,expData );%%%%%%%%only predicted trajectory
        csvwrite(writeDir,expData);
    else
        %%%%if the given trajectory length is longer than the average,
        %%%%predict next 10 frames
        disp('the average length is smaller than the observed one')
        expData = [];
        expData(1,:) = traj_len:1:traj_len+10;
        [expData(2:num_feature_joint,:), expSigma] = GMR( ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.prior, ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.mu, ...
            GMM_lib_joint{1,predict_gmm_p}{predict_gmm_p_joint}.sigma, ...
            expData(1,:), [1], [2:num_feature_joint]);
        expData = expData';
        expData = smooth_predict_traj( traj_joint,expData );%%%%%%%%only predicted trajectory
        csvwrite(writeDir,expData);
    end
else
    disp('First Trajectory cannot be predicted')
    expData = [];
    csvwrite(writeDir,expData);
end
end









