function Rate_Corrected_NC_Test ()
% this function will try and test whether rate-corrected noise correlations
% could work
% first step is to see if I can simulate responses with a specific
% combination of noise correlations and firing rates.  
% After that, artificially reduce firing rate and see what the does to
% observed noise correlations

%% simulate noise correlation - correlate amount of activation in each bin
ncorr=0.5; %noise corr
fr_bar=10; %mean fr in hz
ttotal=250; %total time in ms
tbin=1; %width of time bins
nbins=ttotal/tbin; %number of time bins
nreps=50; %how many times do you do this?
set_fano=2.5; %fano factor, based on my observed data
sigma1=(set_fano*fr_bar)^.5; %fano=std^2 / mean <--> std=(fano*mean) ^.5
sigma2=(set_fano*fr_bar)^.5; %fano=std^2 / mean <--> std=(fano*mean) ^.5
noise1=randn(nreps,1); %normally distributed noise with a std that will give the observed ff
noise2=randn(nreps,1);

inrate1=noise1*sigma1+fr_bar; %firing rates w/ variance
% inrate2=(noise1*ncorr+noise2*(1-ncorr))*sigma2+fr_bar;
inrate2=inrate1*.5+.5*(fr_bar+noise2*sigma2);

%%%%%CURRENTLY THIS IS NOT WORKING.  IMMEDIATE PROBLEM IS THAT THIS DOES
%%%%%NOT GENERATE THE CORRECT STD FOR INRATE2



pspike=fr_bar*tbin/1000; %probability of a spike in each bin
tstamps=1:tbin:ttotal; %time stamps


act1=rand(nbins,nreps); %activation on neuron 1
act2=act1*ncorr+rand(nbins,nreps)*(1-ncorr); %activation of neuron 2
timecourse1=act1>( 1-pspike);
rate1=sum(timecourse1)/(ttotal/1000);
timecourse2=act2>( 1-pspike);
rate2=sum(timecourse)/(ttotal/1000);

%% how does FF vary with observation window?
niter=100;
ff=nan(1,niter);
for i=1:niter
    fr_bar=10; %fr in hz
    ttotal=10*i; %total time in ms
    tbin=1; %width of time bins
    nbins=ttotal/tbin; %number of time bins
    pspike=fr_bar*tbin/1000; %probability of a spike in each bin
    tstamps=1:tbin:ttotal; %time stamps
    
    nreps=50; %how many times do you do this?
    
    timecourse=rand(nbins,nreps)>( 1-pspike);
    rate=sum(timecourse)/(ttotal/1000);
    ff(i)=std(rate).^2 / mean(rate);
end
figure
plot (ff,(1:niter)*10)
xlabel('Fano Factor')
ylabel ('Observation Length (ms)')

%% how does FF vary with firing rate?
niter=100;
ff=nan(1,niter);
for i=1:niter
    fr_bar=i; %fr in hz
    ttotal=250; %total time in ms
    tbin=1; %width of time bins
    nbins=ttotal/tbin; %number of time bins
    pspike=fr_bar*tbin/1000; %probability of a spike in each bin
    tstamps=1:tbin:ttotal; %time stamps
    
    nreps=50; %how many times do you do this?
    
    timecourse=rand(nbins,nreps)>( 1-pspike);
    rate=sum(timecourse)/(ttotal/1000);
    ff(i)=std(rate).^2 / mean(rate);
end
figure
plot (ff,1:niter)
xlabel('Fano Factor')
ylabel ('Firing Rate')