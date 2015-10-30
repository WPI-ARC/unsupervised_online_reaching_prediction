function [ traj_opt ] = random_traj( traj , K,dis_threshold)%num_traj)
%Implemented by Ruikun Luo
%Basic idea is from STOMP paper, only generate multiple random traj
%traj = N * D, where N is the traj length, D is the traj dimension

%% Precompute part
%%%% A, R_1, M
%%%% N: traj length, M: traj dimension
N = size(traj,1);
D = size(traj,2);

A = eye(N);
x = eye(N-1)*-2;
x = [zeros(1,N);x zeros(N-1,1)];
A = A + x;
x = eye(N-2);
x = [zeros(2,N);x zeros(N-2,2)];
A = A + x;
A = [A; zeros(1,N-2) 1 -2;zeros(1,N-1) 1 ];
R_1 = inv(A'*A);
R = A'*A;
y = max(R_1,[],1);
y = repmat(y, N,1);
M = R_1 ./ y *(1/N);

%% generate traj
%%%% loop for each dimension, ignore the first dimension because it is the
%%%% time index
for ind_D = 1:1:K
    theta = traj(:,2:end);
    theta_k = mvnrnd(zeros(N,1),R_1,D-1)';
    test_traj = theta + theta_k;
    while DTW_dis(test_traj,theta,3)>dis_threshold
        theta_k = M * theta_k;
        test_traj = theta + theta_k;
    end
    traj_opt{ind_D} = traj + [zeros(N,1) theta_k];
end

end

