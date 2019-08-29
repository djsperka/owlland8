function add_cont_cb()

global cont multcont list;
 

    total=length(multcont);
    
%     if total > 0 && multcont{total}.reps ~= cont.reps  
%        'make reps equal in each loaded trace' 
%         
%     else

        multcont{total+1}= cont;
% %  multcont{total+1}.ITD_min       
        for i=1:total+1
            list{i}= ['Interleaved trace #' num2str(i)];
        end
        
        set(findobj('tag','inter_cont_tag'),'value', length(list) );
        set(findobj('tag','inter_cont_tag'),'string', list );
%     end
return;
