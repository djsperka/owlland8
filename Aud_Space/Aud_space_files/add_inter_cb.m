function add_inter_cb()

global snd multsnd list;
    
    total=length(multsnd);
    multsnd{total+1}= snd;
    
    for i=1:total+1
        list{i}= ['Interleaved trace #' num2str(i)];
    end
    
    set( findobj('tag','inter_tag'),'value', length(list) );
    set( findobj('tag','inter_tag'),'string', list );
    
return;
