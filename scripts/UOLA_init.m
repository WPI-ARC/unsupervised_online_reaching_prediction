function[] = UOLA_init(model_dir)
%%%% Version 1.1.0
%%%% Copy Right: Ruikun Luo & ARC lab@ wpi
%%%% Release Date 2015 Oct 22
%%%% 2layer framework init function, to initilize the model
%%%% Used for robot experiment

%% Initialize

GMM_lib_palm = [];
GMM_lib_joint = [];
num_total_traj = 0;
%% Save model
setup = textread('./setup.txt','%s','delimiter','\n');
model_directory = setup{2};
prior_choice_palm = setup{5};
prior_choice_joint = setup{7};
threshold_GMM_palm = log(realmin) + str2num(setup{10});
threshold_GMM_joint = log(realmin) + str2num(setup{12});
threshold_DTW_palm = str2num(setup{14});
threshold_DTW_joint = str2num(setup{16});
num_random_traj_palm = str2num(setup{18});
num_random_traj_joint = str2num(setup{20});
num_states_palm = str2num(setup{22});
num_states_joint = str2num(setup{24});



save(model_dir,'GMM_lib_palm','GMM_lib_joint','num_total_traj',...
    'prior_choice_palm','prior_choice_joint','threshold_GMM_palm','threshold_GMM_joint',...
    'threshold_DTW_palm','threshold_DTW_joint','num_random_traj_palm','num_random_traj_joint',...
    'num_states_palm','num_states_joint');

end









