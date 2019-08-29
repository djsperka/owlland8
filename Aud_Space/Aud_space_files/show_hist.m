function show_hist()

    %%%
    global snd rec;
    h=findobj(gcf,'tag','hist');
    hist_type=get(h,'value');
    snd.graph_num=snd.graph_num+1;
    
    graphsize=((get(0,'screensize')-[0,0,0,32])/2);
    x_offset=mod(snd.graph_num-1,2);
    y_offset=floor(mod(((snd.graph_num-1)/2),2));
    x_inc=graphsize(3);
    y_inc=graphsize(4);
    
    graphlocation=graphsize+(x_offset*[x_inc,0,0,0])+(y_offset*[0,y_inc,0,0])+[4,32,0,0];
    
    
    switch  snd.graph_type
        case 1
            dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        case 2
            dispmat=snd.datamat_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and devide by reps
        case 3
            dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and devide by reps
        case 4
            tempmax=max(max(snd.datamat_post(:,:,rec.dispch)));
            tempmin=max(max(snd.datamat_post(:,:,rec.dispch)));
            dispmat=(((snd.datamat_post(:,:,rec.dispch)-tempmin)*100)/(tempmax-tempmin));
    end
    myrange=[min(min(dispmat)),max(max(dispmat))];

    if snd.interleave_alone==1      %%if there were interleaved trials of single variables
        switch  snd.graph_type
            case 1
                disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
                disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
            case 2
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
                disparr2=snd.data_arr2_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
            case 3
                disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
                disparr2=snd.data_arr2_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
            case 4
                tempmax=max([max(max(snd.datamat_post(:,:,rec.dispch))),max(max(snd.data_arr1_post(:,:,rec.dispch))),max(max(snd.data_arr2_post(:,:,rec.dispch)))]);
                tempmin=min([min(min(snd.datamat_post(:,:,rec.dispch))),min(min(snd.data_arr1_post(:,:,rec.dispch))),min(min(snd.data_arr2_post(:,:,rec.dispch)))]);
                dispmat=(((snd.datamat_post(:,:,rec.dispch)-tempmin)*100)/(tempmax-tempmin));
                disparr1=(((snd.data_arr1_post(:,:,rec.dispch)-tempmin)*100)/(tempmax-tempmin));
                disparr2=(((snd.data_arr2_post(:,:,rec.dispch)-tempmin)*100)/(tempmax-tempmin));
        end
        myrange=[min([min(min(disparr1)),min(min(disparr2)),min(min(dispmat))]),max([max(max(disparr2)),max(max(disparr1)),max(max(dispmat))])];
    end
        
    
    switch hist_type
        case 1
            figure(findobj(0,'tag','disp_win_1'));     %% set the third window as active
            [x,y]=ginput(1);
            temparray=abs(snd.Var2array-y);
            hist_position=find(temparray==min(temparray));
            figure('menubar','none','position',graphlocation);
            
            bar(snd.Var1array,dispmat(hist_position,:));
            xlabel(snd.Var1_choices(snd.Var1));
            ylabel('spikes');
            set(gca,'ylim',myrange)
            set(gca,'xlim',[min(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))]);
            title([char(snd.Var2_choices(snd.Var2)) ' = ' num2str(snd.Var2array(hist_position)) '    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
        case 2
            figure(findobj(0,'tag','disp_win_1'));     %% set the third window as active
            [x,y]=ginput(1);
            temparray=abs(snd.Var1array-x);
            hist_position=find(temparray==min(temparray));
            figure('menubar','none','position',graphlocation);
            
            bar(snd.Var2array,dispmat(:,hist_position));
            xlabel(snd.Var2_choices(snd.Var2));
            ylabel('spikes');
            set(gca,'ylim',myrange)
            set(gca,'xlim',[min(snd.Var2min-(0.5*snd.Var2step)),(snd.Var2max+(0.5*snd.Var2step))]);
            title([char(snd.Var1_choices(snd.Var1)) ' = ' num2str(snd.Var1array(hist_position)) '    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
        case 4
            figure('menubar','none','position',graphlocation);
            bar(snd.Var1array,disparr1(1,:));
            xlabel(snd.Var1_choices(snd.Var1));
            ylabel('spikes');
            set(gca,'ylim',myrange)
            set(gca,'xlim',[min(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))]);
            title([char(snd.Var1_choices(snd.Var1)),' Alone','    Trace = ',num2str(snd.trace),'   channel = ',num2str(rec.dispch)]);
        case 5
            figure('menubar','none','position',graphlocation);
            
            bar(snd.Var2array,disparr2(:,1));
            xlabel(snd.Var2_choices(snd.Var2));
            ylabel('spikes');
            set(gca,'ylim',myrange)
            set(gca,'xlim',[min(snd.Var2min-(0.5*snd.Var2step)),(snd.Var2max+(0.5*snd.Var2step))]);
            title([char(snd.Var2_choices(snd.Var2)),' Alone','    Trace = ',num2str(snd.trace),'   channel = ',num2str(rec.dispch)]);
    end    

    c=get(gcf,'color');
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.02 .05 .08 .05],...
        'horizontalalignment','center',...
        'string','Close',...
        'callback','close_graph;');






return;
