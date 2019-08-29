function run_tuning_curve_cb()
global snd rec runf stopf RP_1 RP_2;

'running run_tuning_curve_cb'

%After performing either contingency of the if statement on line 40, this
%calls the run_inter_tuning_curve.m script   - DJT 5/14/2013

%%Update all of the important variables
snd.Var1min=str2num(get(findobj(gcf,'tag','Var1min'),'string'));
snd.Var1max=str2num(get(findobj(gcf,'tag','Var1max'),'string'));
snd.Var1step=str2num(get(findobj(gcf,'tag','Var1step'),'string'));
snd.Var2max=str2num(get(findobj(gcf,'tag','Var2max'),'string'));
snd.Var2min=str2num(get(findobj(gcf,'tag','Var2min'),'string'));
snd.Var2step=str2num(get(findobj(gcf,'tag','Var2step'),'string'));
snd.reps=str2num(get(findobj(gcf,'tag','reps'),'string'));
snd.trace=snd.maxtrace+1;

stopf=0;
snd.training=0;

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
        sound_corr1=(yi).*(filtered_lo)';   %% 
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
    
    run_inter_tuning_curve;
    
    
else  %if you are using nbfreq or tone or stim
    if or(snd.Var1==4,snd.Var2==4)   %%tone
        if snd.Var1 ==4  %%make freq noisebands using the snd.Var1 conditions
            N_conditions =  length(snd.Var1array);
            t=[0:(1/snd.fs):2-(1/snd.fs)];  % # points to use
            for i=1:N_conditions
                curr_tone=sin(2*pi*snd.Var1array(i)*t);  % sin wave at current freq
                
                % the number of data points we want is snd.fs/1000 (sampling freq converted from seconds to ms).
                % snd.fs=50 kHz, so we want 50 data points. Use 60 data points to give 
                % some extra space in buffer to avoid edge effects.
                
                sound((i-1)*60*snd.duration+1:i*60*snd.duration)=curr_tone(1:60*snd.duration);                
           end
            
            if invoke(RP_1,'WriteTagV','sound_corr',0, sound)
                'NB Sound loaded on rp1'
            else
                e='NB sound incorrectly loaded on rp1' 
            end
            
            snd.sound_nb=sound;
            
            %%%%%%%%%%clear the snd vectors
            snd.snd_corr1=[];
            snd.snd_corr2=[];
            snd.snd_uncorr1=[];
            snd.snd_uncorr2=[];
            
            %% also clear the AM alone arrays
            snd.AMsnd_corr=[];
            snd.AMsnd_uncorr1=[];
            snd.AMsnd_uncorr2=[];    
            
        else %%make freq noisebands using the snd.Var2 conditions
            '**** ERROR **** When presenting tone stimuli you need to use variable 1.  Tone does not work for variable 2.' 
        end
    end
        if or(snd.Var1==5,snd.Var2==5)   %%nbfreq
            
            if snd.Var1 ==5  %%make freq noisebands using the snd.Var1 conditions
                
                N_conditions =  length(snd.Var1array);
                
                t=[0:(1/snd.fs):2-(1/snd.fs)+10000*(1/snd.fs)];  % time points
                y=randn(length(t),1);   %unfiltered noise
                for i=1:N_conditions
                    % ellip creates a filter. subtract/add 500 Hz on either side of stimulus to make narrow band
                    [b,a] = ellip(7,5,35,[(snd.Var1array(i)-500)/(snd.fs/2) (snd.Var1array(i)+500)/(snd.fs/2)]);
                    %%%%%% KM: this is the only line you need to change if you want to change how the sound is filtered.
                    
                    filtered_uncut=filter(b,a,y);  % filter the noise with nbfreq filter
                    N=length(filtered_uncut);
                    filtered=filtered_uncut(5000:N-5000);
                    
                    % the number of data points we want is snd.fs/1000 (sampling freq converted from seconds to ms).
                    % snd.fs=50kHz, so we want 50 data points. Use 60 data points to give 
                    % some extra space in buffer to avoid edge effects.                    
                    sound((i-1)*60*snd.duration+1:i*60*snd.duration)=filtered(1:60*snd.duration);
                end
                
                if invoke(RP_1,'WriteTagV','sound_corr',0, sound)
                    'NB Sound loaded on rp1'
                else
                    e='NB sound incorrectly loaded on rp1' 
                end
                
                snd.sound_nb=sound;
                
                %%%%%%%%%%clear the snd vectors
                snd.snd_corr1=[];
                snd.snd_corr2=[];
                snd.snd_uncorr1=[];
                snd.snd_uncorr2=[];
                
                %% also clear the AM alone arrays
                snd.AMsnd_corr=[];
                snd.AMsnd_uncorr1=[];
                snd.AMsnd_uncorr2=[];    
                
            else%%make freq noisebands using the snd.Var2 conditions
                '**** ERROR **** When presenting nbfreq stimuli you need to use variable 1.  Nbfreq does not work for variable 2.' 
            end          
        end   
        
        run_inter_tuning_curve;
    end;         
    
return;
