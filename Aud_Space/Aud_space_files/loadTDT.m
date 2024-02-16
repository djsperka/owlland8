function loadTDT(RPVDS_path,RP1name,RP2name,RA16name,atten_num, samp_freq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%     Function loads TDT hardware with the chosen RPVDS files.  
%     The function then sets the equalization parameters for the two speakers.
%     if a string is empty ('') the program will skip that instrument.
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global RP_1 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;

%set activeX objects and connect
zbus=actxcontrol('ZBUS.x',[1    1   1   1],figure('visible','off'));
RP_1=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));
RA_16=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));

if atten_num>0  %%allows up to four attenuators to be added
    pa5_1 = actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
    if ~pa5_1.ConnectPA5('GB', 1) || ~pa5_1.SetAtten(99)
        error('Cannot connect to pa5 #1');
    else
        fprintf('PA5 #1 connected\n');
    end
end

if atten_num>1  %%allows up to four attenuators to be added
    pa5_2 = actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
    if ~pa5_2.ConnectPA5('GB', 2) || ~pa5_2.SetAtten(99)
        error('Cannot connect to pa5 #2');
    else
        fprintf('PA5 #2 connected\n');
    end
end

if atten_num>2  %%allows up to four attenuators to be added
    pa5_3 = actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
    if ~pa5_3.ConnectPA5('GB', 3) || ~pa5_3.SetAtten(99)
        error('Cannot connect to pa5 #3');
    else
        fprintf('PA5 #3 connected\n');
    end
end

if atten_num>3  %%allows up to four attenuators to be added
    pa5_4 = actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
    if ~pa5_4.ConnectPA5('GB', 4) || ~pa5_4.SetAtten(99)
        error('Cannot connect to pa5 #4');
    else
        fprintf('PA5 #4 connected\n');
    end
end

        
    
if ~zbus.ConnectZBUS('GB')
    error('Cannot connect to zbus');
else
    zbus.HardwareReset(1);
    zbus.FlushIO(1);
end

if ~RP_1.ConnectRP2('GB', 1) || ~RP_1.ClearCOF()
    error('Cannot connect to rp2 processor');
end

if ~RA_16.ConnectRA16('GB', 1)
    error('Cannot connect to ra16');
end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if samp_freq==25000
    cof_num=2;
    fprintf('Sampling frquency is 25000 Hz\n');
elseif samp_freq==50000
    cof_num=3;
    fprintf('Sampling frquency is 50000 Hz\n');
else
    error('Sampling frequency must be either 25K or 50K');
end

%%  Load the necessary files to the selected hardware devices
if ~RP_1.LoadCOFsf(strcat(RPVDS_path,'\',RP1name), cof_num)
    error('Cannot load DSP obj %s to rp2\n', strcat(RPVDS_path,'\',RP1name));
else
    fprintf('DSP obj %s loaded on rp2\n', RP1name);
end
    
    
    
cycleUsage = RP_1.GetCycUse;
fprintf('Cycle usage %f\n', cycleUsage);
nParTags = RP_1.GetNumOf('ParTag');
fprintf('There are %d par tags\n', nParTags);
for z=1:nParTags
    pname = RP_1.GetNameOf('ParTag', z);
    ptype = char(RP_1.GetTagType(pname));
    psize = RP_1.GetTagSize(pname);
    disp(['   ' pname ' type ' ptype '  size ' num2str(psize)]);
end

if ~RA_16.LoadCOFsf(strcat(RPVDS_path,'\',RA16name), 2)
    error('Cannot load DSP obj %s to rp2\n', strcat(RPVDS_path,'\',RA16name));
else
    fprintf('DSP obj %s loaded on ra16\n', RA16name);
end

return;