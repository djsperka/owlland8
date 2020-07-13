function AVB_Plot_Bar(pop_resp,pop_ff,pop_nc)

[save_figs,mod_script]=AVB_Bar_Start();

if mod_script
    dbstack
    keyboard
end

fullpath=mfilename('fullpath');
scriptname=mfilename;
pathname=fullpath(1:strfind(fullpath,scriptname)-1)
new_cd=strcat(pathname,'..\Dougs_Data\Correlation Summary Workspaces\Competition');

start_cd=cd;
if save_figs
    save_cd=uigetdir;
end
cd(start_cd);

% set size of saved plots
notes_x_width=4; notes_y_width=3.5;
paper_x_width=3 ;paper_y_width=2;
rez='300'; %DPI ... needs to be a string

% set data size
er_line_width=1.5;

% set colors
lincols=linspecer(2);
lincols(2,:)=[0 0 0]; %make error bars black
lincols(1,:)=[.5 .5 .5]; %make bars grey

%% Plot Responses

resp_mean=mean(pop_resp)';
resp_std=std(pop_resp)';
h1=figure;
barwitherr(resp_std,resp_mean);
set(gca,'xticklabel',{'Aud','Vis','Bim'})
ylabel('Resp (sp/sec)')
hchild=get(gca,'children');
set(hchild(2),'FaceColor',lincols(1,:));
 set(hchild(1),'Color',lincols(2,:),'LineWidth',er_line_width);

[p_av,para_av]=Comp2_Stats(pop_resp(:,1),pop_resp(:,2));
[p_ab,para_ab]=Comp2_Stats(pop_resp(:,1),pop_resp(:,3));
[p_vb,para_vb]=Comp2_Stats(pop_resp(:,2),pop_resp(:,3));
title (sprintf('Response Magnitudes\np(A==V)=%0.2e \tp(A==B)=%0.2e \tp(V==B)=%0.2e',p_av,p_ab,p_vb))
fprintf('\n')
fprintf('\nResponse Magnitudes\tpara(A&&V)=%i \tpara(A&&B)=%i \tpara(V&&B)=%i',para_av,para_ab,para_vb)

if save_figs
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    cd(save_cd)
   print(h1,'Notes_Bar_Resp','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
   print(h1,'Paper_Bar_Resp','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

%% Plot Fanos

ff_mean=mean(pop_ff)';
ff_std=std(pop_ff)';
h1=figure;
barwitherr(ff_std,ff_mean);
set(gca,'xticklabel',{'Aud','Vis','Bim'})
ylabel('Resp (sp/sec)')
hchild=get(gca,'children');
set(hchild(2),'FaceColor',lincols(1,:));
 set(hchild(1),'Color',lincols(2,:),'LineWidth',er_line_width);

[p_av,para_av]=Comp2_Stats(pop_ff(:,1),pop_ff(:,2));
[p_ab,para_ab]=Comp2_Stats(pop_ff(:,1),pop_ff(:,3));
[p_vb,para_vb]=Comp2_Stats(pop_ff(:,2),pop_ff(:,3));
title (sprintf('Fano Factors\np(A==V)=%0.2e \tp(A==B)=%0.2e \tp(V==B)=%0.2e',p_av,p_ab,p_vb))
fprintf('\nFano Factors\tpara(A&&V)=%i \tpara(A&&B)=%i \tpara(V&&B)=%i',para_av,para_ab,para_vb)

if save_figs
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    cd(save_cd)
   print(h1,'Notes_Bar_FF','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
   print(h1,'Paper_Bar_FF','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

%% Plot NCs

nc_mean=mean(pop_nc)';
nc_std=std(pop_nc)';
h1=figure;
barwitherr(nc_std,nc_mean);
set(gca,'xticklabel',{'Aud','Vis','Bim'})
ylabel('Resp (sp/sec)')
hchild=get(gca,'children');
set(hchild(2),'FaceColor',lincols(1,:));
 set(hchild(1),'Color',lincols(2,:),'LineWidth',er_line_width);

 p_anova=anova1(pop_nc);
 figure(h1)
 if p_anova<0.05
     [p_av,para_av]=Comp2_Stats(pop_nc(:,1),pop_nc(:,2));
     [p_ab,para_ab]=Comp2_Stats(pop_nc(:,1),pop_nc(:,3));
     [p_vb,para_vb]=Comp2_Stats(pop_nc(:,2),pop_nc(:,3));
     title (sprintf('Noise Correlations\np(A==V)=%0.2e \tp(A==B)=%0.2e \tp(V==B)=%0.2e',p_av,p_ab,p_vb))
 else    
     title (sprintf('Noise Correlations\nANOVA p=%.2f',p_anova))
 end
fprintf('\nNoise Correlations\tpara(A&&V)=%i \tpara(A&&B)=%i \tpara(V&&B)=%i',para_av,para_ab,para_vb)
fprintf('\n')

if save_figs
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    cd(save_cd)
   print(h1,'Notes_Bar_NC','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
   print(h1,'Paper_Bar_NC','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

function [p,parametric]=Comp2_Stats(x,y)
jbt1=jbtest(x);
jbt2=jbtest(y);
if ~jbt1 && ~jbt2 %both distributions are normal
    %do paired ttest
    [~,p]=ttest(x,y);
    parametric=1;
else
    %do paired non-para test
    [p,~]=signrank(x,y);
    parametric=0;
end