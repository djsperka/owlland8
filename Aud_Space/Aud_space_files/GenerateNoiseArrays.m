function [sound_corr, sound_uncorr] = GenerateNoiseArrays(sound_length, AMtype, fs, Freq_mod, mod_depth, M, duration, amplitude, freqlo1, freqhi1)
%GenerateNoiseArrays Generate arrays to be loaded to the RP2. Algorithm
%copied from run_tuning_curve_cb, 
%   Detailed explanation goes here

            
    switch AMtype  %% make the appropriate type of AM

        case 1 %% no AM
            yi=ones(1,sound_length * fs);
            yi2=yi;
            yi3=yi;

        case 2 %% sinusoidal AM
            ti=[0:(1/fs):sound_length-(1/fs)];
            yi=sin(2*pi*Freq_mod*ti);
            yi=yi*.5+.5; %% offset sine wave so y values range from 0 to 1
            yi=yi*mod_depth + (1-mod_depth); %% correct for modulation depth
            yi2=yi;
            yi3=yi;

        case 3 %% rand AM  (logarithmically distributed modulation)
            t=[0:1/(2*Freq_mod):sound_length-(1/(2*Freq_mod))];  %%TIME VECTOR FOR AM NOISE
            y=rand(length(t),1);
            y=y*mod_depth + (1-mod_depth); %% correct for modulation depth
            ti=[0:(1/fs):sound_length-(1/fs)];
            yi=interp1(t,y,ti,'linear');
            N=length(yi);
            yi=10.^((M*yi-M)/20);

            y=rand(length(t),1);
            y=y*mod_depth + (1-mod_depth); %% correct for modulation depth
            ti=[0:(1/fs):sound_length-(1/fs)];
            yi2=interp1(t,y,ti,'linear');
            N=length(yi2);
            yi2=10.^((M*yi2-M)/20);

            y=rand(length(t),1);
            y=y*mod_depth + (1-mod_depth); %% correct for modulation depth
            ti=[0:(1/fs):sound_length-(1/fs)];
            yi3=interp1(t,y,ti,'linear');
            N=length(yi3);
            yi3=10.^((M*yi3-M)/20);
        case 4 %% aud loom
            y=10.^(2*[0:1/fs:duration/1000]);
            y_up=10*y/max(y);
            y=10.^(-2*[0:1/fs:duration/1000]);
            y_down=10*y/max(y);   
    end

    if AMtype < 4  %%if you are not looming
        %%make Freq noiseband for snd1
        t=[0:(1/fs):sound_length-(1/fs)+10000*(1/fs)];
        y=snd.amplitude*randn(length(t),1);
        [b,a] = ellip(7,5,35,[freqlo1/(fs/2) freqhi1/(fs/2)]);
        filtered=filter(b,a,y);
        N=length(filtered);
        filtered_lo=filtered(5001:N-5000);

        %%% multiply the noisebands by the proper AM
        sound_corr=(yi).*(filtered_lo)';   %% 
        sound_uncorr=(yi2).*(filtered_lo)';
    else
        %%% triangular wave for the looming condition
        freq=500;  %%in hertz
        n=duration/1000*freq*4;  %% number of init samples in T

        tri_samplo=zeros(1,n);
        tri_samplo(3:4:n)=-1;
        tri_samplo(1:4:n)=1;

        tri = interp1([0:duration/(1000*n):duration/1000-duration/(1000*n)],tri_samplo, [0:1/fs:duration/1000],'linear');

        %%% multiply the sound by the proper AM
        sound_corr = (y_up).*(tri);   %% 
        sound_uncorr = (y_down).*(tri);
    end    

end

