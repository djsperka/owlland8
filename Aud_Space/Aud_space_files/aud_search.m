global snd RP_1

%for dialog box

% prompt = {'Azimuth','Elevation'};
% title = 'Spatial location (in degrees)';
% num_lines = 1;
% default = {'',''};
% answer = inputdlg(prompt,title,num_lines, default);

% az = str2num(answer{1})
% itd = az*2.5 %seconds
% el = str2num(answer{2})
% ild = el*1 %dB


fprintf ('az, el, itd, ild\n\n')
%keyboard

fprintf ('loading aud parameters\n\n')
%keyboard

%DR 2-26-13 %% copied code from run_tuning_curve_cb

global snd rec runf stopf RP_1 RP_2;

%%Update all of the important variables
snd.Var1min= itd;
snd.Var1max= itd;
snd.Var1step= 1000;
snd.Var2max= ild;
snd.Var2min= ild;
snd.Var2step= 1000;
snd.reps = 1;
snd.trace=snd.maxtrace+1;
snd.isi=isi;

stopf=0;
snd.training=0;

% %%%Present AM
% Wave_pointer = 1;
% aud_search_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre+snd.aud_offset,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, snd.play_sound1, snd.play_sound2];      %%default sound array
% aud_search_array(1) = itd;
% aud_search_array(2) = ild;
% aud_search_array(9) = itd;
% aud_search_array(10) = ild;
% 
% PresentAM_aud_search(aud_search_array,Wave_pointer);
% %%%

set(findobj(gcf,'tag','Print_trace'),'string',['Trace ' num2str(snd.trace)]);

%%  clear the plots
figure(findobj(0,'tag','disp_win_1'));
clf  
figure(findobj(0,'tag','disp_win_2'));
clf
figure(findobj(0,'tag','disp_win_3'));
set(findobj(gcf,'tag','var1_ba'),'string','');
set(findobj(gcf,'tag','var2_ba'),'string','');
set(findobj(gcf,'tag','var1_alone_ba'),'string','');
set(findobj(gcf,'tag','var2_alone_ba'),'string','');
snd.ba_handle=[];

%%%%%%%%%%%%%%%%%%%%

snd.Var1array=[snd.Var1min:snd.Var1step:snd.Var1max];
if snd.Var2~=7  %%if there is a second variable
    snd.Var2array=[snd.Var2min:snd.Var2step:snd.Var2max];
else
    snd.Var2array=[0];
end

if (snd.Var1 ~= 4) && (snd.Var1 ~= 5)  && (snd.Var2 ~= 4) && (snd.Var2 ~= 5)  
    %%%% Make and Load the sounds
    
    %%%% This part creates the sounds and loads them onto RP_1 and RP_2
    %%%% snd.M is the dynamic range of the envelope in dB 
    
    sound_length=2;    %%%% There will be 2 seconds of sound in each buffer 
    %%%% (right now, this is hardwired)
    %%Look here for frozen sound!!! #frozen #fresh DJT 2/10/2013
    
    switch snd.AMtype  %% make the appropriate type of AM
        
        case 1 %% no AM
            yi=ones(1,sound_length*snd.fs);
            yi2=yi;
            yi3=yi;
            
        case 2 %% sinusoidal AM
            ti=[0:(1/snd.fs):sound_length-(1/snd.fs)];
            yi=sin(2*pi*snd.Freq_mod*ti);
            yi=yi*.5+.5; %% offset sine wave so y values range from 0 to 1
            yi=yi*snd.mod_depth + (1-snd.mod_depth); %% correct for modulation depth
            yi2=yi;
            yi3=yi;
            
        case 3 %% rand AM  (logarithmically distributed modulation)
            t=[0:1/(2*snd.Freq_mod):sound_length-(1/(2*snd.Freq_mod))];  %%TIME VECTOR FOR AM NOISE
            y=rand(length(t),1);
            y=y*snd.mod_depth + (1-snd.mod_depth); %% correct for modulation depth
            ti=[0:(1/snd.fs):sound_length-(1/snd.fs)];
            yi=interp1(t,y,ti,'linear');
            N=length(yi);
            yi=10.^((snd.M*yi-snd.M)/20);
            
            y=rand(length(t),1);
            y=y*snd.mod_depth + (1-snd.mod_depth); %% correct for modulation depth
            ti=[0:(1/snd.fs):sound_length-(1/snd.fs)];
            yi2=interp1(t,y,ti,'linear');
            N=length(yi2);
            yi2=10.^((snd.M*yi2-snd.M)/20);
            
            y=rand(length(t),1);
            y=y*snd.mod_depth + (1-snd.mod_depth); %% correct for modulation depth
            ti=[0:(1/snd.fs):sound_length-(1/snd.fs)];
            yi3=interp1(t,y,ti,'linear');
            N=length(yi3);
            yi3=10.^((snd.M*yi3-snd.M)/20);
            
        case 4 %% aud loom
            y=10.^(2*[0:1/snd.fs:snd.duration/1000]);
            y_up=10*y/max(y);
            y=10.^(-2*[0:1/snd.fs:snd.duration/1000]);
            y_down=10*y/max(y);

    end
    
     if snd.AMtype < 4  %%if you are not looming
        %%make Freq noiseband for snd1
        t=[0:(1/snd.fs):sound_length-(1/snd.fs)+10000*(1/snd.fs)];
        y=snd.amplitude*randn(length(t),1);
        [b,a] = ellip(7,5,35,[snd.freqlo1/(snd.fs/2) snd.freqhi1/(snd.fs/2)]);
        filtered=filter(b,a,y);
        N=length(filtered);
        filtered_lo=filtered(5001:N-5000);
        
        %%make freq noiseband for snd2
        t=[0:(1/snd.fs):sound_length-(1/snd.fs)+10000*(1/snd.fs)];
        y=snd.amplitude*randn(length(t),1);
        [b,a] = ellip(7,5, 35,[snd.freqlo2/(snd.fs/2) snd.freqhi2/(snd.fs/2)]);
        filtered=filter(b,a,y);
        N=length(filtered);
        filtered_high=filtered(5001:N-5000);
        
        %%% multiply the noisebands by the proper AM
        sound_corr1=(yi).*(filtered_lo)';
        %%THIS IS WHAT WE WANT FOR OUR SEARCH STIM DJT 2/10/13
        %% For non-amp modulated sounds, yi=ones(1,sound_length*snd.fs)
        
        sound_uncorr1=(yi2).*(filtered_lo)';
        sound_corr2=(yi).*(filtered_high)';
        sound_uncorr2=(yi3).*(filtered_high)';
    else
        %%% triangular wave for the looming condition
        freq=500;  %%in hertz
        n=snd.duration/1000*freq*4;  %% number of init samples in T
        
		tri_samplo=zeros(1,n);
		tri_samplo(3:4:n)=-1;
		tri_samplo(1:4:n)=1;

		tri = interp1([0:snd.duration/(1000*n):snd.duration/1000-snd.duration/(1000*n)],tri_samplo, [0:1/snd.fs:snd.duration/1000],'linear');
        
        %%% multiply the sound by the proper AM
        sound_corr1=(y_up).*(tri);   %% 
        sound_uncorr1=(y_down).*(tri);
        sound_corr2=(y_up).*(tri);
        sound_uncorr2=(y_down).*(tri);
    end
    
    %% halt the hardware
    invoke(RP_1,'halt');   
%     invoke(RP_2,'halt'); 
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    if snd.play_sound1 == 1
        if invoke(RP_1,'WriteTagV','sound_corr',0, sound_corr1)
            'Sound loaded on rp1'
        else
            e='sound incorrectly loaded on rp1' 
        end
        if invoke(RP_1,'WriteTagV','sound_uncorr',0, sound_uncorr1)
            'Sound loaded on rp1'
        else
            e='sound incorrectly loaded on rp1' 
        end
    end
    
    if snd.play_sound2 == 1
        
%         if invoke(RP_2,'WriteTagV','sound_corr',0, sound_corr2)
%             'Sound loaded on rp2'
%         else
%             e='sound incorrectly loaded on rp2' 
%         end
%         
%         if invoke(RP_2,'WriteTagV','sound_uncorr',0, sound_uncorr2)
%             'Sound loaded on rp2'
%         else
%             e='sound incorrectly loaded on rp2' 
%         end    
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried loading sounds onto RP_2 in run_tuning_curve_cb.m'
    end
    
    %% activate the hardware
    invoke(RP_1,'run');   
%     invoke(RP_2,'run'); 
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% save the sound waveform itself
	if snd.save_sound
		snd.snd_corr1=sound_corr1;
		snd.snd_corr2=sound_corr2;
		
		if snd.corr==1
		snd.snd_uncorr1=sound_uncorr1;
		snd.snd_uncorr2=sound_uncorr2;
		else
		snd.snd_uncorr1=[];
		snd.snd_uncorr2=[];
		end
		
		%% also save the AM alone
		snd.AMsnd_corr=yi;
		snd.AMsnd_uncorr1=yi2;
		snd.AMsnd_uncorr2=yi3;
	end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    global snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus;
    tic
    rawwave_start=cputime;  
    snd.starttime=clock;    %%  time stamp
    rec.collecttime=(snd.pre+snd.post);
    if snd.collect_rawwave
        set_RA16_rawwave
    else
        set_RA16        %%  set values on the RA16
    end
    runf=1;
    
    snd.check=1;
    
    if snd.play_vis1==1 || snd.play_vis2==1 || snd.screenblank==1    %%%if there is a visual stimulus or the screen was blanked
        %snd.window=SCREEN(0,'OpenWindow',0);
        hidecursor;                         %%  Hide the cursor
        screen(snd.window,'fillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color
        screen(snd.window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc); %% black out the box for the trigger
    end

%%%%%make all of the data arrays 
    snd.datachan=zeros(1,50000);        %%for both variables
    snd.datatime=zeros(1,50000);
    snd.datarep=zeros(1,50000);
    snd.dataVar1=zeros(1,50000);
    snd.dataVar2=zeros(1,50000);
    snd.spikeplace=0;
    if snd.save_spikes
        snd.dataWave=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave=[];
    end
    
    snd.datachan_arr1=zeros(1,50000);   %%for variable 1
    snd.datatime_arr1=zeros(1,50000);
    snd.datarep_arr1=zeros(1,50000);
    snd.dataVar1_arr1=zeros(1,50000);
    snd.spikeplace_arr1=0;
    if snd.save_spikes
        snd.dataWave_arr1=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave_arr1=[];
    end
    
    snd.datachan_arr2=zeros(1,50000);   %%for variable 2
    snd.datatime_arr2=zeros(1,50000);
    snd.datarep_arr2=zeros(1,50000);
    snd.dataVar2_arr2=zeros(1,50000);
    snd.spikeplace_arr2=0;
    if snd.save_spikes
        snd.dataWave_arr2=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave_arr2=[];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%make all of the summary data arrays 
    snd.datamat_pre = zeros(length(snd.Var2array),length(snd.Var1array),rec.numch);
    snd.datamat_post = snd.datamat_pre;

    snd.data_arr1_pre = zeros(2,length(snd.Var1array),rec.numch);
    snd.data_arr1_post = snd.data_arr1_pre;

    snd.data_arr2_pre = zeros(length(snd.Var2array),2,rec.numch);
    snd.data_arr2_post = snd.data_arr2_pre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	matsize=length(snd.Var1array)*length(snd.Var2array);
	arr1size=length(snd.Var1array);
	arr2size=length(snd.Var2array);


    if snd.interleave_alone==0
        stimnum=matsize;      %%total number of stimuli when no interleaving
    else
        stimnum=matsize+arr1size+arr2size;      %%total number of stimuli
    end



	while toc<snd.startpause        %%  pause at the start of the trial
        drawnow;
	end
    h=findobj(gcf,'tag','Print_trace');
            set(h,'string',['Trace ' num2str(snd.trace)]);

    tic
  
    %%%   ------------------START CYCLING REPS  ---------------- %%%
while 1
    tic
    
        randorder=randperm(stimnum);            %%randomization of the overall stimtype
        
        %%pointers for the individual tuning curves
        mat_place=1;        
        array1_place=1;
        array2_place=1;
        
        %%order for the individual tuning curves
        mat_order=randperm(matsize);
        array1_order=randperm(arr1size);
        array2_order=randperm(arr2size);
         
        
        for i=[1:stimnum]
%             %%  print the rep info to the screen
%             figure(findobj(0,'tag','Aud_Space_win'));     %% set the countour window as active
%             h=findobj(gcf,'tag','Print_rep');
%             set(h,'string',['rep ' num2str(rep) ' of ' num2str(snd.reps) ' : ' 'stim ' num2str(i) ' of ' num2str(stimnum)]);
%  
%            if snd.check==1   %%% refers to previous stimulus 
%                 while toc<(snd.isi/1000)
%                     drawnow;
%                 end
%             end
%             tic
                   
            if randorder(i)<=matsize
               %run_mat_curve_aud(rep,mat_order,mat_place);
               
               %%%%% copied from run_mat_curve DR 3-6-13
               
              stimulus_order = mat_order;
              stimulus_place = mat_place;
               
               global snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus;

[Var2_place,Var1_place]=ind2sub(size(snd.datamat_pre(:,:,1)),stimulus_order(stimulus_place));

present_sound_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre+snd.aud_offset,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, snd.play_sound1, snd.play_sound2];      %%default sound array

angle=snd.angle;                    %% set the angle of motion
dotcenter=[snd.az,snd.el];          %%  set the visual location
dotcenter2=[snd.az2,snd.el2];          %%  set the visual location for vis2   
fore_lum=snd.foreground;            %%  set the visual luminance
fore_lum2=snd.foreground2;            %%  set the visual luminance for vis2


%%%%  PRESENT THE STIMULI     
% %%%Present AM     %% added for aud search stim- DR
%present_sound_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre+snd.aud_offset,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, snd.play_sound1, snd.play_sound2];      %%default sound array
present_sound_array(1) = itd;
present_sound_array(2) = ild;
present_sound_array(9) = itd;
present_sound_array(10) = ild;


Wave_pointer=1;
snd.check=1;

stim_curve=0;   %this means not a electrical stim curve


switch snd.Var1         %%% update the stimuli based on the current values FOR VAR1
    case 1  %%ITD1
        present_sound_array(1)=snd.Var1array(Var1_place);     
    case 2  %%ILD1
        present_sound_array(2)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 3  %%ABI1
        present_sound_array(3)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 4  %%tone           
        Wave_pointer=((Var1_place-1)*snd.duration*60)+1;             %%set the wave_pointer to the proper wave section
    case 5   %%nbfreq
        Wave_pointer=((Var1_place-1)*snd.duration*60)+1;         %%set the wave_pointer to the proper wave section
    case 6      %%stim
        snd.trgdelay=snd.Var1array(Var1_place);
        if invoke(RP_2,'SetTagVal','trgdelay',(snd.pre+snd.trgdelay));  %%delay relative to zero for trigger in ms
        else
            'unable to set trigger delay'
        end
        stim_curve=1;
    case 7      %%old av test now place holder 
    case 8  %%vis az
        dotcenter(1)=snd.Var1array(Var1_place);
    case 9  %%vis el
        dotcenter(2)=snd.Var1array(Var1_place);
    case 10 %%vis lum
        fore_lum=snd.Var1array(Var1_place);
    case 11  %% vis angle
        angle=snd.Var1array(Var1_place);
    case 12  %% AVflank
        present_sound_array(1)=snd.Var1array(Var1_place)-snd.ITDflank;
        dotcenter(1)= (snd.Var1array(Var1_place)+snd.ITDflank)/2.5;
    case 13  %%Az2
        dotcenter2(1)=snd.Var1array(Var1_place);
    case 14  %%El2
        dotcenter2(2)=snd.Var1array(Var1_place);
    case 15  %%VVflank
        dotcenter2(1)= snd.Var1array(Var1_place)-snd.ITDflank/2.5;
        dotcenter(1)= snd.Var1array(Var1_place)+snd.ITDflank/2.5;
    case 16    %% ITD2
        present_sound_array(9)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 17  %% ILD2
        present_sound_array(10)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 18  %% ABI2
        present_sound_array(11)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 19  %%ITDFlank
        present_sound_array(1)=snd.Var1array(Var1_place)-snd.ITDflank;
        present_sound_array(9)=snd.Var1array(Var1_place)+snd.ITDflank;
end

% switch snd.Var2         %%% update the stimuli based on the current values FOR VAR2
%     case 1  %%ITD
%         present_sound_array(1)=snd.Var2array(Var2_place);
%     case 2  %%ILD
%         present_sound_array(2)=snd.Var2array(Var2_place);              %%update this Var2 position
%     case 3  %%ABI
%         present_sound_array(3)=snd.Var2array(Var2_place);              %%update this Var2 position
%     case 4     
%     case 5     
%     case 6      %%stim
%         snd.trgdelay=snd.Var2array(Var2_place);
%         if invoke(RP_2,'SetTagVal','trgdelay',(snd.pre+snd.trgdelay));  %%delay relative to zero for trigger in ms
%         else
%             'unable to set trigger delay'
%         end
%         stim_curve=1;
%     case 7      %%none
%     case 8  %%vis az
%         dotcenter(1)=snd.Var2array(Var2_place);
%     case 9  %%vis el
%         dotcenter(2)=snd.Var2array(Var2_place);
%     case 10 %%vis lum
%         fore_lum=snd.Var2array(Var2_place);
%     case 11  %% vis angle
%         angle=snd.Var2array(Var2_place);
%     case 12  %%for now, these are nothings.
%     case 13  %%Az2
%         dotcenter2(1)=snd.Var2array(Var2_place);
%     case 14  %%El2
%         dotcenter2(2)=snd.Var2array(Var2_place);
%     case 15  
%         
%     case 16    %% ITD2
%         present_sound_array(9)=snd.Var2array(Var2_place);              %%update this Var1 position
%     case 17  %% ILD2
%         present_sound_array(10)=snd.Var2array(Var2_place);              %%update this Var1 position
%     case 18  %% ABI2
%         present_sound_array(11)=snd.Var2array(Var2_place);              %%update this Var1 position
%         
% end

PresentAM_aud_search(present_sound_array,Wave_pointer);
%PresentAM(present_sound_array,Wave_pointer);  %%  set the sound
movedot(snd.window,dotcenter,dotcenter2,fore_lum,fore_lum2,snd.background,angle,snd.angle2,snd.dotsize,snd.dotsize2,snd.pre,snd.amp_mod_vis,snd.Freq_mod,snd.duration,snd.vis_offset,stim_curve, snd.distance, snd.distance2,[snd.play_vis1,snd.play_vis2],snd.size_change);      %%set vis and trigger sound

% if CharAvail 
%         return
% end

while toc<(snd.isi/1000)
    if CharAvail 
        return
end
end

end %%end repeater WHILE loop
        
end;     
end;
    
end;    
    
