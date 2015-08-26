% TL_evolve: evolves a population of N individuals
% calls TL_dynamic_LS to get z with fitness values 
% v4: density-dependent FLS: an area around each individual is is decreased
% in fitness

tic;
close;

rand('state',sum(100*clock)); % new set of pseudorandom numbers

%N = 304;
i_kill = round(N/30);
%mu = 0.8; % per locus/trait mutation rate
i_updates = 60000;

if ~exist('a_pop', 'var')
    a_pop = zeros(N,5);
    for org = 1:N
        a_pop(org,1) = randi(20) + 70;
        a_pop(org,2) = randi(20) + 70;
    end;
    % centered on two peaks for survival of the flattest LS
    
    a_pop_dump = [];
    a_pop_stats = [];
    t_counter = 0; % trait-counter
    stat_counter = 0;
end;

if exist('u')
    u_old = u;
else
    u_old = 0;
    u = 0;
end;

N = length(a_pop(:,1));
fprintf('Population is N = %i. Per-trait mutation rate is mu = %1.4f.\n',N,mu);

TL_dynamic_LS; % recompute FLS

% compute fitness
for n = 1:N
    a_pop(n,3) = z(a_pop(n,1),a_pop(n,2));
end;

% EVOLVE
for u = 1+u_old:i_updates+u_old
    % kill
    a_killed = randi(N,[i_kill,1]);
    a_pop(a_killed,:) = [];

    % replicate according to fitness
    i_repped = 0;
    b_rep = true;
    while b_rep
        i_new = randi(length(a_pop(:,1)));
        max_fit = max(a_pop(:,3));
        if rand() <= z(a_pop(i_new,1),a_pop(i_new,2))/max_fit;
            i_repped = i_repped + 1;
            a_pop = vertcat(a_pop,a_pop(i_new,:));
        end;
        if i_repped >= i_kill; b_rep = false; end; % determines when to stop
    
        % mutate
        if rand() <= mu
            a_pop(i_new,1) = sign(rand()-0.5)*1+a_pop(i_new,1);
            a_pop(i_new,4) = a_pop(i_new,4) + 1; % count number of mutations
        end;
        if rand() <= mu
            a_pop(i_new,2) = sign(rand()-0.5)*1+a_pop(i_new,2);
            a_pop(i_new,5) = a_pop(i_new,5) + 1; % count number of mutations
        end;
    end;% end while

    TL_dynamic_LS; % recompute FLS

    % compute fitness
    for n = 1:N
        a_pop(n,3) = z(a_pop(n,1),a_pop(n,2));
    end;
    
%     a_pop_dump = vertcat(a_pop_dump,a_pop);

    if mod(u,20)==0 && 1
        
        stat_counter = stat_counter + 1;
        selcoef = max(a_pop(:,3))/min(a_pop(:,3))-1;
        pop_std = sqrt(std(a_pop(:,1))*std(a_pop(:,2)));
        a_pop_stats(stat_counter,1) = u;
        a_pop_stats(stat_counter,2) = pop_std;

        figure(1);
        clf;
        TL_plot; % plot surface
        hold on;
        plot3(a_pop(:,2),a_pop(:,1),a_pop(:,3),'ow','markersize',4,'markerfacecolor','w','markeredgecolor','k'); % notice which is x and which is y !!!
        %title(strcat('Update = ',num2str(u),', ff = ',num2str(fluc_factor)));
        title(strcat('Update = ',num2str(u),', ff = '));
        drawnow;
        save_plot_for_movie;

        fprintf('update = %i, s = %1.3f, std = %1.2f\n',u,selcoef,pop_std);
        t_counter = t_counter + 1;
        a_trait(t_counter,1) = u;
        a_trait(t_counter,2) = mean(a_pop(:,1));
        a_trait(t_counter,3) = mean(a_pop(:,2));
        a_trait(t_counter,4) = selcoef;
    end;

end; % end updates

