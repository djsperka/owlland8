function [synth_site_cell,synth_dome_cell,var_out,cov_out]=VCS_Synthetic_Population()
% Design a post_cell with specified means, variance and covariances

%%% Choose Values
vis_mean=20;
vis_var=10;
vis_std=vis_var^.5;
vis_cor=.3;

aud_mean=20;
aud_var=15;
aud_std=aud_var^.5;
aud_cor=.5;

int_mean=0;
int_var=5;
int_std=int_var^.5;
int_cor=.7;

n_u=5;
n_p=n_u*(n_u-1)/2;
n_trials=50;
n_sites=100;

%%% Initialize Parameters
var_vp=nan(n_sites*n_u,1); %vis path
var_vi=nan(n_sites*n_u,1); %vis internal 
var_ap=nan(n_sites*n_u,1); %aud path
var_ai=nan(n_sites*n_u,1); %aud internal
var_bvp=nan(n_sites*n_u,1); %bim vis path
var_bap=nan(n_sites*n_u,1); %bim aud path
var_bi=nan(n_sites*n_u,1); %bim internal

cov_vp=nan(n_sites*n_p,1); %vis path
cov_vi=nan(n_sites*n_p,1); %vis internal 
cov_ap=nan(n_sites*n_p,1); %aud path
cov_ai=nan(n_sites*n_p,1); %aud internal
cov_bvp=nan(n_sites*n_p,1); %bim vis path
cov_bap=nan(n_sites*n_p,1); %bim aud path
cov_bi=nan(n_sites*n_p,1); %bim internal

%%% Start site loop
cov_mask=triu(true(n_u),1);

for i=1:n_sites
    
    site=[];
    
   %%%%%%% Visual Firing %%%%%%%%%%% 
    %make vis pathway 
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*vis_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_path_vis=[Q*resp_input]';
    cohort_path_vis=cohort_path_vis*vis_std+vis_mean;
    var_vp( 1+(i-1)*n_u: i*n_u)=std(cohort_path_vis).^2; %save variance
    temp_cov=cov(cohort_path_vis); %calculate covariance
    cov_vp(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
    
    %make internal 
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*int_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_int=[Q*resp_input]';
    cohort_int=cohort_int*int_std+int_mean;
    var_vi( 1+(i-1)*n_u: i*n_u)=std(cohort_int).^2; %save variance
    temp_cov=cov(cohort_int); %calculate covariance
    cov_vi(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
    
    %make vis response
    cohort_resp_vis=cohort_path_vis+cohort_int;
    
   %%%%%%% Auditory Firing %%%%%%%%%%%
    %make aud pathway responses
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*aud_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_path_aud=[Q*resp_input]';
    cohort_path_aud=cohort_path_aud*aud_std+aud_mean;
    var_ap( 1+(i-1)*n_u: i*n_u)=std(cohort_path_aud).^2; %save variance
    temp_cov=cov(cohort_path_aud); %calculate covariance
    cov_ap(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
            
    %make internal 
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*int_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_int=[Q*resp_input]';
    cohort_int=cohort_int*int_std+int_mean;
    var_ai( 1+(i-1)*n_u: i*n_u)=std(cohort_int).^2; %save variance
    temp_cov=cov(cohort_int); %calculate covariance
    cov_ai(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
    
    % aud response
    cohort_resp_aud=cohort_path_aud+cohort_int;
    
       %%%%%%% Bimodal Firing %%%%%%%%%%%    
     %make vis pathway 
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*vis_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_path_vis=[Q*resp_input]';
    cohort_path_vis=cohort_path_vis*vis_std+vis_mean;
    var_bvp( 1+(i-1)*n_u: i*n_u)=std(cohort_path_vis).^2; %save variance
    temp_cov=cov(cohort_path_vis); %calculate covariance
    cov_bvp(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
    
    %make aud pathway responses
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*aud_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_path_aud=[Q*resp_input]';
    cohort_path_aud=cohort_path_aud*aud_std+aud_mean;
    var_bap( 1+(i-1)*n_u: i*n_u)=std(cohort_path_aud).^2; %save variance
    temp_cov=cov(cohort_path_aud); %calculate covariance
    cov_bap(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
            
    %make internal 
    resp_input=randn(n_u,n_trials);
    C=ones(n_u)*int_cor .* ~eye(n_u) + eye(n_u);
    Q=C^.5;
    cohort_int=[Q*resp_input]';
    cohort_int=cohort_int*int_std+int_mean;
    var_bi( 1+(i-1)*n_u: i*n_u)=std(cohort_int).^2; %save variance
    temp_cov=cov(cohort_int); %calculate covariance
    cov_bi(1+(i-1)*n_p: i*n_p)=temp_cov(cov_mask); %save covariance
    
    % bim response
    cohort_resp_bim=cohort_path_vis+cohort_path_aud+cohort_int;
    
    %%%%%%%%%%% Store values in site structure
    site.id_mt_labels{1}='Vw_I  ';
    site.id_mt_labels{2}='A_I  ';
    site.id_mt_labels{3}='A_I  Vw_I';
    
    for j=1:n_u
        site.id_mt_data.post_cell{j}(:,1)=cohort_resp_vis(:,j);
        site.id_mt_data.post_cell{j}(:,2)=cohort_resp_aud(:,j);
        site.id_mt_data.post_cell{j}(:,3)=cohort_resp_bim(:,j);
    end
    
    synth_site_cell{i}=site;
    synth_dome_cell{i}=true(n_u,1);
end

%%% Store Output
var_out.var_vp=var_vp; %vis path
var_out.var_vi=var_vi; %vis internal 
var_out.var_ap=var_ap; %aud path
var_out.var_ai=var_ai; %aud internal
var_out.var_bvp=var_bvp; %bim vis path
var_out.var_bap=var_bap; %bim aud path
var_out.var_bi=var_bi; %bim internal

cov_out.cov_vp=cov_vp; %vis path
cov_out.cov_vi=cov_vi; %vis internal 
cov_out.cov_ap=cov_ap; %aud path
cov_out.cov_ai=cov_ai; %aud internal
cov_out.cov_bvp=cov_bvp; %bim vis path
cov_out.cov_bap=cov_bap; %bim aud path
cov_out.cov_bi=cov_bi; %bim internal