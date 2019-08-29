function design_filter

global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus ;

fprintf(1,'\n%s\n\n',['Creating filters ...'])

% first=120;
% last=300;
% N_pos=length(bird.pos_double_pole);
[m,i]=min(abs(cal.freq_scale-800));
fade_zone=i;
N_pnts=cal.collect;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CREATE INVERSE IRS FOR THE EARPHONES %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

smooth_buffer=0;

% first create regular IRs
%%Fade out unwanted frequencies w/ a cos^2
trx_R=cal.trx_R;
N=length(trx_R);
trx_R(1:fade_zone)=10^-7;
trx_R(fade_zone+1:fade_zone*2)=10^-7;
%(mean(cal.trx_R(2*fade_zone+1-smooth_buffer:2*fade_zone+1+smooth_buffer)))*cos((pi/2)*[fade_zone-1:-1:0]/(fade_zone-1)).^2+0.0001;
trx_R(N-fade_zone*2+1:N-fade_zone)=10^-7;%(mean(cal.trx_R(N-2*fade_zone-smooth_buffer:N-2*fade_zone+smooth_buffer)))*cos((pi/2)*[0:1:fade_zone-1]/(fade_zone-1)).^2+0.0001;
trx_R(N-fade_zone+1:N)=10^-7;
% figure;plot(cal.freq_scale,(abs(trx_R(1:end-1))));
% hold on; plot(cal.freq_scale,(abs(cal.trx_R(1:end-1))), 'r');


trx_L=cal.trx_L;
trx_L(1:fade_zone)=10^-7;
trx_L(fade_zone+1:fade_zone*2)=10^-7;%(mean(cal.trx_L(2*fade_zone+1-smooth_buffer:2*fade_zone+1+smooth_buffer)))*cos((pi/2)*[fade_zone-1:-1:0]/(fade_zone-1)).^2+0.0001;
trx_L(N-fade_zone*2+1:N-fade_zone)=10^-7;%(mean(cal.trx_L(N-2*fade_zone-smooth_buffer:N-2*fade_zone+smooth_buffer)))*cos((pi/2)*[0:1:fade_zone-1]/(fade_zone-1)).^2+0.0001;
trx_L(N-fade_zone+1:N)=10^-7;
% figure;plot(cal.freq_scale,(abs(trx_L(1:end-1))));
% hold on; plot(cal.freq_scale,(abs(cal.trx_L(1:end-1))), 'r');

%% recreate symmetric part of TF
trx_R_full=[trx_R,conj(flipdim(trx_R(2:end-1),2))];
trx_L_full=[trx_L,conj(flipdim(trx_L(2:end-1),2))];


% w_factor=[0.001 0.9 0.001];
% 
% i1=round(cal.min*1000/((cal.fs/2)/length(trx_L)));
% i2=round(cal.max*1000/((cal.fs/2)/length(trx_R)));
% weight(1:i1+10)=w_factor(1);
% weight(i1+10:i2)=w_factor(2);
% weight(i2:length(trx_L))=w_factor(3);
% w=0:pi/length(trx_L):pi-pi/length(trx_L);
% 
% 
% [cal.invIR_L, aa]=invfreqz(1./trx_L,w,254,0,weight);
% [cal.invIR_R, aa]=invfreqz(1./trx_R,w,254,0,weight);


% %% take ifft to get IR from TF
IR_R=real(ifft(trx_R_full',cal.collect))';
IR_L=real(ifft(trx_L_full',cal.collect))';
% 
% ''
% % IR_R=IR_R(20:end-20);
% % IR_L=IR_L(20:end-20);
% % 
% % %%% choose relevant part of IR (high energy)
% % %KM: took this from the "bird" part of Ilana's design_filter. Is this Z the
% % %correct dimensions?? (given that you've moved trx_L from 2D to 1D).
% % % is this part of the code right???
% % window=92;
% % N=N_pnts-39;
% % Z=zeros(N,N-window);
% % for a=1:N-window
% %     Z(1+a:window+a,a)=ones(window,1);
% % end
% % 
% % energyL=(abs(IR_L)).^2*Z;
% % energyR=(abs(IR_R)).^2*Z;
% % [max_L, ind_L]=max(energyL');
% % [max_R, ind_R]=max(energyR');
% % 
% % % Take 254 points of IR, starting at the high energy part
% % start_all=min(ind_L,ind_R);
% % IR_R=IR_R(start_all:start_all+254);
% % IR_L=IR_L(start_all:start_all+254);
% % 
% % IR_R(ind_R-start_all+1+window:end)=0;
% % IR_L(ind_L-start_all+1+window:end)=0;
% 
cal.IR_R= IR_R(1:254);
cal.IR_L= IR_L(1:254);

%%% create the inverse IR from IR using lsqinv3
cal.invIR_R=lsqinv3(cal.IR_R',255,[1700 2000 11000 11300],cal.fs,2,[-80 -60 0 0 -60 -80]);
cal.invIR_L=lsqinv3(cal.IR_L',255,[1700 2000 11000 11300],cal.fs,2,[-80 -60 0 0 -60 -80]);



%figure; plot(cal.invIR_R);

%%%%%%%%%%% CHECK THAT THE INVERSE FILTERS ARE WORKING AS INTENDED

% IR_R_norm=conv(cal.invIR_R,IR_R);
% IR_L_norm=conv(cal.invIR_L,IR_L);
% 
% fft_flat=fft(IR_R_norm,cal.collect);
% figure; plot(cal.freq_scale,20*log10(abs(fft_flat(1:cal.collect/2)))');


[H_R,f]=freqz(cal.invIR_R,1,cal.collect/2);
figure('menubar','none','color',cal.c_yellow,...
     'tag','design_fg');
subplot(2,1,1)   
 hold on;
% axes('units','normalized','position',[0.1300 0.400 0.7750 0.5150]);
plot(f*(cal.fs/2)/pi,20*log10(abs(1./cal.trx_R(1:end-1))),'.r')
plot(f*(cal.fs/2)/pi,20*log10(abs(H_R)),'-'); 
grid on;
legend('desired filter','designed filter');
title(['Inverse filter design -- right ear ']);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)')

[H_L,f]=freqz(cal.invIR_L,1,cal.collect/2);
subplot(2,1,2)   

 hold on;
% axes('units','normalized','position',[0.1300 0.400 0.7750 0.5150]);
plot(f*(cal.fs/2)/pi,20*log10(abs(1./cal.trx_L(1:end-1))),'.r')
plot(f*(cal.fs/2)/pi,20*log10(abs(H_L)),'-'); 
grid on;
% legend('designed filter','desired filter');
title(['Inverse filter design -- left ear']);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)')

%% scaling the filters to make sure they never increase the signal at any frequecy (to prevent clipping) %%
f=f*(cal.fs/2)/pi;
[m,ind_2khz]=min(abs(f-2000));
[m,ind_10khz]=min(abs(f-10000));

total_amp=max(max(abs(H_L(ind_2khz:ind_10khz))),max(abs(H_R(ind_2khz:ind_10khz))));
cal.invIR_R=cal.invIR_R/total_amp;
cal.invIR_L=cal.invIR_L/total_amp;

fprintf(1,'\n%s\n\n',['Filters finished.'])


return;
