function WA_Map_Wrap()
global chan_select rec snd 

% global spacemap wa_plots %had these when I was building my flexible stim
% window ... don't need em now DJT 10/7/2013

%%%Needed this when I was not building the WAve Map based on the current
%%%trace, but rather selecting the trace and building on that DJT 10/7/2013
% global wa_map_trace 
% start_trace=snd.trace;
% snd.trace=wa_map_trace;
% get_trace(snd.trace,snd.filename,snd.path)

chans=find(chan_select==1);
wa_peak_vect=ones(rec.numch,2)*nan;
% wa_peak_vect=NaN(rec.numch,2); %NaN matrix doesn't work on 
% wap_edge=zeros(rec.numch,1);

% cd (snd.path)
% fprintf('\nPlease select the OwlLand file this is associated with\n')
% [file_name,pathname]=uigetfile;

%% Build data arrays & Check for Significant Responses
for i=1:length(chans)
    rec.dispch=chans(i);
    [store_dispmat{chans(i)},store_disparr1{chans(i)},store_disparr2{chans(i)}]=Display_Calc;
end 

%% Weighted Average Around Peak
    
    if snd.inter_loom
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','interloom_type'),'value',1);
    end
    
    for i=1:length(chans)
        rec.dispch=chans(i);
        dispmat=store_dispmat{chans(i)}; 
        disparr1=store_disparr1{chans(i)};
        disparr2=store_disparr2{chans(i)};
        wa_peak_vect(chans(i),:)=WAPeak_Run(dispmat,disparr1,disparr2);
    end
    
%     keyboard
% figure(spacemap);
figure(findobj(0,'tag','disp_win_2'))
clf
% subplot (2,2,2);
hold on
% if ~isempty(wa_plots)
%     for i=1:length(wa_plots)
%         delete(wa_plots(i))
%     end
% end
for i=1:length(chans)
    current=chans(i);
%     wa_plots(i)=plot(wa_peak_vect(current,1),wa_peak_vect(current,2),'+k','MarkerSize',15,'LineWidth',3);
    plot(wa_peak_vect(current,1),wa_peak_vect(current,2),'+k','MarkerSize',15,'LineWidth',3);
end
axis ([-40 40 -40 20])
grid on
hold off

%%%Needed this when I was not building the WAve Map based on the current
%%%trace, but rather selecting the trace and building on that DJT 10/7/2013
% snd.trace=start_trace;
% get_trace(snd.trace,snd.filename,snd.path);

% figure(findobj(0,'tag','doug_chanwin'));
% figure(findobj(0,'tag','doug_flexwin'));
    
    
    
%     data_save.id_wa_peak=wa_peak_vect;
%     data_save.data_wap_sep=Sep_Calc(wa_peak_vect);
    
%     %if this was interloom data
%     if snd.inter_loom
%         figure(findobj(0,'tag','disp_win_3'));
%         set(findobj(gcf,'tag','interloom_type'),'value',2);
%         wa_peak_vect_loom=NaN(rec.numch,2);
%         for i=1:length(chans)
%             rec.dispch=chans(i);
%             dispmat=store_dispmat{chans(i)};
%             disparr1=store_disparr1{chans(i)};
%             disparr2=store_disparr2{chans(i)};
%             wa_peak_vect_loom(chans(i),:)=WAPeak_Run(dispmat,disparr1,disparr2);
%         end
%         data_save.id_wa_peak_loom=wa_peak_vect_loom;
%         data_save.data_wap_sep_loom=Sep_Calc(wa_peak_vect_loom);
%         
%     end
    




% %% Save Data
% 
% cd (snd.path)
% fprintf('\nPlease select the OwlLand file this is associated with\n')
% [file_name,pathname]=uigetfile;
% 
% cd (pathname);
% target=load(file_name);
% %--------- remove fields if they already exist 
% tempnames=fieldnames(data_save);
% for i=1:length(tempnames)
% if any(strcmp(tempnames{i},fieldnames(target)))
%     target=rmfield(target,tempnames{i});
% end
% end %----------------------------------------
% output=Catstruct(target,data_save);
% fprintf('\n')
% save(file_name,'-struct','output');
% 
% fprintf('\nDone.  Check it out.  If you still have a million figures open, try using the ALL_fig_hands variable\n\n')
% keyboard