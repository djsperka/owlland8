function Rate_NC_Relationship(rates,nc,site_source,mt_labels)
%use this function to determine if there is a relationship between the
%firing rates of the population and the noise correlations being measured

% Assemble response pairs
% Make them all positive w/ absolute value
% Perform linear regression between response pairs and noise correlations
% Calculate difference (or ratio) between Condition 2 and Condition 1
% Relate differences/ratios for responses and noise correlations 
% Show relationship between conditional values and changes in values

% The next steps with this script would be to change all the title/axis
% labels to generate the appropriate text depending on the conditions you
% are interested in.  Currently it is just hardwired to display results for
% cond2=looming and cond1=static


%% Make vector for pairs of firing rates
pair_counter=0;
resp_counter=0;
store_chans=nan(size(nc));
% site_source keeps track of how many units came from each cohort
for num_units=site_source
    if num_units>0 %if there were no units from this site, then resp_counter 
        % will increment by 1 when there actually isn't a rate stored at that value
        % added 7/8/15 DJT
        for i=1:num_units-1;
            resp_counter=resp_counter+1;
            for j=i+1:num_units;
                pair_counter=pair_counter+1;
                store_chans(pair_counter,:)=[resp_counter,resp_counter+j-i];
            end
        end
        resp_counter=resp_counter+1;
    end
end

resp_pairs1=[rates(store_chans(:,1),1),rates(store_chans(:,2),1)];
resp_pairs2=[rates(store_chans(:,1),2),rates(store_chans(:,2),2)];

%%%%%%%%% Normal or absolute value of responses

%normal
% rp_ord1=sort(resp_pairs1,2);
% rp_ord2=sort(resp_pairs2,2);

% %abs
rp_ord1=sort(abs(resp_pairs1),2);
rp_ord2=sort(abs(resp_pairs2),2);

%%%%%%%%%%%%%% need sorted for minimum rate; for both ameans and gmeans
%%%%%%%%%%%%%% still want absolute value, and order doesn't matter
rp_mins=[rp_ord1(:,1),rp_ord2(:,1)]; %minimum rate in pair
rp_ameans=[mean(rp_ord1,2),mean(rp_ord2,2)]; %arithmetic mean of pair
rp_gmeans=[sqrt(prod(rp_ord1,2)),sqrt(prod(rp_ord2,2))]; %geometric mean of pair\
% abs_pairs1=abs(resp_pairs1);
% abs_pairs2=abs(resp_pairs2);
% rp_dindx1=(abs_pairs1(:,1)-abs_pairs1(:,2) )./ (abs_pairs1(:,1)+abs_pairs1(:,2));
% rp_dindx2=(abs_pairs2(:,1)-abs_pairs2(:,2) )./ (abs_pairs2(:,1)+abs_pairs2(:,2));



%% Perform Simple Linear Regression

fprintf('\n')
linreg_single=input ('Show linear regression? (0/1) : '); %show simple linear regression?
while linreg_single~=1 && linreg_single~=0
    fprintf('\nAnswer must be 1 or 0\n')
    linreg_single=input ('Show linear regression? (0/1) : '); %show simple linear regression?
end
if linreg_single
    plot_corrs(rp_mins(:),nc(:),'Minimum',mt_labels)
    title ('Minimum Response vs Noise Correlation')
    
    plot_corrs(rp_ameans(:),nc(:),'Arithmetic Mean',mt_labels)
    title ('Arithmetic Mean of Response vs Noise Correlation')
    
    plot_corrs(rp_gmeans(:),nc(:),'Geometric Mean',mt_labels)
    title ('Geometric Mean of Response vs Noise Correlation')
    
end

%% Perform ANCOVA
do_ancova=input('Would you like to regress out one of your conditions?(1/0)  :  ');
while do_ancova~=1 && do_ancova~=0
    fprintf('\nSorry, you must select 1 or 0\n')
    do_ancova=input('Would you like to regress out one of your conditions?(1/0)  :  ');
end

if do_ancova
    cond=cell(size(nc));
    cond(:,1)=mt_labels(1);
    cond(:,2)=mt_labels(2);
    rp_gmeans;
    nc;
    cond;
    
    fprintf('\nPausing to let you mannually run some ANCOVAs')
    fprintf ('\n----USEFUL COMMANDS------')
    fprintf('\n--running the anocava--')
    fprintf('\n%%%%with squart root%%%%')
    fprintf('\naoctool(sqrt(rp_gmeans(:)),nc(:),cond(:),.05,''sqrt(Resp (Geo. Mean))'',''Noise Corr'',''Stim Cond'');')
    fprintf('\n%%%%withOUT squart root%%%%')
    fprintf('\naoctool(rp_gmeans(:),nc(:),cond(:),.05,''Resp (Geo. Mean)'',''Noise Corr'',''Stim Cond'');')
    fprintf('\n[~,~,~,stats]=aoctool(rp_gmeans(:),nc(:),cond(:),.05,''Resp (Geo. Mean)'',''Noise Corr'',''Stim Cond'',''off'',''parallel lines'');')
    fprintf('\n[~,~,~,stats]=aoctool(rp_gmeans(:),nc(:),cond(:),.05,''Resp (Geo. Mean)'',''Noise Corr'',''Stim Cond'',''off'',''separate lines'');')
    fprintf('\n--doing some stats ... just cut and paste all--')
    fprintf('\n[c,~,~,nms]=multcompare(stats);')
    fprintf('\nout_desc={''Cat1'',''Cat2'',''Lower Percentile'',''Mean'',''Upper Percentile'',''h(Cat1=Cat2)''};')
    fprintf('\n[out_desc;[nms(c(:,[1 2]))], num2cell([c(:,3:end),(c(:,3)<0 & c(:,5)>0)]) ]')
    fprintf('\n')
    
    keyboard

end


%% Calculate Change from Condition 1 to Condition 2

% Try looking at the difference in rates and noise correlations and see
% if there is a relationship between them
half=length(rp_ameans)/2;

fprintf('\n1=Cond2-Cond1 \n2=Cond2/Cond1 \n3=(Cond2-Cond1)/(Cond2+Cond1) \n')
change_metric=input('What do you want for a change metric? : ');
while ~(change_metric==1 || change_metric==2 || change_metric==3)
    fprintf('\nSorry, you gotta choose 1, 2 or 3\n')
    change_metric=input('What do you want for a change metric? : ');
end
switch change_metric
    case 1 %Difference
        delta_resp_am=rp_ameans(:,2)-rp_ameans(:,1);
        delta_resp_gm=rp_gmeans(:,2)-rp_gmeans(:,1);
        delta_resp_min=rp_mins(:,2)-rp_mins(:,1);
        
%         delta_nc=nc(:,2)-nc(:,1);
        
    case 2 %Ratio
        delta_resp_am=rp_ameans(:,2)./rp_ameans(:,1);
        delta_resp_gm=rp_gmeans(:,2)./rp_gmeans(:,1);
        delta_resp_min=rp_mins(:,2)./rp_mins(:,1);
        
%         delta_nc=nc(:,2)./nc(:,1);
        
    case 3 %Difference Indx
        delta_resp_am=(rp_ameans(:,2)-rp_ameans(:,1))./ (rp_ameans(:,2)+rp_ameans(:,1));
        delta_resp_gm=(rp_gmeans(:,2)-rp_gmeans(:,1))./(rp_gmeans(:,2)+rp_gmeans(:,1));
        delta_resp_min=(rp_mins(:,2)-rp_mins(:,1))./(rp_gmeans(:,2)+rp_gmeans(:,1));
        
%         delta_nc=(abs(nc(:,2))-abs(nc(:,1)))./abs((nc(:,2))+abs(nc(:,1)));
        
end

delta_nc=nc(:,2)-nc(:,1);

%% Look at distribution of mean and pairwise responses
if input('Print Pairwise Responses to Screen? (0/1) : ')
    
    fprintf ('\n\n------Response Minimum')
    fprintf ('\nSmean\tLmean \tpVal')
    [~,p]=ttest(rp_mins(:,1),rp_mins(:,2));
    fprintf('\n%.2f\t%.2f\t%.4f',mean(rp_mins(:,1)),mean(rp_mins(:,2)),p)
    
    fprintf('\n\n-------Response Arithmetic Mean')
    fprintf ('\nSmean\tLmean')
    [~,p]=ttest(rp_ameans(:,1),rp_ameans(:,2));
    fprintf('\n%.2f\t%.2f\t%.4f',mean(rp_ameans(:,1)),mean(rp_ameans(:,2)),p)
    
    fprintf('\n\n-------Response Geometric Mean')
    fprintf ('\nSmean\tLmean')
    [~,p]=ttest(rp_gmeans(:,1),rp_gmeans(:,2));
    fprintf('\n%.2f\t%.2f\t%.4f',mean(rp_gmeans(:,1)),mean(rp_gmeans(:,2)),p)
    fprintf('\n')
    
    pause
end

   
%% Plot Changes from Condition 1 to Condition 2
    
fprintf('\n')
show_loomstat=input ('Show (Loom-Stat) for Responses and Noise Correlations? (0/1) : '); %show simple linear regression?
while show_loomstat~=1 && show_loomstat~=0
    fprintf('\nAnswer must be 1 or 0\n')
    show_loomstat=input ('Show (Loom-Stat) for Responses and Noise Correlations? (0/1) : '); %show simple linear regression?
end
if show_loomstat
    
    
    [dam_corr,dam_p]=corr(delta_resp_am,delta_nc);
    figure
    plot (delta_resp_am,delta_nc,'o');
    title (sprintf('Change in Response Arithmetic Mean vs Noise Correlation for %s vs %s',mt_labels{1},mt_labels{2}))
    switch change_metric
        case 1
            xlabel (sprintf('RAM(%s) - RAM(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
        case 2
            xlabel (sprintf('RAM(%s) / RAM(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) / NC(%s)',mt_labels{2},mt_labels{1}))            
        case 3
            xlabel (sprintf('( RAM(%s) - RAM(%s) )/(RAM(%s) + RAM(%s))',mt_labels{2},mt_labels{1},mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('( NC(%s) - NC(%s) )/( NC(%s) + NC(%s) )',mt_labels{2},mt_labels{1},mt_labels{2},mt_labels{1}))            
    end    
    ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
    legend (sprintf('rho=%.3f :: p=%.04f',dam_corr,dam_p))
    
    
    [dgm_corr,dgm_p]=corr(delta_resp_gm,delta_nc);
    figure
    plot (delta_resp_gm,delta_nc,'o');
    title (sprintf('Change in Response Geometric Mean vs Noise Correlation for %s vs %s',mt_labels{1},mt_labels{2}))
    switch change_metric
        case 1
            xlabel (sprintf('RGM(%s) - RGM(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
        case 2
            xlabel (sprintf('RGM(%s) / RGM(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) / NC(%s)',mt_labels{2},mt_labels{1}))            
        case 3
            xlabel (sprintf('( RGM(%s) - RGM(%s) )/(RGM(%s) + RGM(%s))',mt_labels{2},mt_labels{1},mt_labels{2},mt_labels{1}))
    end
    ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
    legend (sprintf('rho=%.3f :: p=%.04f',dgm_corr,dgm_p))
    
    [dmi_corr,dmi_p]=corr(delta_resp_min,delta_nc);
    figure
    plot (delta_resp_min,delta_nc,'o');
    title (sprintf('Change in Response Minimum vs Noise Correlation for %s vs %s',mt_labels{1},mt_labels{2}))
    switch change_metric
        case 1
            xlabel (sprintf('Rmin(%s) - Rmin(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
        case 2
            xlabel (sprintf('Rmin(%s) / Rmin(%s)',mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('NC(%s) / NC(%s)',mt_labels{2},mt_labels{1}))            
        case 3
            xlabel (sprintf('( Rmin(%s) - Rmin(%s) )/(Rmin(%s) + Rmin(%s))',mt_labels{2},mt_labels{1},mt_labels{2},mt_labels{1}))
%             ylabel (sprintf('( NC(%s) - NC(%s) )/( NC(%s) + NC(%s) )',mt_labels{2},mt_labels{1},mt_labels{2},mt_labels{1}))            
    end
    ylabel (sprintf('NC(%s) - NC(%s)',mt_labels{2},mt_labels{1}))
    legend (sprintf('rho=%.3f :: p=%.04f',dmi_corr,dmi_p))
    
    [~,p_ratechange]=ttest(rates(:,1),rates(:,2));
    [~,p_ncchange]=ttest(nc(:,1),nc(:,2));
    
    fprintf ('\nTESTING HYPOTHESES')
    fprintf('\nResp(%s)==Resp(%s) :: p=%.4f',mt_labels{1},mt_labels{2},p_ratechange)
    fprintf('\nNC(%s)==NC(%s) :: p=%.4f\n\n',mt_labels{1},mt_labels{2},p_ncchange)
end

%% See if Dot Product has Changed ... do noise correlation changes and response changes selectively NOT overlap??

fprintf('\n')
resp_nc_overlap=input ('Check if Response Changes and Noise Correlation Changes occur randomly? (0/1) : '); %show simple linear regression?
while linreg_single~=1 && linreg_single~=0
    fprintf('\nAnswer must be 1 or 0\n')
    resp_nc_overlap=input ('Check if Response Changes and Noise Correlation Changes occur randomly? (0/1) : '); %show simple linear regression?
end
if resp_nc_overlap  
    
    % Take absolute value of vectors
    drmin_abs=abs(delta_resp_min);
    dram_abs=abs(delta_resp_am);
    drgm_abs=abs(delta_resp_gm);
    dnc_abs=abs(delta_nc);
    
    % Normalize vectors
    drmin_abs=drmin_abs/(drmin_abs'*drmin_abs)^.5;
    dram_abs=dram_abs/(dram_abs'*dram_abs)^.5;
    drgm_abs=drgm_abs/(drgm_abs'*drgm_abs)^.5;
    dnc_abs=dnc_abs/(dnc_abs'*dnc_abs)^.5;
    
    % Calculate raw dot products
    raw_dp_dmi=drmin_abs'*dnc_abs;
    raw_dp_dam=dram_abs'*dnc_abs;
    raw_dp_dgm=drgm_abs'*dnc_abs;
    
    % Calculate shuffle dot products
    nshuff=10000;
    shuff_dps_dmi=nan(nshuff,1);
    shuff_dps_dam=nan(nshuff,1);
    shuff_dps_dgm=nan(nshuff,1);
%     figure
%     hold on
    for i=1:nshuff
        delta_nc_shuff=dnc_abs(randperm(length(dnc_abs)));
%         plot (delta_resp_min,delta_nc_shuff,'.')
        shuff_dps_dmi(i)=drmin_abs'*delta_nc_shuff;
        shuff_dps_dam(i)=dram_abs'*delta_nc_shuff;
        shuff_dps_dgm(i)=drgm_abs'*delta_nc_shuff;
    end
    
    %%% plot for minimum response change
    perc_dmi=100*sum(shuff_dps_dmi<raw_dp_dmi) / nshuff;
    figure
    hist (shuff_dps_dmi)
    hold on
    plot ([raw_dp_dmi,raw_dp_dmi],[0,max(get(gca,'ylim'))],':r')
    hold off
    xlabel('dResp (dot) dNC')
    ylabel(sprintf('Count ... %.0f shuffles total',nshuff))
    title (sprintf ('Dot Product of Change in Minimum Response and Change in NC w/ bootstrap'))
    legtxt{1}=sprintf('dNC Shuffle Dot Product Frequency');
    legtxt{2}=sprintf('raw Dot Product: %.2f \n%.1f percentile',raw_dp_dmi,perc_dmi);
    legend (legtxt)
    
    
    %%% plot for arithmetic mean response change
    perc_dam=100*sum(shuff_dps_dam<raw_dp_dam) / nshuff;
    figure
    hist (shuff_dps_dam)
    hold on
    plot ([raw_dp_dam,raw_dp_dam],[0,max(get(gca,'ylim'))],':r')
    hold off
    xlabel('dResp (dot) dNC')
    ylabel(sprintf('Count ... %.0f shuffles total',nshuff))
    title (sprintf ('Dot Product of Change in Arithmetic Mean Response and Change in NC w/ bootstrap'))
    legtxt{1}=sprintf('dNC Shuffle Dot Product Frequency');
    legtxt{2}=sprintf('raw Dot Product: %.2f \n%.1f percentile',raw_dp_dam,perc_dam);
    legend (legtxt)
    
    
    %%% plot for geometric mean response change
    perc_dgm=100*sum(shuff_dps_dgm<raw_dp_dgm) / nshuff;
    figure
    hist (shuff_dps_dgm)
    hold on
    plot ([raw_dp_dgm,raw_dp_dgm],[0,max(get(gca,'ylim'))],':r')
    hold off
    xlabel('dResp (dot) dNC')
    ylabel(sprintf('Count ... %.0f shuffles total',nshuff))
    title (sprintf ('Dot Product of Change in Geometric Mean Response and Change in NC w/ bootstrap'))
    legtxt{1}=sprintf('dNC Shuffle Dot Product Frequency');
    legtxt{2}=sprintf('raw Dot Product: %.2f \n%.1f percentile',raw_dp_dgm,perc_dgm);
    legend (legtxt)
    
end

initial_vs_change=input ('Check if [Static or Loom] [Resp Min, Resp Geo Mean or NC] predict Change in [Resp Min, Geo Mean or NC]? (0/1) : '); %show simple linear regression?
while initial_vs_change~=1 && initial_vs_change~=0
    fprintf('\nAnswer must be 1 or 0\n')
    initial_vs_change=input ('Check if [Static or Loom] [Resp Min, Resp Geo Mean or NC] predict Change in [Resp Min, Geo Mean or NC]? (0/1) : '); %show simple linear regression?
end
if initial_vs_change
    
    %%% Does Static or Looming Response Predict Response Change
    %Use Reponse Min
    figure
    plot (rp_mins(:,1),delta_resp_min,'o')
    xlabel ('Min Resp Static')
    ylabel ('Change in Min Resp')
    title ('Static Response Minimum vs Change in Resp Min')
    
    figure
    plot (rp_mins(:,2),delta_resp_min,'o')
    xlabel('Min Resp Loom')
    ylabel('Change in Min Resp')
    title ('Looming Response Min vs Change in Resp Min')
    
    figure
    plot (rp_gmeans(:,1),delta_resp_gm,'o')
    xlabel ('Geo Mean Static')
    ylabel ('Change in Geo Mean')
    title ('Static Response Geometric Mean vs Change in Geo Mean')
    
    figure
    plot (rp_gmeans(:,2),delta_resp_gm,'o')
    xlabel ('Geo Mean Loom')
    ylabel ('Change in Geo Mean')
    title ('Loom Response Geometric Mean vs Change in Geo Mean')
    
    %%% Do static or looming noise correlations predict change in
    %%% response
    % use response min
    figure
    plot(nc(:,1),delta_resp_min,'o')
    xlabel ('Static Noise Correlation')
    ylabel ('Change in Response Min')
    title ('Static Noise Correlation vs Change in Resp Min')
    
    figure
    plot(nc(:,2),delta_resp_gm,'o')
    xlabel ('Looming Noise Correlation')
    ylabel ('Change in Response Geo Mean')
    title ('Looming Noise Correlation vs Change in Resp Geo Mean')
    
    % use response geo mean
    figure
    plot(nc(:,1),delta_resp_gm,'o')
    xlabel ('Static Noise Correlation')
    ylabel ('Change in Response Geo Mean')
    title ('Static Noise Correlation vs Change in Resp Geo Mean')
    
    figure
    plot(nc(:,2),delta_resp_min,'o')
    xlabel ('Looming Noise Correlation')
    ylabel ('Change in Response Min')
    title ('Looming Noise Correlation vs Change in Resp Min')
    
    %%% Do initial response magnitudes predict change in noise
    %%% correlation?
    % Use Resp Min
    figure
    plot(rp_mins(:,1),delta_nc,'o')
    xlabel ('Static Min Response')
    ylabel ('Change in Noise Correlation')
    title ('Static Response Min vs. Change in Noise Correlation')
    
    figure
    plot(rp_gmeans(:,1),delta_nc,'o')
    xlabel ('Static Geometric Mean')
    ylabel ('Change in Noise Correlation')
    title ('Static Response Geo. Mean vs. Change in Noise Correlation')
    
    % Use Geo Mean
    figure
    plot(rp_mins(:,2),delta_nc,'o')
    xlabel ('Loom Min Response')
    ylabel ('Change in Noise Correlation')
    title ('Loom Response Min vs. Change in Noise Correlation')
    
    figure
    plot(rp_gmeans(:,2),delta_nc,'o')
    xlabel ('Loom Geometric Mean')
    ylabel ('Change in Noise Correlation')
    title ('Loom Response Geo. Mean vs. Change in Noise Correlation')
    
end



function plot_corrs(x,y,type,mt_labels)

x1=x(1:length(x)/2);
x2=x(length(x)/2+1:end);
y1=y(1:length(y)/2);
y2=y(length(y)/2+1:end);

figure

hold on
plot (x1,y1,'ro')
plot (mean(x1),mean(y1),'rx','MarkerSize',15)
plot (x2,y2,'bo')
plot (mean(x2),mean(y2),'bx','MarkerSize',15)
[rho,pcorr]=corr(x,y);
pfit=polyfit(x,y,1);
plot ([min(x) max(x)],[min(x)*pfit(1)+pfit(2),max(x)*pfit(1)+pfit(2)],':r');
xlabel (sprintf('%s (Response)',type))
ylabel ('Noise Correlation')

leg{1}=sprintf('Resp(%s) vs NC(%s) ... %.0f Pairs',mt_labels{1},mt_labels{1},length(y1));
leg{2}=sprintf('Mean(%s): (%.2f , %.2f)',mt_labels{1},mean(x1),mean(y1));
leg{3}=sprintf('Resp(%s) vs NC(%s) ... %.0f Pairs',mt_labels{2},mt_labels{2},length(y2));
leg{4}=sprintf('Mean(%s): (%.2f , %.2f)',mt_labels{2},mean(x2),mean(y2));
leg{5}=sprintf('y=%.2f + %.2f*x\nrho=%.2f  p=%.4f',pfit(2),pfit(1),rho,pcorr);
legend(leg)
hold off

