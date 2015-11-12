function [ exp ] = smooth_predict_traj( traj_p, predict_traj )
%  Smooth and normalize the predicted trajectory
num_len = size(predict_traj,1);

start_traj = predict_traj(1,2:end);
end_traj = traj_p(end,2:end);
exp = predict_traj;
exp(:,2:end) = exp(:,2:end) - repmat(start_traj,[num_len,1]) + repmat(end_traj,[num_len,1]);

end

