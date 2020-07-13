function [var_cell,title,pairwise_var]=Var_Builder(var_choice, site_data)
%Depending on the variable choice, builds a cell array with the first
%element being the chosen static data, and the second element being
%the chosen looming data.  If there is a p-value associated, the third
%and fourth elements of var_cell will be the p value
%
% The use of a cell array was for when I was doing the salience mapping
% stuff before.  I could have done away with it, but that would just take
% more work so I haven't made any modifications
var_cell={};

pairwise_var=1;
switch var_choice
    
    case 1 %NC - vis
        fprintf('\nThis is the metric for noise correlation during initial RF mapping ... you probably don''t have it anymore.  Sorry mate!\n')
        title='Vis Noise Correlation (r)';
        var_cell{1}=site_data.data_NCr_vis;
        var_cell{2}=site_data.data_NCp_vis;   
        pairwise_var=1;   
    case 2 %Sep. peak-COM vis
        title='Vis Peak Seperation (deg.)';
        var_cell{1}=site_data.data_wap_sep_vis;
        pairwise_var=1;
    case 3 %DotProduct vis
        title='Vis DotProduct';
        var_cell{1}=site_data.data_dp_vis;
        pairwise_var=1;
        
    case 4 %NC - aud
        fprintf('\nThis is the metric for noise correlation during initial RF mapping ... you probably don''t have it anymore.  Sorry mate!\n')
        title='Aud Noise Correlation (r)';
        var_cell{1}=site_data.data_NCr_aud;
        var_cell{2}=site_data.data_NCp_aud;   
        pairwise_var=1;           
    case 5 %Sep. peak-COM aud
        title='Aud Peak Seperation (deg)';
        if isfield(site_data,'data_wap_sep_aud')
            var_cell{1}=site_data.data_wap_sep_aud;
        else
            var_cell{1}=nan(size(site_data.data_wap_sep_vis));
        end
        pairwise_var=1;      
    case 6 %DotProduct aud
        title='Aud Dot Product';
        if isfield(site_data,'data_dp_aud')
            var_cell{1}=site_data.data_dp_aud;
        else
            var_cell{1}=nan(size(site_data.data_dp_vis));
        end
        pairwise_var=1;
        
    case 7 %MTrace - Responses
        title='Response';
        var_cell{1}=site_data.data_mt_resp;
        pairwise_var=0;        
    case 8 %Mtrace - ResponseNC (baseline subtracted)
        title='Noise Correlation (Post-Pre) ';
        var_cell{1}=site_data.data_mt_resp_corr;   
        pairwise_var=1;
    case 9 %Mtrace - PostNC (not baseline subtracted)
        title='Post Period Noise Correlation (r)';
        var_cell{1}=site_data.data_mt_post_corr;
        pairwise_var=1;        
    case 10 % MTrace - PreNC
        title = 'Pre Period Noise Correlation (r)';
        var_cell{1}=site_data.data_mt_pre_corr;
        pairwise_var=1;
        
    case 11 %Mtrace - Fano Factor
        title = 'Fano Factor';
        var_cell{1}=site_data.data_fano;
        pairwise_var=0;
        
    case 12 %Peak Separation in Azimuth - Vis
        title = 'Vis Peak Sep. Az (degrees)';
        if isfield (site_data,'data_wap_sep_vis_az')
            var_cell{1}=site_data.data_wap_sep_vis_az;
        else
            var_cell{1}=nan(size(site_data.data_dp_vis));
        end
        pairwise_var=1;
    case 13 %Peak Separation in Azimuth - Aud
        title = 'Aud Peak Sep. Az (degrees)';
        if isfield (site_data,'data_wap_sep_aud_az')
            var_cell{1}=site_data.data_wap_sep_aud_az;
        else
            var_cell{1}=nan(size(site_data.data_dp_vis));
        end
        pairwise_var=1;
        
end