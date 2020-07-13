function Stat_vs_Loom_VRF(handles,save_figs,save_dir,start_dir)
global site_cell

%% Data Controls

% SRF response cutoff for calculating looming/static relationship
cutoff=0.2;
% cutoff=-10;

% Resp or post
use_resp_mult=1;
        
%% Display Controls
% set size of saved plots
notes_x_width=4.5; notes_y_width=3.5;
paper_x_width_heat=3 ;paper_y_width_heat=2;
rez='300'; %dpi ... needs to be a string

paper_x_width_scatter=2.5; paper_y_width_scatter=2;
% line colors and sizes
set_line_width=1; % width for printed lines for relative contr plot
unity_line_width=1;
point_size=5; %marker size of data points
mean_size=10; %marker size of mean marker
mean_width=2; %line width of mean marker

resp_dims=[-50 -50; 50 50]; %bottom left, top right
resp_mod_pop=[];
resp_mod_space_sum=zeros(resp_dims(2,1)-resp_dims(1,1)+1,resp_dims(2,2)-resp_dims(1,2)+1);
stat_space=resp_mod_space_sum;
loom_space=resp_mod_space_sum;

rf_density=1;
rf_sfreq=1/rf_density;
x_vect=[resp_dims(1,2):rf_sfreq:resp_dims(2,2)];
y_vect=[resp_dims(1,1):rf_sfreq:resp_dims(2,1)];
x_mat=ones(length(y_vect),1)*x_vect;
y_mat=y_vect'*ones(1,length(x_vect));

% Set X and Y limits for plotting
y_axis_range=[-25 25];
x_axis_range=[-25 25];

%% Initialized parameters for looking at multiplicative scaling
pop_rho=[];
pop_p=[];
pop_points_raw=[];
pop_points_norm=[];

% Select Data
dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask

%% Do Visual
% Grab all the receptive fields and interpolate all the receptive fields to within 1 degree
count=0;
for i=1:length(site_cell)
    dome=dome_cell{1,i};
    
    if isfield(site_cell{i},'id_vis_map_loom')
        count=count+1;
        %%% Grab Maps
        v1a=site_cell{i}.id_vis_map_stat.Var1array;
        v2a=site_cell{i}.id_vis_map_stat.Var2array;
        site_resps_stat_post=site_cell{i}.id_vis_map_stat.post(:,:,dome);
        site_resps_loom_post=site_cell{i}.id_vis_map_loom.post(:,:,dome);
        site_resps_stat_resp=site_cell{i}.id_vis_map_stat.resp(:,:,dome);
        site_resps_loom_resp=site_cell{i}.id_vis_map_loom.resp(:,:,dome);
        
        statsize=size(site_resps_stat_post);
        loomsize=size(site_resps_loom_post);
        if statsize(1)~=loomsize(1) || statsize(2)~=loomsize(2)
            fprintf('\nLooks like you didn''t map the same space.  This is gonna be a problem!\n')
            dbstack
            keyboard
        end
        
        % This is for investigating whether looming RFs are
        % multiplicatively scaled versions of static RFs
        
        %%% This approach checks to see if the looming/static ratio
        %%% changes as normalized resopnses get closer to the peak
        %   IN CODE DUMP AT BOTTOM OF SCRIPT
        
        %%% This approach does a linear regression and checks whether the
        %%% slope is different from 1 and the intercept is different from
        %%% 0
        [nx,ny,nz]=size(site_resps_stat_post);
        for j=1:nz
            if use_resp_mult
                this_loom=site_resps_loom_resp(:,:,j);
                this_stat=site_resps_stat_resp(:,:,j);
            else
                this_loom=site_resps_loom_post(:,:,j);
                this_stat=site_resps_stat_post(:,:,j);
            end
            this_cutoff=max(this_stat(:))*cutoff;
            above_cutoff=this_stat>this_cutoff;
            this_loom=this_loom(above_cutoff);
            this_stat=this_stat(above_cutoff);
            
            loom_norm=this_loom(:)/max(this_stat(:));
            stat_norm=this_stat(:)/max(this_stat(:));
            pop_points_norm=[pop_points_norm;[stat_norm,loom_norm]];
        end           
         %%%%
         %%%%
            
        v1a_int=v1a(1):rf_density:v1a(end);
        v2a_int=v2a(1):rf_density:v1a(end);
        
        X=repmat(v1a,[length(v2a),1]);
        Xq=repmat(v1a_int,[length(v2a_int),1]);
        Y=repmat(v2a',[1,length(v1a)]);
        Yq=repmat(v2a_int',[1,length(v1a_int)]);
        
        vis_rfs{count}.Xq=Xq;
        vis_rfs{count}.Yq=Yq;
        
        vis_rfs{count}.Zq_stat=[];
        vis_rfs{count}.Zq_loom=[];
        for j=1:sum(dome)
            vis_rfs{count}.Zq_stat(:,:,j)=interp2(X,Y,site_resps_stat_post(:,:,j),Xq,Yq);
            vis_rfs{count}.Zq_loom(:,:,j)=interp2(X,Y,site_resps_loom_post(:,:,j),Xq,Yq);
            
        end
        
        vis_rfs{count}.az_com=site_cell{i}.data_az_com_stat(dome);
        vis_rfs{count}.el_com=site_cell{i}.data_el_com_stat(dome);
        
    end
    
end

%% Investigate Multiplicative Scaling
%%%% This approach does a linear regression and checks whether the
%%%% slope is different from 1 and the intercept is different from
%%%% 0
X=[pop_points_norm(:,1),ones(size(pop_points_norm,1),1)];
% y=pop_points_norm(:,2); %is slope different from 1?
y=pop_points_norm(:,2) - pop_points_norm(:,1); %is slope different from 0?
stats=regstats(y,X(:,1),'linear');
yint=stats.beta(1);
p_yint=stats.tstat.pval(1);
slope=1+stats.beta(2);
p_slope=stats.tstat.pval(2);

figure
hold on
plot (pop_points_norm(:,1),pop_points_norm(:,2),'.k','MarkerSize',point_size)
% plot ([0 1],[0 1]*slope+yint,':k','LineWidth',set_line_width)
plot ([0 1],[0 1],'--k','LineWidth',unity_line_width)
if use_resp_mult
    datatype='Resp';
else
    datatype='Post';
end
title (sprintf('Static vs Looming Responses from Mapping Experiments\n%s  ::  Cutoff %.2f',datatype,cutoff))
xlabel ('Static re. Stat Max')
ylabel ('Looming re. Loom Max')
legtxt{1}=sprintf('n=%.0f',size(X,1));
legtxt{2}=sprintf('loom=%.2f*stat+%.2f\np(slope=1)=%.1e \np(yint=0)=%.1e',slope,yint,p_slope,p_yint);
legend (legtxt)
% % % % 
% % % % 

if save_figs
    fig_name='Stat vs Loom Scat';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_scatter,paper_y_width_scatter,rez)
    cd(start_dir)
end

%% Calculate Average Response Map
count=0;
Xq_nan_count=0;
Yq_nan_count=0;
Zq_nan_count=0;

for i=1:length(vis_rfs)
    this_xq=vis_rfs{i}.Xq;
    this_yq=vis_rfs{i}.Yq;
    site_zq_stat=vis_rfs{i}.Zq_stat;
    site_zq_loom=vis_rfs{i}.Zq_loom;
    
    if ~isempty(site_zq_stat)
        for j=1:size(site_zq_stat,3)
            this_zq_stat=site_zq_stat(:,:,j);
            this_zq_loom=site_zq_loom(:,:,j);
            
            % Center on the peak location
            Xq=this_xq-round(vis_rfs{i}.az_com(j));
            Yq=this_yq-round(vis_rfs{i}.el_com(j));
            Zq_stat=this_zq_stat/max(this_zq_stat(:));
            Zq_loom=this_zq_loom/max(this_zq_stat(:));
%             Zq_stat=this_zq_stat;
%             Zq_loom=this_zq_loom;
            
            if ~sum(isnan([Xq(:);Yq(:);Zq_stat(:)])) %nan check
                
                %%% Expand azimuth
                if min(Xq(:))>resp_dims(1,2) %add zeros to left
                    n_cols=(min(Xq(:))-resp_dims(1,2))*rf_density;
                    add_Z=zeros(size(Zq_stat,1),n_cols);
                    add_X=ones(size(Zq_stat,1),1)*[resp_dims(1,2):rf_sfreq:min(Xq(:))-rf_sfreq];
                    add_Y=[min(Yq(:)):rf_sfreq:max(Yq(:))]'*ones(1,n_cols);
                    Zq_stat=[add_Z,Zq_stat];
                    Zq_loom=[add_Z,Zq_loom];
                    Xq=[add_X,Xq];
                    Yq=[add_Y,Yq];
                end
                if max(Xq(:))<resp_dims(2,2) %add zeros to the right
                    n_cols=(resp_dims(2,2)-max(Xq(:)))*rf_density;
                    add_Z=zeros(size(Zq_stat,1),n_cols);
                    add_X=ones(size(Zq_stat,1),1)*[max(Xq(:))+rf_sfreq:rf_sfreq:resp_dims(2,2)];
                    add_Y=[min(Yq(:)):rf_sfreq:max(Yq(:))]'*ones(1,n_cols);
                    Zq_stat=[Zq_stat,add_Z];
                    Zq_loom=[Zq_loom,add_Z];
                    Xq=[Xq,add_X];
                    Yq=[Yq,add_Y];
                end
                %%% Expand elevation
                if min(Yq(:))>resp_dims(1,1) %add zeros to bottom ... except numbers are inverted so its actually on top
                    n_rows=(min(Yq(:))-resp_dims(1,1))*rf_density;
                    add_Z=zeros(n_rows,size(Zq_stat,2));
                    add_X=ones(n_rows,1)*[min(Xq(:)):rf_sfreq:max(Xq(:))];
                    add_Y=[resp_dims(1,1):rf_sfreq:min(Yq(:)-rf_sfreq)]'*ones(1,size(Yq,2));
                    Zq_stat=[add_Z;Zq_stat];
                    Zq_loom=[add_Z;Zq_loom];
                    Xq=[add_X;Xq];
                    Yq=[add_Y;Yq];
                end
                if max(Yq(:))<resp_dims(2,1) %add zeros to the top ... except actually the bottom
                    n_rows=(resp_dims(2,1)-max(Yq(:)))*rf_density; %degrees added * samples/degree
                    add_Z=zeros(n_rows,size(Zq_stat,2));
                    add_X=ones(n_rows,1)*[min(Xq(:)):rf_sfreq:max(Xq(:))];
                    add_Y=[max(Yq(:)+rf_sfreq):rf_sfreq:resp_dims(2,1)]'*ones(1,size(Yq,2));
                    Zq_stat=[Zq_stat;add_Z];
                    Zq_loom=[Zq_loom;add_Z];
                    Xq=[Xq;add_X];
                    Yq=[Yq;add_Y];
                end
                
                stat_space=stat_space+Zq_stat;
                loom_space=loom_space+Zq_loom;
                
%                 temp_ratio=Zq_loom./Zq_stat;
                temp_ratio=(Zq_loom-Zq_stat)./(Zq_loom+Zq_stat);
%                 temp_ratio=(Zq_loom-Zq_stat)./(Zq_stat);
                temp_ratio(isnan(temp_ratio))=0; %deals with cases when both Zq_loom and Zq_stat were 0. 
                
                resp_mod_space_sum=resp_mod_space_sum+temp_ratio;
                count=count+1;
                resp_mod_pop(:,:,count)=temp_ratio;
                
            elseif ~sum(isnan([Xq(:)])) %nan check
                Xq_nan_count=Xq_nan_count+1;
            elseif ~sum(isnan([Yq(:)])) %nan check
                Yq_nan_count=Yq_nan_count+1;
            elseif ~sum(isnan([Zq_stat(:)])) %nan check
                Zq_nan_count=Zq_nan_count+1;
            end %end nan check
            
        end % for each unit
    end % end isempty check
end

% Make into averages
stat_space=stat_space/count;
loom_space=loom_space/count;
resp_mod_space_sum=resp_mod_space_sum/count;

%%% Plot Static Map
Plot_Map(x_mat,y_mat,stat_space,x_axis_range,y_axis_range)
set(gca,'clim',[0,max(loom_space(:))+.1] )
xlabel ('Degrees Contra re. to Tuning WA')
ylabel('Degrees El. re. Tuning WA')
zlabel('Static Response re. Stat Max')
title (sprintf('Average Static Vis RF :: n=%i',count))

if save_figs
    fig_name='Avg_VRF_Stat';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_heat,paper_y_width_heat,rez)
    cd(start_dir)
end

%%% Plot Looming Map
Plot_Map(x_mat,y_mat,loom_space,x_axis_range,y_axis_range)
set(gca,'clim',[0, max(loom_space(:))+.1] )
xlabel ('Degrees Contra re. to Tuning WA')
ylabel('Degrees El. re. Tuning WA')
zlabel('Looming Response re. Stat Max')
title (sprintf('Average Looming Vis RF :: n=%i',count))

if save_figs
    fig_name='Avg_VRF_Loom';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_heat,paper_y_width_heat,rez)
    cd(start_dir)
end

%%% Plot Response Modulation Map
Plot_Map(x_mat,y_mat,resp_mod_space_sum,x_axis_range,y_axis_range)
set(gca,'clim',[-(max(resp_mod_space_sum(:))),max(resp_mod_space_sum(:))])
xlabel ('Degrees Contra re. to Tuning WA')
ylabel('Degrees El. re. Tuning WA')
zlabel('Response re. Max')
title (sprintf('Modulation Space \nmean [ (Loom-Stat) / (Loom+Stat) ] :: n=%i',count))

if save_figs
    fig_name='Avg_Mod_Map';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_heat,paper_y_width_heat,rez)
    cd(start_dir)
end

% resp_ratio_from_means=loom_space./stat_space;
% resp_ratio_from_means(~isfinite(resp_ratio_from_means))=nan;
% resp_ratio_from_means(isnan(resp_ratio_from_means))=0;
% Plot_Map(x_mat,y_mat,resp_ratio_from_means,x_axis_range,vis_el_range)
% xlabel ('Degrees Contra re. to Tuning WA')
% ylabel('Degrees El. re. Tuning WA')
% zlabel('Response re. Max')
% title (sprintf('mean(Loom) / mean(Static) RF :: n=%i',count))

%%% Collapse Across  Y on Response Modulation Map
x_slice=find(y_mat(:,1)==0);
x_mod_mean=mean(resp_mod_pop(x_slice,:,:),3);
x_mod_std=std(resp_mod_pop(x_slice,:,:),[],3);
x_stat_mean=stat_space(x_slice,:);
fig=figure;
set(fig,'defaultAxesColorOrder',[0,0,0; 0,0,0]);
hold on
plot (x_mat(1,:),x_stat_mean,'-r')
use_ylim=get(gca,'ylim');
yyaxis right
plot (x_mat(1,:),x_mod_mean,'--b')
set (gca,'ylim',use_ylim);
x_patch=[x_mod_mean+x_mod_std,fliplr(x_mod_mean-x_mod_std)];
patch([x_mat(1,:),fliplr(x_mat(1,:))],x_patch,'b','FaceAlpha',.25,'LineStyle','none')
plot (x_mat(1,[1,end]),[0 0],'-k')

title ('Modulation Space Sampled from 0 Deg El')
set (gca,'xlim',x_axis_range)
xlabel ('Degrees Contra re. to Tuning WA')

if save_figs
    fig_name='Mod_Space_X';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_scatter,paper_y_width_scatter,rez)
    cd(start_dir)
end

%%% Collapse Across X On Response Modulation Map
y_slice=find(x_mat(1,:)==0);
y_mod_mean=mean(resp_mod_pop(:,y_slice,:),3)';
y_mod_std=std(resp_mod_pop(:,y_slice,:),[],3)';
y_stat_mean=stat_space(:,y_slice)';

fig=figure;
set(fig,'defaultAxesColorOrder',[0,0,0; 0,0,0]);
hold on
plot (y_mat(:,1),y_stat_mean,'-r')
use_ylim=get(gca,'ylim');
yyaxis right
plot (y_mat(:,1),y_mod_mean,'--b')
set (gca,'ylim',use_ylim)
y_patch=[y_mod_mean+y_mod_std,fliplr(y_mod_mean-y_mod_std)];
patch([y_mat(:,1);flipud(y_mat(:,1))]',y_patch,'b','FaceAlpha',.25,'LineStyle','none')
plot(y_mat([1,end],1),[0 0],'-k')

title ('Modulation Space Sampled from 0 Deg Az')
set (gca,'xlim',y_axis_range)
xlabel('Degrees El. re. Tuning WA')

if save_figs
    fig_name='Mod_Space_Y';
    cd(save_dir)
    Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width_scatter,paper_y_width_scatter,rez)
    cd(start_dir)
end

function Plot_Map(x_mat,y_mat,z_mat,x_axis_range,y_axis_range)

figure;
contourf(x_mat,y_mat,z_mat,100)
% colormap(linspecer);
colorbar;
h_C=get(gca,'children');
set(h_C,'linestyle','none');
set (gca,'xlim',x_axis_range)
set (gca,'ylim',y_axis_range)
hold on
plot ([ones(11,1)*-25,ones(11,1)*25]', [-25:5:25;-25:5:25],':w','LineWidth',.5)
plot ([-25:5:25;-25:5:25],[ones(11,1)*-25,ones(11,1)*25]', ':w','LineWidth',.5)
plot ([0 0; -25 25]',[-25 25; 0 0]','w--','LineWidth',2)

function  Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(gcf,sprintf('Notes_%s',fig_name),'-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(gcf,sprintf('Paper_%s',fig_name),'-dpng',['-r',rez]) %Save it!
        
%%%%%        %%%%%        %%%%%      Code Dump       %%%%%        %%%%%        %%%%%
%%%%%        %%%%%        %%%%%        %%%%%        %%%%%        %%%%%        %%%%%

%         resp_ratio=site_resps_loom./site_resps_stat;
%         [nx,ny,nz]=size(resp_ratio);
%         cutoff=0.25;
%         for j=1:nz
%             this_ratio=resp_ratio(:,:,j);
%             this_stat=site_resps_stat(:,:,j);
%             this_cutoff=cutoff*max(this_stat(:));
%             above_cutoff=this_stat>this_cutoff;
%             this_ratio=this_ratio(above_cutoff);
%             this_stat=this_stat(above_cutoff);
%             [rho,p]=corr(this_ratio,this_stat);
%             pop_rho=[pop_rho;rho];
%             pop_p=[pop_p;p];
%             pop_points_norm=[pop_points_norm;[this_ratio,this_stat/max(this_stat)]];
%             pop_points_raw=[pop_points_raw;[this_ratio,this_stat]];
            
%             figure
%             hold on
%             plot (this_stat,this_ratio,'o')
%             plot ([this_cutoff this_cutoff],[0 max(this_ratio)])
%             plot ([0 max(this_stat)],[1 1],':k','LineWidth',2)
%             xlabel('Static Value')
%             ylabel('Loom / Static')
%             pause
%             close
%         end
        
        %%%%
        %%%%
        
%%%% This approach checks to see if the looming/static ratio
%%%% changes as normalized resopnses get closer to the peak
% 
% nbins = 16;
% bound = 1;
% bins = linspace(-bound,bound,nbins);
% 
% if jbtest(pop_rho)
%     p=signrank(pop_rho);
%     expected=median(pop_rho);
%     type='NP';
%     exp_type='Med';
%     test_type='SR';
% else
%     [~,p]=ttest(pop_rho);
%     expected=mean(pop_rho);
%     type='Para';
%     exp_type='Mea';
%     test_type='TT';
% end
% 
% figure
% % first histogram
% y1 = hist(pop_rho(pop_p>.05), bins);
% % second histogram
% y2 = hist(pop_rho(pop_p<.05), bins);
% % stacked histograms
% bar([y1.' y2.'],'stacked')
% xlabel('Rho')
% ylabel('Count')
% 
% % relabelx-axis range/ticks
% xd = findobj('-property','XData');
% 
% for i=1:2
%     dat = get(xd(i),'XData');
%     dat = 2*dat/nbins - bound;
%     set(xd(i),'XData',dat);
% end
% 
% % Add Labels
% title (sprintf('Loom/Stat vs Stat Correlatin Values\nCutoff = %0.2f \n n=%.0f %s=%.2f p=%.4f w/ %s',cutoff,length(pop_rho),exp_type,expected,p,test_type))
% 
% figure
% plot (pop_points_norm(:,2),pop_points_norm(:,1),'o')

%%%%
%%%%

        