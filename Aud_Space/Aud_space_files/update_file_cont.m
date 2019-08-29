function update_file_cont()
    global cont rec savecont saverec;
    currentdir=pwd;
    savecont{cont.trace}=cont;
    saverec{cont.trace}=rec;
     
    cd (cont.path);
    save(cont.filename,'savecont','saverec');      %%save the files
    cd(currentdir);
    
return