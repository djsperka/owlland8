function out=gamma_correct(in)

global snd rec

    
%% find val in xarray that is closest to "in"
[m,index]=min(abs(snd.gamma_inv(2,:)-in));

%% plug into inverse gamma function
out=snd.gamma_inv(1,index);

return
