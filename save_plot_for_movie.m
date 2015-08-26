% Saves plot to tiff for movie

time_id = datestr(now,'yyyymmddHHMMSSFFF');
% exportfig(gcf,strcat('figs_for_movie_HOLEY_N23040_mu0.05/TL_mutations_',time_id,'.tiff'),'bounds','tight','format','tiff','Color', 'rgb','height',7);
% exportfig(gcf,strcat('figs_for_movie_Gmatrix_N2304_mu0.05/TL_mutations_',time_id,'.tiff'),'bounds','tight','format','tiff','Color', 'rgb','height',7);
exportfig(gcf,strcat('movie_pics/largeTL_',time_id,'.png'),'bounds','tight','format','png','Color', 'rgb','height',16);
