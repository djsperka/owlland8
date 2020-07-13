function test_vect_norm_can_delete_later
peak_locs=[-1 3;1 3;1.5 -.5]; %neuron 1 = 1,4.  n2=3,1
norm_resp=[1; 1; 1];

loc_norm=1;

non_loc_norm=0;

%%% Location Noramlization
if loc_norm

% Calculate the peka center
BL=min(peak_locs); %bottom left
TR=max(peak_locs); %top right
peak_cent = min(peak_locs) + (max(peak_locs) - min(peak_locs)) /2;
% Subtract center to translate peak locations around it
peak_locs_TL = peak_locs - ones (size (peak_locs,1),1)*peak_cent;
% Calculate Left/Right Force Vectors
right_cent=peak_locs_TL(:,1)>0; %find everything pulling right
right_pull=sum(peak_locs_TL(right_cent,1)); %find total pull to the right
force_vectors(right_cent,1)=peak_locs_TL(right_cent,1)/right_pull; %make total pull to the right =1; 
left_pull=abs(sum(peak_locs_TL(~right_cent,1))); %total left pull
force_vectors(~right_cent,1)=peak_locs_TL(~right_cent,1)/left_pull; %normalize left pull
% Calculate Up/Down Force Vectors
above_cent=peak_locs_TL(:,2)>0;
up_pull=sum(peak_locs_TL(above_cent,2));
down_pull=abs(sum(peak_locs_TL(~above_cent,2)));
force_vectors(above_cent,2)=peak_locs_TL(above_cent,2)/up_pull;
force_vectors(~above_cent,2)=peak_locs_TL(~above_cent,2)/down_pull;
% Scale to fit bounding box ... otherwise scaled to 1
force_scale=ones(size(force_vectors,1),1)* (max(peak_locs)-min(peak_locs))/2;
force_vectors=force_vectors .* force_scale;

x_vect= force_vectors(:,1).*norm_resp ;
y_vect= force_vectors(:,2).*norm_resp ;

x_sum=sum(x_vect) + peak_cent(1);
y_sum=sum(y_vect) + peak_cent(2);

figure
hold on
plot (peak_locs(:,1),peak_locs(:,2),'+b','MarkerSize',20,'LineWidth',3) %plot neuron tuning
plot ([BL(1),TR(1),TR(1),BL(1),BL(1)],[BL(2),BL(2),TR(2),TR(2),BL(2)],':g') %plot bounding box
plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)],[BL(2),peak_cent(2);TR(2),peak_cent(2)],':g') %plot center of box
plot ([zeros(size(x_vect'));x_vect']+peak_cent(1),[zeros(size(y_vect')) ; y_vect']+peak_cent(2)) %plot vector contributions
plot (x_sum,y_sum,'ok') %plot location estimate
%%% add x and y axes
xax=xlim+[-1 1];
yax=ylim+[-1 1];
plot ([xax;0 0]',[0 0;yax]','k')
hold off

end

if non_loc_norm

%%% ABSOLUTE VALUE ON
% x_vect=norm_resp(:,:).*peak_locs(:,1) ./ sum(abs(norm_resp(:,:)))'; %Mx1, where M = reps*groups
% y_vect=norm_resp(:,:).*peak_locs(:,2) ./ sum(abs(norm_resp(:,:)))';

%%% ABSOLUTE VALUE OFF
x_vect=norm_resp(:,:).*peak_locs(:,1) ./ sum(norm_resp(:,:))'; %Mx1, where M = reps*groups
y_vect=norm_resp(:,:).*peak_locs(:,2) ./ sum(norm_resp(:,:))';

x_sum=sum(x_vect);
y_sum=sum(y_vect);

figure
hold on
plot (peak_locs(:,1),peak_locs(:,2),'+b','MarkerSize',20,'LineWidth',3) %plot neuron tuning

% plot (-peak_locs(:,1),-peak_locs(:,2),'+r','MarkerSize',20,'LineWidth',3) %plot inverted tuning
plot ([0 0 0;x_vect'],[0 0 0 ; y_vect']) %plot vector contributions
plot (x_sum,y_sum,'ok') %plot location estimate
xax=xlim+[-1 1];
yax=ylim+[-1 1];
plot ([xax;0 0]',[0 0;yax]','k')
hold off

end

%% test out location estimator on synthetic dataset
keyboard

%% Code Dump

%%%%%%%%%%%%%%%%% Figures for plotting location normalization

% %%% No translation, no scaling
% figure
% hold on
% plot (peak_locs(:,1) ,peak_locs(:,2) ,'+b','MarkerSize',20,'LineWidth',3) %plot neuron tuning
% plot ([BL(1),TR(1),TR(1),BL(1),BL(1)],  [BL(2),BL(2),TR(2),TR(2),BL(2)],':g') %plot bounding box
% plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)],  [BL(2),peak_cent(2);TR(2),peak_cent(2)],  ':g') %plot center of box
% plot ([zeros(size(x_vect'));peak_locs(:,1)'],  [zeros(size(y_vect')) ; peak_locs(:,2)'] )
% %%% add x and y axes
% xax=xlim+[-1 1];
% yax=ylim+[-1 1];
% plot ([xax;0 0]',[0 0;yax]','k')
% hold off
% 
% %%% Translated, no scaling
% figure
% hold on
% plot (peak_locs(:,1) - peak_cent(1),peak_locs(:,2) - peak_cent(2),'+b','MarkerSize',20,'LineWidth',3) %plot neuron tuning
% plot ([BL(1),TR(1),TR(1),BL(1),BL(1)]-peak_cent(1),  [BL(2),BL(2),TR(2),TR(2),BL(2)]-peak_cent(2),':g') %plot bounding box
% plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)]-peak_cent(1),  [BL(2),peak_cent(2);TR(2),peak_cent(2)]-peak_cent(2),  ':g') %plot center of box
% plot ([zeros(size(x_vect'));peak_locs(:,1)'-peak_cent(1)] ,  [zeros(size(y_vect')) ; peak_locs(:,2)'-peak_cent(2)] )
% % plot ([zeros(size(x_vect'));x_vect']+peak_cent(1),[zeros(size(y_vect')) ; y_vect']+peak_cent(2)) %plot vector contributions
% % plot (x_sum,y_sum,'ok') %plot location estimate
% %%% add x and y axes
% xax=xlim+[-1 1];
% yax=ylim+[-1 1];
% plot ([xax;0 0]',[0 0;yax]','k')
% hold off
% 
% %%% Translated and scaled
% figure
% hold on
% plot (peak_locs(:,1) - peak_cent(1),peak_locs(:,2) - peak_cent(2),'+b','MarkerSize',20,'LineWidth',3) %plot neuron tuning
% plot ([BL(1),TR(1),TR(1),BL(1),BL(1)]-peak_cent(1),  [BL(2),BL(2),TR(2),TR(2),BL(2)]-peak_cent(2),':g') %plot bounding box
% plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)]-peak_cent(1),  [BL(2),peak_cent(2);TR(2),peak_cent(2)]-peak_cent(2),  ':g') %plot center of box
% plot ([zeros(size(x_vect'));x_vect'],[zeros(size(y_vect')) ; y_vect']) %plot vector contributions
% % plot (x_sum,y_sum,'ok') %plot location estimate
% %%% add x and y axes
% xax=xlim+[-1 1];
% yax=ylim+[-1 1];
% plot ([xax;0 0]',[0 0;yax]','k')
% hold off

