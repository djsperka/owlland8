function open_eq_file
    global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;

    eq_path= strcat(cal.path,'..\computer_specific_calibrations\');
    
    % Create eq_file based on computer name
    [junk_info,current_rig]=dos('hostname');
    load([strcat(cal.path,'Defaults\'),'online']);
    % load 'snd' var so you can get 'snd.rig_room' and 'snd.rigs' arrays
    if isspace(current_rig(end))
        current_rig=current_rig(1:end-1);
    end
    current_rig_p= strmatch(current_rig, snd.rig_room);
    eq_file=['EQ_file_',char(snd.rigs(current_rig_p))];
    
    if exist([eq_path, eq_file, '.mat'])
        fprintf(1,['Loaded equalization file ', eq_file, '\n\n']);
        load([eq_path, eq_file]); % loads variable 'cal' from saved file
    else
        fprintf(1,['ERROR: Cannot find equalization file ', eq_file, '\n\n']);
    end
    return
