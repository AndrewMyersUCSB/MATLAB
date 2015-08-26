% TL_Evlove_V1: defines fitness landscape
%Called by evolve_v1


minz = 0.08;
xmax = 20;
step = .1;
x = -xmax/2:step:xmax/2;
z = x'*x*0;
z = z + minz+0.02; % neutral landscape

for i = 1:length(p(:,1));
    fx = 0.2*p(i,1)*exp(-(x-(p(i,2)-.5)*(xmax-5)).^2/(2*(2*p(i,3))^2));
    fy = .18*p(i,4)*exp(-(x-(p(i,5)-.5)*(xmax-5)).^2/(2*(2*p(i,6))^2));
    z = z + fx'*fy;
end;

%% Density-dependent landscape (needs static LS above)
depression = 1e-4; % use dep = 0 for static LS
area = 3;
for org = 1:variables.N{1}
    z(a_pop(org,1)-area:a_pop(org,1)+area,a_pop(org,2)-area:a_pop(org,2)+area) = z(a_pop(org,1)-area:a_pop(org,1)+area,a_pop(org,2)-area:a_pop(org,2)+area) - depression;
    z = max(z,minz);
end;


