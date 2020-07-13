function [dispmat,disparr1,disparr2]=Display_Calc
global snd rec
    %%  clear the graphs of previous best area plots.
    set_graphs(snd.reps)        
    
    %%%%%%%%%%%%%%% create the display graphs
    if snd.graph_type==1    %%display type is adjusted
        dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==2    %%display type is pre
        dispmat=snd.datamat_pre(:,:,rec.dispch)/snd.reps;   
    end
    if snd.graph_type==3    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;  
    end
    if snd.graph_type==4    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   
        dispmat=100*((dispmat-min(min(dispmat)))/(max(max(dispmat))-min(min(dispmat))));
    end
    
    

    if snd.interleave_alone==1
        if snd.graph_type==1    %%display type is adjusted
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
            disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        end
        if snd.graph_type==2    %%display type is pre
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;  
                disparr2=snd.data_arr2_pre(:,:,rec.dispch)/snd.reps;   
        end
        if snd.graph_type>=3    %%display type is post or normal// both should be normalized the same
            disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps;  
            disparr2=snd.data_arr2_post(:,:,rec.dispch)/snd.reps;  
        end
    else
        disparr2=NaN; %disparr1 gets taken care of lower down
    end
    
    if snd.inter_loom==1 %% Added by DJT 7/7/2013
        if snd.graph_type==1    %%display type is adjusted
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        end
        if snd.graph_type==2    %%display type is pre
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps; 
        end
        if snd.graph_type>=3    %%display type is post or normal// both should be normalized the same
            disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps; 
        end
    end
    
    if ~snd.inter_loom==1 && ~snd.interleave_alone==1
        disparr1=NaN;
    end
    %%%%%%%%%%%%%%% end of display graphs