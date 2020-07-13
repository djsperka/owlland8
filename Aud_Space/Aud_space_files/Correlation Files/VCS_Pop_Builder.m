function [post_out,var_out,cov_out]=VCS_Pop_Builder(site_cell,dome_cell,n_shuff)

%%% Initialize population assembly vectors
pop_bim_resp=[]; %these are baseline subtracted, to be used for the response analysis
pop_sum_resp=[];

% post-period only
pop_vis_post=[];
pop_aud_post=[];
pop_bim_post=[]; 
pop_sum_post=[];
pop_sumALL_post=[];

pop_aud_var=[];
pop_vis_var=[];
pop_bim_var=[];
pop_sum_var=[];
pop_sumALL_var=[];

pop_aud_cov=[];
pop_vis_cov=[];
pop_bim_cov=[];
pop_sum_cov=[];
pop_sumALL_cov=[];
source_indx=[];

% Sum without shuffling
pop_sum_var_NS=[];
pop_sum_cov_NS=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_cell_count=0;

for i=1:length(site_cell);
        site=site_cell{i};
        
        %find the correct columnd of your multitrace data
        vis_ind=strcmp(site.id_mt_labels,'Vw_I  ');
        aud_ind=strcmp(site.id_mt_labels,'A_I  ');
        bim_ind=strcmp(site.id_mt_labels,'A_I  Vw_I');
        
        if sum(bim_ind)~=0 % If there was bimodal data we will use this site
            site_dome=dome_cell{1,i};
            num_cells=sum(site_dome);     
            
            % grab post-period responses for each cell
            site_post=site.id_mt_data.post_cell(site_dome);
            
            vis_post=nan(50,num_cells);
            aud_post=vis_post;
            bim_post=vis_post;
            
            for j=1:num_cells
                vis_post(:,j)=site_post{j}(:,vis_ind);
                aud_post(:,j)=site_post{j}(:,aud_ind);
                bim_post(:,j)=site_post{j}(:,bim_ind);
            end
            
            %%%% compile bimiodal response data
            % Post
            pop_vis_post=[pop_vis_post,mean(vis_post)];
            pop_aud_post=[pop_aud_post,mean(aud_post)];
            pop_bim_post=[pop_bim_post,mean(bim_post)];
            
            % Variance
            pop_vis_var=[pop_vis_var,std(vis_post).^2];
            pop_aud_var=[pop_aud_var,std(aud_post).^2];
            pop_bim_var=[pop_bim_var,std(bim_post).^2];  
            
            % Covariance
            if num_cells>1
                mask=triu ( true(num_cells,num_cells),1 );
                
                temp_cov=cov(vis_post);
                vis_cov=temp_cov(mask);
                pop_vis_cov=[pop_vis_cov,vis_cov'];
                
                temp_cov=cov(aud_post);
                aud_cov=temp_cov(mask);
                pop_aud_cov=[pop_aud_cov,aud_cov'];
                
                temp_cov=cov(bim_post);
                bim_cov=temp_cov(mask);
                pop_bim_cov=[pop_bim_cov,bim_cov'];
                
                source_mat=ones(num_cells,1)*[total_cell_count+1:total_cell_count+num_cells];
                source_mat_flip=source_mat';
                source_indx=[source_indx;source_mat_flip(mask),source_mat(mask)];
            end
            total_cell_count=total_cell_count+num_cells;
            
            %%% Shuffle aud relative to vis
            %  keep units associated with eachother
            shuff_mu=nan(n_shuff,num_cells);
            shuff_var=shuff_mu;
            shuff_cov=nan(n_shuff,num_cells*(num_cells-1)/2);
            
            for j=1:n_shuff
                % Shuffle - data is in n_resp x n_cell matrix
                shuff_aud=aud_post(randperm(50),:);
                sum_av_post=vis_post+shuff_aud;
                
                % Mean
                shuff_mu(j,:)=mean(sum_av_post);
                
                % Variance
                shuff_var(j,:)=std(sum_av_post).^2;
                
                % Covariance
                if num_cells>1
                    temp_cov=cov(sum_av_post);
                    shuff_cov(j,:)=temp_cov(triu ( true(num_cells,num_cells),1 ));
                end
                
            end
            
            %%% Calculate sum without shuffle also
            sum_av_post_NS=vis_post+aud_post;
            pop_sum_var_NS=[pop_sum_var_NS,std(sum_av_post_NS).^2];
            temp_cov=cov(sum_av_post);
            pop_sum_cov_NS=[pop_sum_cov_NS;temp_cov(triu ( true(num_cells,num_cells),1 ))];
            
            %%% Compile unimodal sum response data
            % Output Populations
            pop_sumALL_post=[pop_sumALL_post,shuff_mu];
            pop_sumALL_var=[pop_sumALL_var,shuff_var];
            pop_sumALL_cov=[pop_sumALL_cov,shuff_cov];
            % Output Averages
            sum_mu=mean(shuff_mu,1);
            sum_var=mean(shuff_var,1);
            sum_cov=mean(shuff_cov,1);
            pop_sum_post=[pop_sum_post,sum_mu];
            pop_sum_var=[pop_sum_var,sum_var];
            pop_sum_cov=[pop_sum_cov,sum_cov];
            
        end
end   

post_out.vis=pop_vis_post;
post_out.aud=pop_aud_post;
post_out.bim=pop_bim_post; 
post_out.sum=pop_sum_post;
post_out.sumALL=pop_sumALL_post;

var_out.aud=pop_aud_var;
var_out.vis=pop_vis_var;
var_out.bim=pop_bim_var;
var_out.sum=pop_sum_var;
var_out.sumALL=pop_sumALL_var;

cov_out.aud=pop_aud_cov;
cov_out.vis=pop_vis_cov;
cov_out.bim=pop_bim_cov;
cov_out.sum=pop_sum_cov;
cov_out.sumALL=pop_sumALL_cov;
cov_out.si=source_indx;

%%% Sum without shuffling
var_out.sum_NS=pop_sum_var_NS;
cov_out.sum_NS=pop_sum_cov_NS;