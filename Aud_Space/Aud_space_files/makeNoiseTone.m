function [nSampleNoise, nSampleTone, sound] = makeNoiseTone(fs, amplitude, dur1, freqlo1, freqhi1, dur2, freq2)

    % Compute number of samples for each stim. 
    % I put an extra 100ms samples in each in case of edge effects in the TDT
    % hardware. I have no idea if that's for real, but there are comments
    % in code that refer to "edge effects".
    dur1Seconds = 0.001 * (dur1 + 100);
    nSampleNoise = dur1Seconds * fs;  
    dur2Seconds = 0.001 * (dur2 + 100);
    t=[0:(1/fs):dur2Seconds-(1/snd.fs)];  % # points to use
    nSampleTone = length(t);
    sound = zeros(nSampleNoise + nSampleTone)
 
    %% Noise
    y=amplitude*randn(nSampleNoise + 10000, 1);
    [b,a] = ellip(7,5,35,[freqlo1/(fs/2) freqhi1/(fs/2)]);
    filtered=filter(b,a,y);
    N=length(filtered);
    filtered_lo=filtered(5001:N-5000);
    sound(1:nSampleNoise) = filtered_lo;   %% 

    %% Tone
    sound(nSampleNoise+1 : nSampleNoise+NSampleTone) = sin(2 * pi * freq2 * t);

end

