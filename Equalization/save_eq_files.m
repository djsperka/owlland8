function save_eq_files()
    global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;
    
    % 1. CREATE EQ_PATH AND EQ_FILE 
    eq_path= strcat(cal.path,'..\computer_specific_calibrations\');

    % Create eq_file based on computer name
    [junk_info,current_rig]=dos('hostname');
    load([strcat(cal.path,'Defaults\'),'online']);  
            % load 'snd' var so you can get 'snd.rig_room' and 'snd.rigs' arrays    
    current_rig_p= strmatch(current_rig, snd.rig_room);
    eq_file=['EQ_file_',char(snd.rigs(current_rig_p))];
    

    % 2. MAKE BACKUPS OF THE EXISTING FILE (if user has chosen the same
    % filename as an existing file)
    if exist([eq_path, eq_file, '.mat'])
        savecal= cal;
        
        % Create backup filename
        h=findstr(eq_file,'.mat');
        if ~isempty(h)
            backup=[eq_file(1:h-1),'_backup.mat'];
        else
            backup=[eq_file,'_backup.mat'];
        end
        % Save backup
        load([eq_path, eq_file]);  % load the old 'cal' var from file      
        save([eq_path, backup],'cal');  
        
        cal= savecal;  % resest 'cal' var to the one created today
    end

    
     % 3. SAVE NEW EQUALIZATION FILES
     save([eq_path, eq_file],'cal');   
     fprintf(1,'Saved equalization filters to file "%s.mat" in directory:\n%s\n\n', eq_file,eq_path);
     
     
return;
