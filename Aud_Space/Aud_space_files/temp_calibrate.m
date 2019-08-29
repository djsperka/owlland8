global snd RP_2
for i=0:10
	snd.background=.1*i;
	run_tuning_curve_cb;
	close;
	data=invoke(RP_2,'ReadTagV','ch1',1,48820);
	gamma(i+1)=mean(data);
end

figure;
gamma=-gamma;

plot([0:.1:1],gamma)
% gamma_norm=(gamma-min(gamma))/max(gamma-min(gamma));
% figure;plot(gamma_norm,[0:.05:1], 'k')
% 
% gamma_inv = interp1(gamma_norm,[0:.05:1],[0:.01:1]);
% 
% hold on;
% plot([0:.01:1],gamma_inv);

% for i=1:length(gamma)
% plot(i,gamma_correct(gamma(i)))
% end