%evolve_v1 configured from settings.txt, select fitness landscape and plots
%


%Structure of the variables. Called with 'variables.VARIABLE_NAME{1}'
variables = struct();

%Array of names, and length of array.
names_array = {'N','mu1','mu2','updates','killed_on_update','asexual','mut_effect','plot_image','save_image'};
default_array = {2000, 0.05, 0.05, 50000, 200, 1, 0.05, 1, 0, 0};
name_counter = length(names_array);

% new set of pseudorandom numbers
rand('state',sum(100*clock));

fileID = fopen('settings.txt');

%Default values, in case no settings file.
if(fileID == -1)
   
    for j = 1:name_counter
        variables.(char(names_array(j))) = default_array(j);

       %Prints default values for user.
       fprintf(names_array{j} + ' = ' + variables.(char(names_array(j))))
   end
  
else
    %Reads through settings.txt and sets variables.
    while ~feof(fileID)
    tline = fgetl(fileID);
    
    if(tline ~=-1)
       
        if(tline(1) ~= 35 && ~(tline(1) >= 48 && tline(1) <= 57))
            name_counter = name_counter + 1;
            names_array{name_counter} = tline(1:length(tline)-1);
            
            tline = fgetl(fileID);

            variables.(char(names_array(name_counter)))= textscan(tline, '%f');
                
        
        end
        
    end
    

    end
end


fclose(fileID);

break;


%Catching errors in settings.txt file
 if variables.killed_on_update{1} > variables.N{1}
     error('# organisms killed must be less than starting # organisms')
 end


%Sets Nx5 population array
 a_pop = zeros(variables.N{1},5);
    for org = 1:variables.N{1}
        a_pop(org,1) = randi(20) + 70;
        a_pop(org,2) = randi(20) + 70;
    end;
    
    a_pop_dump = [];
    a_pop_stats = zeros(ceil(variables.updates{1}/20), 2);
    a_trait = zeros(ceil(variables.updates{1}/20), 4);
    t_counter = 0; % trait-counter
    stat_counter = 0;
    
%Set u and u_old
if exist('u', 'var')
    u_old = u;
else
    u_old = 0;
    u = 0;
end;
    
    
    
 %Opens a fitness landscape if there is one.
 fileName = uigetfile('.txt','Choose a fitness landscape.');
 if(fileName == 0)
     p = [1.2 0.5 1 1.2 0.5 1;1 0.2 1 1 0.7 1];
 else 
    p = dlmread(fileName,' ');
 end
 
    
 TL_Evolve_V1;
 
 % compute fitness
for n = 1:variables.N{1}
    a_pop(n,3) = z(a_pop(n,1),a_pop(n,2));
end;



% EVOLVE
for u = 1+u_old:variables.updates{1}+u_old
    % kill
    a_killed = randi(variables.N{1},[variables.killed_on_update{1},1]);
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
        if i_repped >= variables.killed_on_update{1}; b_rep = false; end; % determines when to stop
    
        % mutate X
        if rand() <= variables.mu1{1}
            a_pop(i_new,1) = sign(rand()-0.5)*1+a_pop(i_new,1);
            a_pop(i_new,4) = a_pop(i_new,4) + 1; % count number of mutations
        end;
        
        %mutate Y
        if rand() <= variables.mu2{1}
            a_pop(i_new,2) = sign(rand()-0.5)*1+a_pop(i_new,2);
            a_pop(i_new,5) = a_pop(i_new,5) + 1; % count number of mutations
        end;
    end;% end while

    TL_Evolve_V1; % recompute FLS

    % compute fitness
    for n = 1:variables.N{1}
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