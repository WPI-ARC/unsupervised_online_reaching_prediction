function [ traj ] = Read_Traj(dir)
%Read Trajectory from path
%In case the input is from raw input, feature selection might be required
%feature_selection need to be clear!!!!
% feature_selection = [1:19 ];
data = csvread(dir);
num_frame = size(data,1);
t = 1:1:num_frame;
data = [t' data];
% traj = data(:,feature_selection);
traj = data;
end

