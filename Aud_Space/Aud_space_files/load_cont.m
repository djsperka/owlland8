function load_cont(i)
    global savecont saverec cont rec;
        
    [filename path]=uiputfile('*.*');
    set(findobj(get(gco,'parent'),'tag','path'),'string',path);
    set(findobj(get(gco,'parent'),'tag','file'),'string',filename);
    
    
    clear savecont saverec filtcont
    global savecont saverec cont;
     
    load([path,filename])
    
    if exist('filtcont')
        savecont=filtcont;
    end
    if or(~strcmp(savecont{1}.path,path),~strcmp(savecont{1}.filename,filename))
        for i=1:length(savecont)    
            savecont{i}.path=path;    
            savecont{i}.filename=filename;   
        end
            currentdir=pwd;

    cd (path);
    save(filename,'savecont','saverec');      %%save the files
    cd(currentdir); 

    end
    
    %%update file

    cont=savecont{i};
    rec=saverec{i};

return;