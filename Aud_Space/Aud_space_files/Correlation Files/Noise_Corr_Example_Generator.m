function Noise_Corr_Example ()
%make an example noise correlation plot from 2_24_15 p2s1 Chans 1 and 3
%Vweak data

load ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition\2_24_15_p2s1_summary.mat')
resp1=id_mt_data.resp_cell{1}(:,1);
resp2=id_mt_data.resp_cell{3}(:,1);
pfit_params=polyfit(resp1,resp2,1);
[rho,corrp]=corr(resp1,resp2);


figure 
plot(resp1,resp2,'o')
xlabel('Unit 1 Responses (re. baseline)')
ylabel('Unit 2 Responses (re. baseline)')
title ('Noise Correlation Calculation Example')
hold on
plot ([min(resp1),max(resp1)],[min(resp1),1;max(resp1),1]*pfit_params',':r')

leg{1}='Single Trials';
leg{2}=sprintf('R_2 = %.2f*R_1 + %.2f\nrho=%.2f\tp(corr)=%.4f',pfit_params(1),pfit_params(2),rho,corrp);
legend(leg)
% 
% 
% z1=(resp1-mean(resp1))./std(resp1);
% z2=(resp2-mean(resp2))./std(resp2);
% figure
% plot (z1,z2,'o')