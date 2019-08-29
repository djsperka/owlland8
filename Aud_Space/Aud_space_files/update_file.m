function update_file()
    global snd rec savesnd saverec;
    currentdir=pwd;
    savesnd{snd.trace}=snd;
    saverec{snd.trace}=rec;
     
    cd (snd.path);
        save(snd.filename,'savesnd','saverec');      %%save the files
    cd(currentdir);
return