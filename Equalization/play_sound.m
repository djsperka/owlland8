function play_sound()
global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus right_fig left_fig menu_fig;



% present the sound
invoke(RP_1,'run');
% invoke(RP_2,'run'); %%changing to run w/ single RP2 DJT 3/13/2012

invoke(zbus,'zBusTrigA',0,0,4);
tic

fprintf(1,'\n%s\n\n',['Sound is playing ...'])

ind=invoke(RP_1,'GetTagVal','index_out'); %%changing to run w/ single RP2 DJT 3/13/2012
% ind=invoke(RP_2,'GetTagVal','index_out');
while ind>0  % while buffer is filling.
    ind=invoke(RP_1,'GetTagVal','index_out'); %%changing to run w/ single RP2 DJT 3/13/2012
%     ind=invoke(RP_1,'GetTagVal','index_out');
end
toc

% stop sound 
invoke(RP_1,'halt');
% invoke(RP_2,'halt'); %%changing to run w/ single RP2 DJT 3/13/2012

% grab sound buffers from RP2s- 
sound_in=invoke(RP_1,'ReadTagV','presented_snd',0,cal.buffer_size);  %%changing to run w/ single RP2 DJT 3/13/2012
% sound_in=invoke(RP_2,'ReadTagV','presented_snd',0,cal.buffer_size); 
sound_out=invoke(RP_1,'ReadTagV','snd_out',0,cal.buffer_size); %%changing to run w/ single RP2 DJT 3/13/2012
% sound_out=invoke(RP_2,'ReadTagV','snd_out',0,cal.buffer_size);

% figure; plot(sound_L(1:1000), 'k')
% figure; plot(sound_R(1:1000), 'r')


% Convert from time-domain to frequency-domain
fprintf(1,'\n%s\n\n',['Calculating Transfer Function ...'])
tic
sound_in_reshape=reshape(sound_in', cal.collect, cal.reps);
sound_out_reshape=reshape(sound_out', cal.collect, cal.reps);
fft_in=fft(sound_in_reshape,cal.collect);
fft_out=fft(sound_out_reshape,cal.collect);
trx_reps= fft_out./fft_in;
trx=mean(trx_reps');
toc

N=cal.collect;

% Take just the first half of points (first and second half are redundant)
if cal.earphone==0  %left earphone
    cal.trx_L= trx(1:N/2+1);
elseif cal.earphone==1 % right earphone
    cal.trx_R= trx(1:N/2+1);
end

cal.freq_scale=(1:N/2)'*cal.fs/N;  %% freq scale
plot_figs=1;
color='b';


if plot_figs  
    fprintf(1,'\n%s\n\n',['Plotting Transfer function ...'])
    tic    

    if cal.earphone==0  %left earphone
        figure('color', cal.c_yellow,'tag','left_earphone');
        subplot(2,1,1);hold on;
        axis([0 12000 -100 -20]);
        ylabel('Abs. Magnitude dB'); grid on;
        title(['TRANSFER FUNCTION - left earphone']);
        subplot(2,1,2); hold on;
        axis([0 12000 -190 190]);
        ylabel('Phase [Degrees]'); grid on;
        xlabel('Frequency [Hertz]');

        y=abs(trx(1:N/2));  
        subplot(2,1,1);hold on;
        plot(cal.freq_scale(1:N/2),20*log10(y),color);
        subplot(2,1,2); hold on;
        plot(cal.freq_scale(1:N/2),angle(trx(1:N/2))*180/pi,color);
        
    elseif cal.earphone==1  %right earphone
        figure('color', cal.c_yellow,'tag','right_earphone');
        subplot(2,1,1);hold on;
        axis([0 12000 -100 -20]);
        ylabel('Abs. Magnitude dB'); grid on;
        title(['TRANSFER FUNCTION - right earphone']);
        subplot(2,1,2); hold on;
        axis([0 12000 -190 190]);
        ylabel('Phase [Degrees]'); grid on;
        xlabel('Frequency [Hertz]');
        
        %figure(findobj(0,'tag','trx_R'));        
        y=abs(trx(1:N/2));
        subplot(2,1,1);hold on;
        plot(cal.freq_scale(1:N/2),20*log10(y),color);
        subplot(2,1,2); hold on;
        plot(cal.freq_scale(1:N/2),angle(trx(1:N/2))*180/pi,color);
    end

    toc


end
