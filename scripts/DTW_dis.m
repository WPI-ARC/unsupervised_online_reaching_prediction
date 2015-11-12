function [ dis ] = DTW_dis( traj1,traj2,w )
% Compute dynamic time wrapping distance of two given trajectories
if nargin<3
   w = Inf; 
end

n = size(traj1,1);
m = size(traj2,1);
w = max([w,abs(n-m)]);

DTW = zeros(n+1,m+1) +Inf;
DTW(1,1) = 0;

for ind_i = 2:1:n+1
   for ind_j = max(2,ind_i - w):1:min(m+1,ind_i+w) 
       cost = norm(traj1(ind_i-1,:)-traj2(ind_j-1,:));
       DTW(ind_i,ind_j) = cost + min([DTW(ind_i-1,ind_j),DTW(ind_i,ind_j-1),DTW(ind_i-1,ind_j-1)]);      
   end
end
dis = DTW(n+1,m+1);

end

