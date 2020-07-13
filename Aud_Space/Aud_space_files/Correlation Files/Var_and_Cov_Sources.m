function Var_and_Cov_Sources(handles)
global site_cell

[save_figs,mod_script]=BImodal_Integration_Start();

if mod_script
    dbstack
    keyboard
end

show_shuffle_independence=0;

set(handles.rrc_vwi,'Value',1);
set(handles.rrc_ai,'Value',1);
set(handles.rrc_vwo,'Value',0);
set(handles.rrc_ao,'Value',0);
set(handles.rrc_vwi_and_vwo,'Value',0);
set(handles.rrc_as,'Value',0);

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask

start_cd=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
if save_figs
    save_cd=uigetdir;
end
cd(start_cd);

% Function Controls
n_shuff=100; % how many times do you want to shuffle unimodal responses?

% Figure Dimensions
notes_x_width=4; notes_y_width=3.5;
poster_x_width=2.5 ;poster_y_width=2;
rez='300'; %DPI ... needs to be a string

% Data colors and sizes
lincols=linspecer(2);
unity_width=1;
regression_width=1.5;
dotsize=4;

% Initialize population assembly vectors
pop_bim_resp=[]; %these are baseline subtracted, to be used for the response analysis
pop_sum_resp=[];

pop_vis_post=[];
pop_aud_post=[];
pop_bim_post=[]; %these are post-period only, to be used for the fano and NCs
pop_sum_post=[];

pop_aud_var=[];
pop_vis_var=[];
pop_bim_var=[];
pop_sum_var=[];

pop_aud_cov=[];
pop_vis_cov=[];
pop_bim_cov=[];
pop_sum_cov=[];
source_indx=[];

%%% Sum without shuffling
pop_sum_var_NS=[];
pop_sum_cov_NS=[];

total_cell_count=0;

for i=1:length(site_cell);
        site=site_cell{i};
        
        %find the correct columnd of your multitrace data
        vis_ind=strcmp(site.id_mt_labels,'Vw_I  ');
        aud_ind=strcmp(site.id_mt_labels,'A_I  ');
        bim_ind=strcmp(site.id_mt_labels,'A_I  Vw_I');
        
        if sum(bim_ind)~=0 % If there was bimodal data we will use this site
            site_dome=dome_cell{1,i};
            num_cells=sum(site_dome);     
            
            % grab the baseline-subtracted responses for each cell
            site_resp=site.id_mt_data.resp_cell(site_dome);
            
            vis_resp=nan(50,num_cells);
            aud_resp=vis_resp;
            bim_resp=vis_resp;
                       
            for j=1:num_cells
                vis_resp(:,j)=site_resp{j}(:,vis_ind);
                aud_resp(:,j)=site_resp{j}(:,aud_ind);
                bim_resp(:,j)=site_resp{j}(:,bim_ind);
            end
            bim_resp_mu=mean(bim_resp);
            pop_bim_resp=[pop_bim_resp,bim_resp_mu];
            sum_resp_mu=mean(vis_resp+aud_resp);
            pop_sum_resp=[pop_sum_resp,sum_resp_mu];
            
            % grab post-period responses for each cell
            site_post=site.id_mt_data.post_cell(site_dome);
            
            vis_post=nan(50,num_cells);
            aud_post=vis_post;
            bim_post=vis_post;
            
            for j=1:num_cells
                vis_post(:,j)=site_post{j}(:,vis_ind);
                aud_post(:,j)=site_post{j}(:,aud_ind);
                bim_post(:,j)=site_post{j}(:,bim_ind);
            end
            
            %%%% compile bimiodal response data
            % Post
            pop_vis_post=[pop_vis_post,mean(vis_post)];
            pop_aud_post=[pop_aud_post,mean(aud_post)];
            pop_bim_post=[pop_bim_post,mean(bim_post)];
            
            % Variance
            pop_vis_var=[pop_vis_var,std(vis_post).^2];
            pop_aud_var=[pop_aud_var,std(aud_post).^2];
            pop_bim_var=[pop_bim_var,std(bim_post).^2];  
            
            % Covariance
            if num_cells>1
                mask=triu ( true(num_cells,num_cells),1 );
                
                temp_cov=cov(vis_post);
                vis_cov=temp_cov(mask);
                pop_vis_cov=[pop_vis_cov,vis_cov'];
                
                temp_cov=cov(aud_post);
                aud_cov=temp_cov(mask);
                pop_aud_cov=[pop_aud_cov,aud_cov'];
                
                temp_cov=cov(bim_post);
                bim_cov=temp_cov(mask);
                pop_bim_cov=[pop_bim_cov,bim_cov'];
                
                source_mat=ones(num_cells,1)*[total_cell_count+1:total_cell_count+num_cells];
                source_mat_flip=source_mat';
                source_indx=[source_indx;source_mat_flip(mask),source_mat(mask)];
            end
            total_cell_count=total_cell_count+num_cells;
            
            %%% Shuffle aud relative to vis
            %  keep units associated with eachother
            shuff_mu=nan(n_shuff,num_cells);
            shuff_var=shuff_mu;
            shuff_cov=nan(n_shuff,num_cells*(num_cells-1)/2);
            
            for j=1:n_shuff
                % Shuffle - data is in n_resp x n_cell matrix
                shuff_aud=aud_post(randperm(50),:);
                sum_av_post=vis_post+shuff_aud;
                
                % Mean
                shuff_mu(j,:)=mean(sum_av_post);
                
                % Variance
                shuff_var(j,:)=std(sum_av_post).^2;
                
                % Covariance
                if num_cells>1
                    temp_cov=cov(sum_av_post);
                    shuff_cov(j,:)=temp_cov(triu ( true(num_cells,num_cells),1 ));
                end
                
            end
            
            %%% Calculate sum without shuffle also
            sum_av_post_NS=vis_post+aud_post;
            pop_sum_var_NS=[pop_sum_var_NS,std(sum_av_post_NS).^2];
            temp_cov=cov(sum_av_post);
            pop_sum_cov_NS=[pop_sum_cov_NS;temp_cov(triu ( true(num_cells,num_cells),1 ))];
            
            %%% Compile unimodal sum response data
            sum_mu=mean(shuff_mu,1);
            sum_var=mean(shuff_var,1);
            sum_cov=mean(shuff_cov,1);
            pop_sum_post=[pop_sum_post,sum_mu];
            pop_sum_var=[pop_sum_var,sum_var];
            pop_sum_cov=[pop_sum_cov,sum_cov];
            
        end
end   

internal_var=pop_sum_var-pop_bim_var;
aud_path_var=pop_aud_var-internal_var;
vis_path_var=pop_vis_var-internal_var;

internal_cov=pop_sum_cov-pop_bim_cov;
aud_path_cov=pop_aud_cov-internal_cov;
vis_path_cov=pop_vis_cov-internal_cov;

pop_bim_std=pop_bim_var.^.5;
source_std1=pop_bim_std(source_indx(:,1));
pop_bim_nc=pop_bim_cov./( pop_bim_std(source_indx(:,1)).*pop_bim_std(source_indx(:,2)));

pop_aud_std=pop_aud_var.^.5;
pop_aud_nc=pop_aud_cov ./ (pop_aud_std(source_indx(:,1)) .*pop_aud_std(source_indx(:,2)) );

aud_path_std=aud_path_var.^.5;
aud_path_nc=aud_path_cov./ (aud_path_std(source_indx(:,1)).*aud_path_std(source_indx(:,2)));

dbstack
keyboard
%% Calculate Variance by Source

% %%% Make sure the SUM equals the combined unimodal. 
figure
x1=log2(pop_sum_var);
x2=log2(pop_sum_var_NS);
y=log2((pop_aud_var+pop_vis_var));

plot (x1,y,'o')
hold on
plot (x2,y,'rs') 
plot ([0,max(x1)],[0,max(x1)],':k')

r1=corr(x1',y');
r2=corr(x2',y');
legtxt{1}=sprintf('Shuff. r=%.4f',r1);
legtxt{2}=sprintf('No Shuff. r=%.4f',r2);
legend(legtxt)
title ('Var(SUM) vs Var(Aud+Vis)')
xlabel('log_2[Var(A+V)]')
ylabel('log2[Var(A)+Var(V)]')
% % as a note, there are small deviations from unity.  These are likely do to
% % small amounts of covariance between visual and auditory components
% % that violate the rules for summation of variance.  The fact that they are
% % so small supports that my shuffle made the auditory and visual signals
% % independent. By comparison, if you look at the variance without the
% % shuffle you see that the deviations are much more prevalent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot Bimodal vs Summed Variance
x=[ones(1,length(pop_sum_var)); 2*ones(1,length(pop_sum_var))];
y=log2([pop_bim_var;pop_sum_var]);
increasers=y(2,:)>y(1,:);
lincols=linspecer(2);
figure
hold on
plot (x(:,increasers),y(:,increasers),'o--','Color',lincols(1,:))
plot (x(:,~increasers),y(:,~increasers),'d-','Color',lincols(2,:),'LineWidth',1)

% Means w/ error bars
plot(.9,mean(y(1,:)),'sk','MarkerSize',10)
plot ([.9 .9],[mean(y(1,:))-std(y(1,:)) mean(y(1,:))+std(y(1,:))],'k')
%
plot(2.1,mean(y(2,:)),'sk','MarkerSize',10)
plot ([2.1 2.1],[mean(y(2,:))-std(y(2,:)) mean(y(2,:))+std(y(2,:))],'k')

% Labels
set (gca,'xlim',[.75 2.25])
set(gca,'xtick',[.95 2.05])
set(gca,'xticklabel',{'Var(Bim)','Var(Sum)'})
ylabel('log_2(Variance)')
title (sprintf ('Var(Bim) vs Var(Sum)\nmean(Bim)=%.2f, mean(Sum)=%.2f\nSum>Bim = %i :: Sum<Bim = %i',mean(pop_bim_var),mean(pop_sum_var),sum(increasers),sum(~increasers) ) )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Show Variance by Source as bar graph
figure
avi_var=[aud_path_var+vis_path_var+internal_var];
y=[mean(aud_path_var),mean(vis_path_var),mean(internal_var),mean(avi_var)];
y_std=[std(aud_path_var),std(vis_path_var),std(internal_var),std(avi_var)];
y_er=[y+y_std;y-y_std];
bar(y,'w')
hold on
plot ([1:4;1:4],y_er,'k')

set (gca,'xtick',1:4)
set(gca,'xticklabel',{'Aud_path','Vis_path','Int','A+V+I'})
ylabel('Var(source)')
p=anova1([aud_path_var;vis_path_var;internal_var]',[],'off');
title (sprintf('Variance by Source\nANOVA p=%.2f',p))

%%% Show Variance by Source as Scatters
%as separate scatters
% Aud vs Vis
logger=0;
x=aud_path_var';
y=vis_path_var';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Var(Aud_{path}) vs Var(Vis_{path})')
xlabel ('Var(Aud_{path})')
ylabel ('Var(Vis_{path})')

% Aud vs Int
logger=0;
x=aud_path_var';
y=internal_var';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Var(Aud_{path}) vs Var(Internal)')
xlabel ('Var(Aud_{path})')
ylabel ('Var(Internal)')

% Vis vs Int
logger=0;
x=vis_path_var';
y=internal_var';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Var(Vis_{path}) vs Var(Internal)')
xlabel ('Var(Vis_{path})')
ylabel ('Var(Internal)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Show Variance by Source, Normalized to Bimodal Variance as bar graph
int_norm_var=internal_var./pop_bim_var;
aud_norm_var=aud_path_var./pop_bim_var;
vis_norm_var=vis_path_var./pop_bim_var;
norm_avi_var=int_norm_var+aud_norm_var+vis_norm_var;

figure
y=[mean(aud_norm_var),mean(vis_norm_var),mean(int_norm_var),mean(norm_avi_var)];
y_std=[std(aud_norm_var),std(vis_norm_var),std(int_norm_var),std(norm_avi_var)];
y_er=[y+y_std;y-y_std];
bar(y,'w')
hold on
plot ([1:4;1:4],y_er,'k')

set (gca,'xtick',1:4)
set(gca,'xticklabel',{'Aud_path','Vis_path','Int','A+V+I'})
ylabel('Var(source) / Var(Bim)')
p=anova1([aud_norm_var;vis_norm_var;int_norm_var]',[],'off');
title (sprintf('Normalized Variance by Source\nANOVA p=%.2f',p))

%%% This plot would show variance by source, normalized to bimodal
%%% variance, including all the points on a single plot. 
% lincols=linspecer(4);
% x=1:length(int_norm_var);
% figure
% hold on
% plot (x,aud_norm_var','o','Color',lincols(1,:))
% plot (x,vis_norm_var','d','Color',lincols(2,:))
% plot (x,int_norm_var','s','Color',lincols(3,:))
% plot (x,avi_var','*','Color',lincols(4,:))
% plot (18',mean(aud_norm_var)','o','MarkerSize',13,'LineWidth',2,'Color',lincols(1,:))
% plot (20',mean(vis_norm_var)','d','MarkerSize',13,'LineWidth',2,'Color',lincols(2,:))
% plot (22',mean(int_norm_var)','s','MarkerSize',13,'LineWidth',2,'Color',lincols(3,:))
% legtxt={};
% legtxt{end+1}=sprintf('Aud mean=%.2f',mean(aud_norm_var));
% legtxt{end+1}=sprintf('Vis mean=%.2f',mean(vis_norm_var));
% legtxt{end+1}=sprintf('Int mean=%.2f',mean(int_norm_var));
% legtxt{end+1}='A+V+I';
% legend(legtxt)
% title ('Normalized Variances by Source')
% ylabel ('Var(Source)/Var(Bim)')
% plot (x([1,end]),[0 0],':k')
% plot (x([1, end]),[1 1],':k')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% FFs by Source
%%% Calculate FFs
aud_path_ff=aud_path_var./pop_aud_post;
aud_int_ff=internal_var./pop_aud_post;
%drop outliers
x=aud_path_ff;
mask1=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
x=aud_int_ff;
mask2=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
outliers=mask1 | mask2;
aud_path_ff(outliers)=[];
aud_int_ff(outliers)=[];

vis_path_ff=vis_path_var./pop_vis_post;
vis_int_ff=internal_var./pop_vis_post;
%drop outliers
x=vis_path_ff;
mask1=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
x=vis_int_ff;
mask2=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
outliers=mask1 | mask2;
vis_path_ff(outliers)=[];
vis_int_ff(outliers)=[];

bim_Apath_ff=aud_path_var./pop_bim_post;
bim_int_ff=internal_var./pop_bim_post;
bim_Vpath_ff=vis_path_var./pop_bim_post;
%drop outliers
x=bim_Apath_ff;
mask1=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
x=bim_int_ff;
mask2=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
x=bim_Vpath_ff;
mask3=x>(mean(x)+3*std(x)) | (x<mean(x)-3*std(x));
outliers=mask1 | mask2 | mask3;
bim_Apath_ff(outliers)=[];
bim_int_ff(outliers)=[];
bim_Vpath_ff(outliers)=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Fano Factor by Source Bar Graph
figure
hold on
y1=[mean(aud_path_ff),0,mean(aud_int_ff)];
y2=[0,mean(vis_path_ff),mean(vis_int_ff)];
y3=[mean(bim_Apath_ff),mean(bim_Vpath_ff),mean(bim_int_ff)];
h=bar([y1;y2;y3],'stacked');
lincols=linspecer(3);
for i=1:3
    set(h(i),'facecolor',lincols(i,:))
end

% Aud Error Bars
y1_std=[std(aud_path_ff),0,std(aud_int_ff)];
y1_er_means=y1+[0 y1(1) y1(1)]+[0 0 y1(2)];
y1_er=[y1_er_means+y1_std;y1_er_means-y1_std];
x_cent=[1;1];
plot ([x_cent-.25 x_cent x_cent+.25],y1_er,'k')

%Vis Error Bars
y2_std=[0,std(vis_path_ff),std(vis_int_ff)];
y2_er_means=y2+[0 y2(1) y2(1)]+[0 0 y2(2)];
y2_er=[y2_er_means+y2_std;y2_er_means-y2_std];
x_cent=[2;2];
plot ([x_cent-.25 x_cent x_cent+.25],y2_er,'k')

%Bimodal Error Bars
y3_std=[std(bim_Apath_ff),std(bim_Vpath_ff),std(bim_int_ff)];
y3_er_means=y3+[0 y3(1) y3(1)]+[0 0 y3(2)];
y3_er=[y3_er_means+y3_std;y3_er_means-y3_std];
x_cent=[3;3];
plot ([x_cent-.25 x_cent x_cent+.25],y3_er,'k')

%Stats
[p_aud,test_aud]=Paired_Stats(aud_path_ff,aud_int_ff);
[p_vis,test_vis]=Paired_Stats(vis_path_ff,vis_int_ff);
p_bim=anova1([bim_Apath_ff;bim_Vpath_ff;bim_int_ff]',[],'off');

legend ({'Aud Path','Vis Path','Int'})
set (gca,'xtick',[1:3]);
set(gca,'xticklabel',{'Aud Resp','Vis Resp','Bim Resp'})
ylabel('Fano')
title (sprintf('Fano Factor by Source\np(Aud)=%.2f %s :: p(Vis)=%.2f %s :: p(Bim)=%.2f %s',p_aud,test_aud,p_vis,test_vis,p_bim,'anova'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Calculate Covariance by Source

%%% Make sure the SUM equals the combined unimodal. 
figure
x1=log2(pop_sum_cov+1);
x2=log2(pop_sum_cov_NS+1);
y=log2(pop_aud_cov+pop_vis_cov+1);
plot (x1,y,'o')
hold on
plot (x2,y,'sr')
plot ([0 x1],[0 x1],':k')

r1=corr(x1',y');
r2=corr(x2,y');
legtxt={};
legtxt{1}=sprintf('Shuff. r=%.4f',r1);
legtxt{2}=sprintf('No Shuff. r=%.4f',r2);
legend(legtxt)
title ('Cov(SUM) vs Cov(Aud+Vis)')
xlabel('Cov(A+V)')
ylabel('Cov(A) + Cov(V)')
% as a note, there are small deviations from unity.  These are likely do to
% small amounts of covariance between visual and auditory components
% that violate the rules for summation of variance.  The fact that they are
% so small supports that my shuffle made the auditory and visual signals
% independent. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Plot Bimodal vs Summed Variance
% figure
% plot (pop_bim_var,pop_sum_var,'ok')
% hold on
% plot ([0,max(pop_bim_var)],[0,max(pop_bim_var)],':k')
% title ('Var(Bim) vs Var(Sum)')
% xlabel ('Bim')
% ylabel('Sum')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Plot Bimodal vs Summed Covarariances
x=[ones(1,length(pop_sum_cov)); 2*ones(1,length(pop_sum_cov))];
y=[pop_bim_cov;pop_sum_cov];
increasers=y(2,:)>y(1,:);
lincols=linspecer(2);
figure
hold on
plot (x(:,increasers),y(:,increasers),'o--','Color',lincols(1,:))
plot (x(:,~increasers),y(:,~increasers),'d:','Color',lincols(2,:),'LineWidth',1)

plot(.9,mean(y(1,:)),'sk','MarkerSize',10)
plot ([.9 .9],[mean(y(1,:))-std(y(1,:)) mean(y(1,:))+std(y(1,:))],'k')

plot(2.1,mean(y(2,:)),'sk','MarkerSize',10)
plot ([2.1 2.1],[mean(y(2,:))-std(y(2,:)) mean(y(2,:))+std(y(2,:))],'k')

set (gca,'xlim',[.75 2.25])
set(gca,'xtick',[.95 2.05])
set(gca,'xticklabel',{'Cov(Bim)','Cov(Sum)'})
ylabel('Cov')
title (sprintf ('Cov(Bim) vs Cov(Sum)\nmean(Bim)=%.2f, mean(Sum)=%.2f\nSum>Bim = %i :: Sum<Bim = %i',mean(pop_bim_cov),mean(pop_sum_cov),sum(increasers),sum(~increasers) ) )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Show the variance by source as bar graphs
figure
bar([mean(pop_bim_cov),mean(aud_path_cov),mean(vis_path_cov),mean(internal_cov)],'w')
hold on
plot ([1 1],[mean(pop_bim_cov)-std(pop_bim_cov), mean(pop_bim_cov)+std(pop_bim_cov)],'-k','LineWidth',3)
plot ([2 2],[mean(aud_path_cov)-std(aud_path_cov), mean(aud_path_cov)+std(aud_path_cov)],'-k','LineWidth',3)
plot ([3 3],[mean(vis_path_cov)-std(vis_path_cov), mean(vis_path_cov)+std(vis_path_cov)],'-k','LineWidth',3)
plot ([4 4],[mean(internal_cov)-std(internal_cov), mean(internal_cov)+std(internal_cov)],'-k','LineWidth',3)
set (gca,'xlim',[.5 4.5])
set (gca,'xtick',[1:4])
set(gca,'xticklabel',{'Bim','Aud','Vis','Int'})
ylabel('Cov')
p=anova1([aud_path_cov',vis_path_cov',internal_cov'],[],'off');
title (sprintf('Covariance by Source\nBim=%.1f : Aud=%.1f : Vis=%.1f : Int=%.1f\nanova-p=%.2f',mean(pop_bim_cov),mean(aud_path_cov),mean(vis_path_cov),mean(internal_cov),p ))

% Same plot but with each site shown as a point with lines connecting them
% figure
% plot ([1 2 3 4],[pop_bim_cov',aud_path_cov',vis_path_cov',internal_cov'],':k','LineWidth',.25)
% hold on
% plot ([1 1],[mean(pop_bim_cov)-std(pop_bim_cov), mean(pop_bim_cov)+std(pop_bim_cov)],'-k','LineWidth',3)
% plot ([2 2],[mean(aud_path_cov)-std(aud_path_cov), mean(aud_path_cov)+std(aud_path_cov)],'-k','LineWidth',3)
% plot ([3 3],[mean(vis_path_cov)-std(vis_path_cov), mean(vis_path_cov)+std(vis_path_cov)],'-k','LineWidth',3)
% plot ([4 4],[mean(internal_cov)-std(internal_cov), mean(internal_cov)+std(internal_cov)],'-k','LineWidth',3)
% plot ([1 2 3 4], [mean(pop_bim_cov),mean(aud_path_cov),mean(vis_path_cov),mean(internal_cov)],'sk','MarkerSize',10,'LineWidth',3)
% set (gca,'xlim',[.5 4.5])
% set (gca,'xtick',[1:4])
% set(gca,'xticklabel',{'Bim','Aud','Vis','Int'})
% ylabel('Cov')
% title (sprintf('Covariance by Source\nBim=%.1f : Aud=%.1f : Vis=%.1f : Int=%.1f',mean(pop_bim_cov),mean(aud_path_cov),mean(vis_path_cov),mean(internal_cov) ))
% 
% int_norm_cov=internal_cov./pop_bim_cov;
% aud_norm_cov=aud_path_cov./pop_bim_cov;
% vis_norm_cov=vis_path_cov./pop_bim_cov;
% avi_cov=int_norm_cov+aud_norm_cov+vis_norm_cov;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Show Variance by Source as Scatters
%as separate scatters
% Aud vs Vis
logger=0;
x=aud_path_cov';
y=vis_path_cov';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Cov(Aud_{path}) vs Cov(Vis_{path})')
xlabel ('Cov(Aud_{path})')
ylabel ('Cov(Vis_{path})')

% Aud vs Int
logger=0;
x=aud_path_cov';
y=internal_cov';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Cov(Aud_{path}) vs Cov(Internal)')
xlabel ('Cov(Aud_{path})')
ylabel ('Cov(Internal)')

% Vis vs Int
logger=0;
x=vis_path_cov';
y=internal_cov';
figure
hold on
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
legend (legtxt)
title ('Cov(Vis_{path}) vs Cov(Internal)')
xlabel ('Cov(Vis_{path})')
ylabel ('Cov(Internal)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculate Noise Correlations
% pop_cov_source_indx
aud_path_nc=aud_path_cov./(aud_path_var(source_indx(:,1)).*aud_path_var(source_indx(:,2)));

function legtxt=Plot_XvsY_thisfun (x,y,logger,dotsize,regression_width)

dropper=isnan(x) | isnan(y);
x(dropper)=[];
y(dropper)=[];

mask1=x>(mean(x)+3*std(x)) | x<(mean(x)-3*std(x)) ;
mask2=y>(mean(y)+3*std(y)) | y<(mean(y)-3*std(y)) ;
outliers=mask1 | mask2;
x(outliers)=[];
y(outliers)=[];

pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];

[p_mean,test]=Paired_Stats(x,y);

[rho,p_corr]=corr(x,y);
plotfit_x=xminmax(1):.01:xminmax(2);
plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';

if logger
    %     plot (log2(1+x),log2(1+y),'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     plot (log2(1+mean(x)),log2(1+mean(y)),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     plot (log2(1+plotfit_x),log2(1+plotfit_y),'--','Color',lincol(2,:),'LineWidth',regression_width)
    plot (log2(1+x),log2(1+y),'ok','MarkerSize',dotsize)
    plot (log2(1+mean(x)),log2(1+mean(y)),'dk','MarkerSize',10,'LineWidth',2)
    plot (log2(1+plotfit_x),log2(1+plotfit_y),'--k','LineWidth',regression_width)
else
    %     plot (x,y,'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     plot (mean(x),mean(y),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     plot (plotfit_x,plotfit_y,'--','Color',lincol(2,:),'LineWidth',regression_width)
    plot (x,y,'ok','MarkerSize',dotsize)
    plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
    plot (plotfit_x,plotfit_y,'--k','LineWidth',regression_width)
end

legtxt{1}=sprintf('DATA: n=%i',length(x));
legtxt{2}=sprintf('Mean = [%.2f %.2f], p(x==y)=%.2e : %s',mean(x),mean(y),p_mean, test);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);

function [p_mean,test]=Paired_Stats(x,y)

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_mean,~]=signrank(x,y);
    test='SR';
else
    %do paired ttest
    [~,p_mean]=ttest(x,y);
    test='TT';
end

