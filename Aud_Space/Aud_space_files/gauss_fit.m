function [myu_r, c_r,myu_l, c_l] =gauss_fit(bimod)

if sum(bimod.hist_r)>0
[beta,r,J] =nlinfit((bimod.vis_x),(bimod.hist_r-min(bimod.hist_r))/(max(bimod.hist_r)-min(bimod.hist_r)),@gauss,[-1 2]);
myu_r=beta(1);
confidence=nlparci(beta,r,J);
c_r=confidence(1,:);
else
    myu_r=[];
    c_r=[];
end

if sum(bimod.hist_l)>0
[beta,r,J] =nlinfit((bimod.vis_x),(bimod.hist_l-min(bimod.hist_l))/(max(bimod.hist_l)-min(bimod.hist_l)),@gauss,[-1 2]);
myu_l=beta(1);
confidence=nlparci(beta,r,J);
c_l=confidence(1,:);
else
    myu_l=[];
    c_l=[];
end


% figure; plot(bimod.vis_x,(bimod.hist_r-min(bimod.hist_r))/(max(bimod.hist_r)-min(bimod.hist_r)))
% hold on
% plot(bimod.vis_x,gauss(beta,bimod.vis_x), 'r')