function run_one_cont()

global cont multcont list;
 

    multcont={};    
    set( findobj('tag','inter_tag'),'string', {} );
    multcont{1}= cont;

    run_cont_tuning_curve;
    
return;
