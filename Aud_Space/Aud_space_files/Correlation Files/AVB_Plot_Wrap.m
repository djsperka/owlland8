function AVB_Plot_Wrap(handles)
global site_cell
% This function is designed to plot auditory, visual and bimodal data (50
% reps presented at "in" location) as bar graphs.  The three graphs are
% response magnitude, fano factor and noise correlations.

[do_bar,do_scatter]=AVB_Plot_Start;

set(handles.rrc_vwi,'Value',1);
set(handles.rrc_ai,'Value',1);
set(handles.rrc_vwo,'Value',0);
set(handles.rrc_ao,'Value',0);
set(handles.rrc_vwi_and_vwo,'Value',0);
set(handles.rrc_as,'Value',0);

dome_cell=Resp_Property_Filter (handles);

pop_resp=[];
pop_ff=[];
pop_nc=[];
for i=1:length(site_cell)
    site=site_cell{i};
    vis_ind=strcmp(site.id_mt_labels,'Vw_I  ');
    aud_ind=strcmp(site.id_mt_labels,'A_I  ');
    bim_ind=strcmp(site.id_mt_labels,'A_I  Vw_I');
    
    if sum(bim_ind)==1 %if all classes existed
        %%% Assemble Responses
        aud_resp=site.data_mt_resp(dome_cell{1,i},aud_ind);  
        vis_resp=site.data_mt_resp(dome_cell{1,i},vis_ind);
        bim_resp=site.data_mt_resp(dome_cell{1,i},bim_ind);
        
        pop_resp=[pop_resp;[aud_resp,vis_resp,bim_resp]];
        
        %%% Assemble Fanos
        aud_ff=site.data_fano(dome_cell{1,i},aud_ind);
        vis_ff=site.data_fano(dome_cell{1,i},vis_ind);
        bim_ff=site.data_fano(dome_cell{1,i},bim_ind);
        
        pop_ff=[pop_ff;[aud_ff,vis_ff,bim_ff]];
        
        %%% Assemble NCs
        aud_nc=site.data_mt_post_corr(dome_cell{2,i},aud_ind);
        vis_nc=site.data_mt_post_corr(dome_cell{2,i},vis_ind);
        bim_nc=site.data_mt_post_corr(dome_cell{2,i},bim_ind);
        
%%    %% High NC Assessment
% %         high_ncs=bim_nc>.8;
% %         if sum(high_ncs)>0
% %             site.site_date
% %             site.site_id
% %             all_chans=site.data_chans(dome_cell{2,i},:);
% %             high_chans=all_chans(high_ncs,:)
% %             trodes=site.id_trode(high_chans)
% %             bim_nc(high_ncs)
% %             
% %             chan1_times=site.id_mt_data.data_time{high_chans(1),bim_ind};
% %             chan1_trials=site.id_mt_data.data_trial{high_chans(1),bim_ind};
% %             chan1_reps=site.id_mt_data.data_rep{high_chans(1),bim_ind};
% %             chan2_times=site.id_mt_data.data_time{high_chans(2),bim_ind};
% %             chan2_trials=site.id_mt_data.data_trial{high_chans(2),bim_ind};
% %             chan2_reps=site.id_mt_data.data_rep{high_chans(2),bim_ind};
% %             
% %             nreps=max([max(chan1_reps) max(chan2_reps)]);
% %             
% %             max_lag=20;
% %             count_lags=zeros(1,max_lag*2);
% %             lags=-max_lag:max_lag;
% %             
% %             for hh=1:nreps
% %                 reptimes1=chan1_times(chan1_reps==hh);
% %                 reptimes2=chan2_times(chan2_reps==hh);
% %                 chan1_repmat{hh}=reptimes1;
% %                 chan2_repmat{hh}=reptimes2;
% %                 for ii=1:length(reptimes1)
% %                     time_diffs=reptimes2-reptimes1(ii);
% %                     for jj=1:max_lag*2
% %                         window=[lags(jj) lags(jj+1)];
% %                         count_lags(jj)=count_lags(jj)+sum(time_diffs>window(1) & time_diffs<=window(2));
% %                     end
% %                 end
% %                 
% %             end
% %             
% %             h1=figure;
% % %             plot (lags(1:end-1)+.5,count_lags,'-k')
% %             bar (lags(1:end-1)+.5,count_lags,1,'EdgeColor','k','FaceColor','w')
% %             hold on
% %             bar (lags(end/2-1:end/2)+.5,count_lags(end/2:end/2+1),1,'EdgeColor','k','FaceColor',[.8 .8 .8])
% % %             ylims=get(gca,'ylim');
% % %             plot ([-1 -1;1 1]', [ylims;ylims]','--k')
% %             xlabel ('lag (ms)')
% %             ylabel ('count')
% %             title ('Cross-Correlogram')
% %             
% %             notes_x_width=4; notes_y_width=3.5;
% %             poster_x_width=2.5 ;poster_y_width=2;
% %             
% %             save_cd=uigetdir;
% %             cd(save_cd)
% %             figure (h1)
% %             set(gcf, 'PaperUnits', 'inches');
% %             set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
% %             savename=sprintf('Notes_High_NC_Pair_%.0i.png',i);
% %             saveas(h1,savename) %Save it!
% %             xlabel('')
% %             ylabel('')
% %             legend('off')
% %             title('')
% %             set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
% %             savename=sprintf('Paper_High_NC_Pair_%.0i.png',i);
% %             saveas(h1,savename) %Save it!
% %             
% %             dbstack
% %             keyboard
% %             
% %         end
        
        pop_nc=[pop_nc;[aud_nc,vis_nc,bim_nc]];
    end
    
end

%% Make Bar Graphs
if do_bar
    AVB_Plot_Bar(pop_resp,pop_ff,pop_nc)
end

if do_scatter
  AVB_Plot_Scatter(pop_resp,pop_ff,pop_nc)
end

