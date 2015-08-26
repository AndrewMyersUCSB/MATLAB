% TL_plot: plots two-locus surface

% colormap(gray);
% colormap(hsv);
colormap(jet);
% colormap(winter);

% colormap(1:40,1) = (0:39)/39;
% colormap(1:40,2) = (0:39)/39;
% colormap(1:40,3) = (0:39)/39;
% colormap(41:64,1) = 1;
% colormap(41:64,2) = 1;
% colormap(41:64,3) = 1;

% colormap(1:64,1:3) = 0;
% colormap(1:64,3) = (1:64)/64;

% contour(z);
surface(z);
axis([0 xmax/step+5 0 xmax/step+5 0 .15]);

set(gcf,'position',[1 800 1200 1200]);

grid off;
axis off;
set(gcf,'color','k');
set(gca,'color','k');
shading interp;

drawnow;