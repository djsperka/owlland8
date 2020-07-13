function h_out=CorrMap(x,y,chan1,chan2,resp_cell)
global snd
%calculate the stimulus-position specific noise correlations and display
%them
%x and y should be the same dimensions, with the first dimension being
%reps, the second dimension being var1 positions, and the 3rd dimension
%being var2 dimensions

twoD_map=NaN(size(x,2), size(x,3));
n1_mean=squeeze(mean(resp_cell{chan1}));
n1_mean=n1_mean/(max(max(n1_mean)));
n2_mean=squeeze(mean(resp_cell{chan2}));
n2_mean=n2_mean/(max(max(n2_mean)));

for i=1:size(x,3) %for each var2 dimension
    twoD_map(:,i)=diag(corr(x(:,:,i),y(:,:,i))); %for a n-by-p matrix (ie 
%reps-by-var1positions), corr generates a p-by-p matrix of correlation
%values by correlation the reps for each var1 position.  In this case, the
%p-by-p matrix will be full pairwise comparison between all var1 positions.
% We only want the cases of var1 positions correlated with eachother, which
% occurs along the diagonal of the correlation matrix
end
%this should build a (length(var1) , length(var2)) matrix

twoD_map=twoD_map'; %transpose the map to make it match the visual field
n1_mean=n1_mean';
n2_mean=n2_mean';
h_out=figure;%('visible','off');
contourf(snd.Var1array,snd.Var2array,twoD_map,100);       %%show contour plot of one Channel
colorbar;       %%show a reference bar for the contour plot
h=get(gca,'children');
set(h,'linestyle','none');
hold 
contour(snd.Var1array,snd.Var2array,twoD_map,1e-10,'--w','LineWidth',2)
%add space-map contours
contour(snd.Var1array,snd.Var2array,n1_mean,[.3 .5 .7,.9],'k','LineWidth',2,'ShowText','on')
contour(snd.Var1array,snd.Var2array,n2_mean,[.3 .5 .7 .9],':k','LineWidth',3,'ShowText','on')
caxis([-1 1])
xlabel(snd.Var1_choices(snd.Var1));
ylabel(snd.Var2_choices(snd.Var2));
set(get(gca,'xlabel'),'fontsize',14);
set(get(gca,'ylabel'),'fontsize',14);





