function out=cont_V_strength(cont,display_chan)
    if nargin==0
        global cont
        figure(findobj(0,'tag','set_cont_win'));
        display_chan=get(findobj(gcf,'tag','display_chan'),'value');
    end

    
    N1=0;   %%firing rate 1 no data
    N2=0;   %%firing rate 2 no data
    R1=0; %%vector strength 1 no data
    R2=0; %%vector strength 2 no data
    
    
            if isfield(cont.spike_times{1},'chan')~=1  %% this adds chan field to data 
                    for k=1:length(cont.spike_times)
                        cont.spike_times{k}.chan{1}=cont.spike_times{k};
                    end
            end
    
	datatime=zeros(1,50000);
    spikes=0;
	for i=[1:cont.reps]                    
            datatime(spikes+1:length(cont.spike_times{i}.chan{display_chan})+spikes)=cont.spike_times{i}.chan{display_chan}/1000;
            spikes=spikes+length(cont.spike_times{i}.chan{display_chan});
    end
    
    if spikes>0
        datatime=datatime(1:spikes);
        dir1=[];
        for j=[1:2:cont.noise_hz]
            starttime=(j-1)*cont.time/cont.noise_hz;
            endtime=(j)*cont.time/cont.noise_hz;
            tempd=find(datatime>=starttime & datatime<=endtime);
            dir1(length(dir1)+1:length(dir1)+length(tempd))=tempd;  %%spikes during direction 1
        end
        dir2=setdiff([1:length(datatime)],dir1);    %%spikes during direction 2
        dir1_percent=length([1:2:cont.noise_hz])/cont.noise_hz;
        dir2_percent=length([2:2:cont.noise_hz])/cont.noise_hz;
        if length(dir1)>0    
            N1=length(dir1)/cont.time/cont.reps/dir1_percent;   %%firing rate 1
            R1=vector_strength(datatime(dir1),cont.time/cont.noise_hz); %%vector strength 1
        end    
        if length(dir2)>0    
            N2=length(dir2)/cont.time/cont.reps/dir2_percent;   %%firing rate 2
            R2=vector_strength(datatime(dir2),cont.time/cont.noise_hz); %%vector strength 2
        end
    end
    
    
    set(findobj(gcf,'tag','vs_label_l'),'string',round(R1*100)/100);
    set(findobj(gcf,'tag','vs_label_r'),'string',round(R2*100)/100);
    drawnow
    out=[N1,N2,R1,R2];