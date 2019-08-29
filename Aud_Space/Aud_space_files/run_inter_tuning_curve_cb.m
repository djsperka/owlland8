function run_inter_tuning_curve_cb()
    global multsnd snd rec runf stopf RP_1 RP_2;
    
    Ntraces=length(multsnd)
    multsnd{Ntraces}.trace=snd.maxtrace+1;
    snd.trace= snd.maxtrace+1;
    
    
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
    
    for i=1:Ntraces
        multsnd{i}.Var1array=[multsnd{i}.Var1min:multsnd{i}.Var1step:multsnd{i}.Var1max];
        if multsnd{i}.Var2~=7  %%if there is a second variable
            multsnd{i}.Var2array=[multsnd{i}.Var2min:multsnd{i}.Var2step:multsnd{i}.Var2max];
        else
            multsnd{i}.Var2array=[0];
        end
    end
    %%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%% THIS PROGRAM CAN'T INTERLEAVE NBFREQ OR TONE. 
%%%%%%%%%%%%%% IT ALSO CAN'T INTERLEAVE NO AM WITH AM.
    
    snd=multsnd{Ntraces};  %%snd.AM and snd.fs and snd.noAM will come from the Nth trace's values

    %%%% Make and Load the sounds
            %%%% There will be 2 seconds of sound in each buffer
            
            %%% This part creates the sounds and loads them onto RP_1 and
            %%% RP_2
            
            %%%% snd.M is the dynamic range of the envelope in dB
            sound_length=2;    %%%% There will be 2 seconds of sound in each buffer (right
                               %%%% now, this is hardwired)
            
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

            % We don't have a second RP2 (aka RP_2) so got rid of this DJT
            % 3/10/2014
%             if invoke(RP_2,'WriteTagV','sound_corr',0, sound_corr2)
%                 'Sound loaded on rp2'
%             else
%           	        e='sound incorrectly loaded on rp2' 
%             end
%             
%             if invoke(RP_2,'WriteTagV','sound_uncorr',0, sound_uncorr2)
%                 'Sound loaded on rp2'
%             else
%           	        e='sound incorrectly loaded on rp2' 
%             end    
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% save the sound waveform itself
            if snd.save_sound==1
                for i=1:Ntraces
                    multsnd{i}.snd_corr1=sound_corr1;
                    multsnd{i}.snd_corr2=sound_corr2;
                    
                    if multsnd{i}.corr==1
                        multsnd{i}.snd_uncorr1=sound_uncorr1;
                        multsnd{i}.snd_uncorr2=sound_uncorr2;
                    else
                        multsnd{i}.snd_uncorr1=[];
                        multsnd{i}.snd_uncorr2=[];
                    end
                    
                    %% also save the AM alone
%                     multsnd{i}.AMsnd_corr=yi;
%                     multsnd{i}.AMsnd_uncorr1=yi2;
%                     multsnd{i}.AMsnd_uncorr2=yi3;
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

 

    
    
    run_mult_inter_tuning_curve;
    
return;
