function find_latency()
    global snd rec

    [x,y]=ginput(1);
        timecourse_type=get(findobj(gcf,'tag','time_course_II'),'value');

        
            time_array=[-snd.pre:snd.post];
    
    
    filt_n=1;

    
    
    if ismember(timecourse_type,[1])
            tc=histc(snd.datatime(find(snd.datachan==rec.dispch)),time_array);
            tc=tc/(length(snd.stim_list)*snd.reps);
            tctemp=filter2(ones(1,filt_n)/filt_n,tc,'valid');
            ldiff=length(tc)-length(tctemp);
            tc(ldiff+1:ldiff+length(tctemp))=tctemp;
        end   
        if ismember(timecourse_type,[2])
            tc=histc(snd.datatime_arr1(find(snd.datachan_arr1==rec.dispch)),time_array);
            tc=tc/(length(snd.Var1array)*snd.reps);
            tctemp=filter2(ones(1,filt_n)/filt_n,tc,'valid');
            ldiff=length(tc)-length(tctemp);
            tc(ldiff+1:ldiff+length(tctemp))=tctemp;
        end
        if ismember(timecourse_type,[3])
            tc=histc(snd.datatime_arr2(find(snd.datachan_arr2==rec.dispch)),time_array);
            tc=tc/(length(snd.Var2array)*snd.reps);
            tctemp=filter2(ones(1,filt_n)/filt_n,tc,'valid');
            ldiff=length(tc)-length(tctemp);
            tc(ldiff+1:ldiff+length(tctemp))=tctemp;
        end
        
        
        for i=[snd.pre:length(tc)]
            if tc(i)>y
                set(findobj(gcf,'tag','latency'),'string',num2str(time_array(i)));
                break
                break
            end
            if i==length(tc)
                set(findobj(gcf,'tag','latency'),'string','none');
            end
    
        end



return;
