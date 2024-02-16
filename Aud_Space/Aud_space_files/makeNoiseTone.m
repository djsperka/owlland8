function [nSampleNoise, nSampleTone, sound] = makeNoiseTone(fs, amplitude, dur1, freqlo1, freqhi1, dur2, freq2)
%makeNoiseTone Creates a single buffer containing two sound stimuli - noise
%and a tone. Returns a single row vector.
%   The first stim is band filtered noise, the second is a pure tone. There
%   is no separation between the stimuli in the returned buffer. The first
%   two return values are the number of samples of each stim in the buffer.
    

    % Compute number of samples for each stim. 
    % I put an extra 100ms samples in each in case of edge effects in the TDT
    % hardware. I have no idea if that's for real, but there are comments
    % in code that refer to "edge effects".
    dur1Seconds = 0.001 * (dur1 + 100);
    nSampleNoise = dur1Seconds * fs;
    dur2Seconds = 0.001 * (dur2 + 100);
    t=[0:(1/fs):dur2Seconds-(1/fs)];  % # points to use
    nSampleTone = length(t);
    sound = zeros(1, nSampleNoise + nSampleTone);
 
    %% Noise
    y=amplitude*randn(nSampleNoise + 10000, 1);
    [b,a] = ellip(7,5,35,[freqlo1/(fs/2) freqhi1/(fs/2)]);
    filtered=filter(b,a,y);
    N=length(filtered);
    filtered_lo=filtered(5001:N-5000);
    sound(1:nSampleNoise) = filtered_lo;   %% 

    %% Tone
    sound(nSampleNoise+1 : nSampleNoise+nSampleTone) = sin(2 * pi * freq2 * t);

end

