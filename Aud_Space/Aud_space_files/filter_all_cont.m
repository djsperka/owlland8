function filter_all_cont(vs_cutoff)
     global savecont
    
    currentdir=pwd;
    folder = uigetdir('C:\Documents and Settings\Joe\Desktop', 'Choose DATA Directory   (All files must be cont files!)');
    filtdir = uigetdir('C:\Documents and Settings\Joe\Desktop', 'Choose Destination Directory');
    
    files=dir(folder);  %%files 1 and 2 are void
    
    nfiles=length(files)
    
    filtcont={};
    for i=[3:nfiles]
        cd(folder)
        load(files(i).name)
        cd(currentdir)
        filtcont=filter_cont(savecont,vs_cutoff);
        cd(filtdir) 
            save(['filt_',files(i).name],'filtcont');      %%save the files
        cd ..
    end
    cd(currentdir)
    
    return;