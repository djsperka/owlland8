 function set_range_window()
    global snd rec;
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','var1_ba'),'string','');
        set(findobj(gcf,'tag','var2_ba'),'string','');
        set(findobj(gcf,'tag','var1_width'),'string','');
        set(findobj(gcf,'tag','var2_width'),'string','');
        set(findobj(gcf,'tag','var1_alone_ba'),'string','');
        set(findobj(gcf,'tag','var2_alone_ba'),'string','');
        set(findobj(gcf,'tag','var1_alone_width'),'string','');
        set(findobj(gcf,'tag','var2_alone_width'),'string','');
        
        set(findobj(gcf,'tag','Var1_alone_ba_label'),'string','');
        set(findobj(gcf,'tag','Var2_alone_ba_label'),'string','');
        set(findobj(gcf,'tag','Var1_ba_label'),'string','');
        set(findobj(gcf,'tag','Var2_ba_label'),'string','');
        set(findobj(gcf,'tag','Var1_alone_label'),'string','');
        set(findobj(gcf,'tag','Var2_alone_label'),'string','');

        
            snd.posttime=snd.rangemax-snd.rangemin;
            set(findobj(gcf,'tag','rangemax'),'string',snd.rangemax);
            set(findobj(gcf,'tag','rangemin'),'string',snd.rangemin);
    

%     if or(length(snd.datatime)>0,length(snd.datatime_arr1)>0)       %%if there is data
      if length(snd.datatime)>0       %%if there is data
      
        if snd.Var2==7      %%clear all of the neccessary summary matrices
            snd.datamat_pre = zeros(1,length(snd.Var1array),rec.numch);
            snd.datamat_post = snd.datamat_pre;
          else
            snd.datamat_pre = zeros(length(snd.Var2array),length(snd.Var1array),rec.numch);
            snd.datamat_post = snd.datamat_pre;
            if snd.interleave_alone==1
                snd.data_arr1_pre = zeros(2,length(snd.Var1array),rec.numch);
                snd.data_arr1_post = snd.data_arr1_pre;
                snd.data_arr2_pre = zeros(length(snd.Var2array),2,rec.numch);
                snd.data_arr2_post = snd.data_arr2_pre;
            end
        end;
        
        
        %%make datamat_pre and datamat_post
        for var2=[1:size(snd.datamat_pre,1)]
            for var1=[1:size(snd.datamat_pre,2)]
                for ch=[1:size(snd.datamat_pre,3)]
                    if snd.Var2~=7
                        prespikes=length(find(snd.datatime<0 & snd.datachan==ch & snd.dataVar1==snd.Var1array(var1) & snd.dataVar2==snd.Var2array(var2)));
                        postspikes=length(find(snd.datatime>=snd.rangemin & snd.datatime<=snd.rangemax & snd.datachan==ch & snd.dataVar1==snd.Var1array(var1) & snd.dataVar2==snd.Var2array(var2)));
                       else
                        prespikes=length(find(snd.datatime<0 & snd.datachan==ch & snd.dataVar1==snd.Var1array(var1)));
                        postspikes=length(find(snd.datatime>=snd.rangemin & snd.datatime<=snd.rangemax & snd.datachan==ch & snd.dataVar1==snd.Var1array(var1)));
                    end
                    snd.datamat_pre(var2,var1,ch)=prespikes;
                    snd.datamat_post(var2,var1,ch)=postspikes;
                end
            end
        end
        
        if snd.interleave_alone==1
                %%make data_arr1_pre and data_arr1_post
                for var1=[1:size(snd.data_arr1_pre,2)]
                    for ch=[1:size(snd.data_arr1_pre,3)]
                        prespikes=length(find(snd.datatime_arr1<0 & snd.dataVar1_arr1==snd.Var1array(var1)));
                        postspikes=length(find(snd.datatime_arr1>=snd.rangemin & snd.datatime_arr1<=snd.rangemax & snd.dataVar1_arr1==snd.Var1array(var1)));
                        snd.data_arr1_pre(:,var1,ch)=prespikes;
                        snd.data_arr1_post(:,var1,ch)=postspikes;
                    end
                end
                %%make data_arr2_pre and data_arr2_post
                for var2=[1:size(snd.data_arr2_pre,1)]
                    for ch=[1:size(snd.data_arr2_pre,3)]
                        prespikes=length(find(snd.datatime_arr2<0 & snd.dataVar2_arr2==snd.Var2array(var2)));
                        postspikes=length(find(snd.datatime_arr2>=snd.rangemin & snd.datatime_arr2<=snd.rangemax & snd.dataVar2_arr2==snd.Var2array(var2)));
                        snd.data_arr2_pre(var2,:,ch)=prespikes;
                        snd.data_arr2_post(var2,:,ch)=postspikes;
                    end
                end
        end
        set_graphs;
    end;
return;