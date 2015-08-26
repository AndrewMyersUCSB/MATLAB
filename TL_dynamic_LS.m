% TL_dynamic_LS: defines fitness landscape
% Called by TL_evolve_v4_dynamic.m
% Called by TL_evolve_v5_varpop.m

minz = 0.08;
xmax = 20;
step = .1;
x = -xmax/2:step:xmax/2;
z = x'*x*0;

z = z + minz+0.02; % neutral landscape

%% Static landscape
p = [1.2 0.5 1 1.2 0.5 1;1 0.2 1 1 0.7 1]; % two peaks
%p = [0.9 0.9 1.2 0.9 0.4 1.2;1.1 0.2 1.2 1.1 0.8 1.2]; % two peaks up north (for G-matrix)
%p = [1 0.6 1 1 0.2 1;1 0.2 1 1 0.6 1;1 0.6 1 1 0.6 1]; % three peaks
for i = 1:length(p(:,1));
    fx = 0.2*p(i,1)*exp(-(x-(p(i,2)-.5)*(xmax-5)).^2/(2*(2*p(i,3))^2));
    fy = .18*p(i,4)*exp(-(x-(p(i,5)-.5)*(xmax-5)).^2/(2*(2*p(i,6))^2));
    z = z + fx'*fy;
end;

%% Density-dependent landscape (needs static LS above)
depression = 1e-4; % use dep = 0 for static LS
area = 3;
for org = 1:N
    
    
   
    z(a_pop(org,1)-area:a_pop(org,1)+area,a_pop(org,2)-area:a_pop(org,2)+area) = z(a_pop(org,1)-area:a_pop(org,1)+area,a_pop(org,2)-area:a_pop(org,2)+area) - depression;
    z = max(z,minz);
end;

%% Dynamic (fluctuating) landscape
% fluc_factor = max(2000,4000-max((u-20e3)/9,0));
% fluc_factor = 500;
% p = [(1+cos(u/fluc_factor*pi))/2 0.7 1 1 0.4 1; (1-cos(u/fluc_factor*pi))/2 0.4 1 1 0.7 1]; % two fluctuating peaks
% % p = [(1-cos(pi))/2 0.75 1 1 0.25 1; (1+cos(u/3*pi))/2 0.25 1 1 0.75 1]; % two fluctuating peaks
% for i = 1:length(p(:,1));
%     fx = .18*p(i,1)*exp(-(x-(p(i,2)-.5)*(xmax-5)).^2/(2*(2*p(i,3))^2));
%     fy = .18*p(i,4)*exp(-(x-(p(i,5)-.5)*(xmax-5)).^2/(2*(2*p(i,6))^2));
%     z = z + fx'*fy;
% end;

%% Survival of the flattest landscape
% p = [1. 0.4 .15 1. 0.4 .15; .9 0.4 3 .9 0.4 3]; % two peaks
% p = [1. 0.4 .051 1. 0.3 .051; .95 0.2 3 .95 0.4 3]; % one peak
% for i = 1:length(p(:,1));
%     fx = .18*p(i,1)*exp(-(x-(p(i,2)-.5)*(xmax-5)).^2/(2*(2*p(i,3))^2));
%     fy = .18*p(i,4)*exp(-(x-(p(i,5)-.5)*(xmax-5)).^2/(2*(2*p(i,6))^2));
%     z = z + fx'*fy;
% end;

