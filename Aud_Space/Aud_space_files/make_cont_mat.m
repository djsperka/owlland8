function make_cont_mat(visdiv,ITDdiv,chan)
    global cont;

    %%Matrices are in the form of mat(chan,Sweep,visdiv,ITDdiv,visdir,ITDdir)    
    
    
    histmat=zeros(chan,cont.reps*cont.noise_hz,visdiv+1,ITDdiv+1,2,2);   %%make a matrix for spike data
    histtime=zeros(size(histmat));   %%make a matrix for time
    
    
    
    vis_list=zeros(cont.reps,60*cont.time+1);
    spike_list=zeros(cont.reps,chan,60*cont.time+1);
    ITD_list=zeros(cont.reps,60*cont.time+1);

    vis_dir_list=zeros(cont.reps,60*cont.time);
    ITD_dir_list=zeros(cont.reps,60*cont.time);
    sweep_list=zeros(cont.reps,60*cont.time);
    
    
    

    for i=[1:cont.reps]
        for j=[1:chan]
            if length(cont.spike_times{i}.chan{j})
                spike_list(i,j,:)=histc(cont.spike_times{i}.chan{j}/1000,[0:1/60:cont.time]);%%resample spikes at vis rate and form matrix
            end
            vis_list(i,:)=cont.vis_pos_array{i}(1,:);%%order vis into a matrix
            vis_dir_list(i,:)=diff(vis_list(i,:));%%order vis direction into a matrix
            ITD_list(i,:)=interp1([0:1/500:cont.time], cont.ITD_pos{i},[0:1/60:cont.time], 'linear' );%%resample ITD at vis rate and form matrix
            ITD_dir_list(i,:)=diff(ITD_list(i,:)); %%ITD direction
        end
    end
    
    %%divide ITD and vis Direction into right and left
    visleft=find(vis_dir_list<0);
    ITDleft=find(ITD_dir_list<0);
    vis_dir_list=ones(size(vis_dir_list))*2;
    ITD_dir_list=ones(size(ITD_dir_list))*2;
    vis_dir_list(visleft)=1;
    ITD_dir_list(ITDleft)=1;

    
    
    dir=ITD_dir_list(1,1);
    sweep=0;
    for i=[1:cont.reps]
        if dir==ITD_dir_list(i,1)   %%inc sweep for first rep as well as odd noise_hz curves
            sweep=sweep+1; 
        end

        for j=[1:size(ITD_dir_list,2)]
            if dir~=ITD_dir_list(i,j)
                sweep=sweep+1;          %% inc sweep when direction changes
                dir=ITD_dir_list(i,j);  %% save new direction
            end
            sweep_list(i,j)=sweep;
        end
    end        

    
    %%this is probably where the fix for sweeps should go
    %%%make each rep a sweep
    if or(cont.motion_type==1,cont.motion_type==3)
        for i=[1:cont.reps]
            sweep_list(i,:)=i*ones(1,size(sweep_list,2));
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%pointers to the appropriate vis and ITD bins
    vis_list=floor((vis_list-cont.az_min)/(cont.az_max-cont.az_min)*visdiv)+1;  
    ITD_list=floor(((ITD_list-cont.ITD_offset)-cont.ITD_min)/(cont.ITD_max-cont.ITD_min)*ITDdiv)+1;
    
    
    
    for cur_chan=[1:chan] %%run through the channels there is one channel
        for i=[1:size(ITD_dir_list,1)]
            for j=[1:size(ITD_dir_list,2)]
                histmat(cur_chan,sweep_list(i,j),vis_list(i,j),ITD_list(i,j),vis_dir_list(i,j),ITD_dir_list(i,j))=histmat(cur_chan,sweep_list(i,j),vis_list(i,j),ITD_list(i,j),vis_dir_list(i,j),ITD_dir_list(i,j))+spike_list(i,cur_chan,j);  %%  spikes hist
                histtime(cur_chan,sweep_list(i,j),vis_list(i,j),ITD_list(i,j),vis_dir_list(i,j),ITD_dir_list(i,j))=histtime(cur_chan,sweep_list(i,j),vis_list(i,j),ITD_list(i,j),vis_dir_list(i,j),ITD_dir_list(i,j))+(1/60);           %%  time hist
            end
        end
    end %%end chan 1

    cont.histmat=histmat(:,:,1:visdiv,1:ITDdiv,:,:);
    cont.histtime=histtime(:,:,1:visdiv,1:ITDdiv,:,:);
    
    
    
return;