function var_cell=Var_Builder(var_choice, site_data)
%Depending on the variable choice, builds a cell array with the first
%element being the chosen static data, and the second element being
%the chosen looming data.  If there is a p-value associated, the third
%and fourth elements of var_cell will be the p value
var_cell={};

switch var_choice
    case 1
        var_cell{1}=site_data.data_NCr_stat;
        var_cell{2}=site_data.data_NCr_loom;
        var_cell{3}=site_data.data_NCp_stat;
        var_cell{4}=site_data.data_NCp_loom;
        
    case 2
        var_cell{1}=site_data.data_wap_sep;
        var_cell{2}=site_data.data_wap_sep_loom;        
    case 3
        var_cell{1}=site_data.data_wag_sep;
        var_cell{2}=site_data.data_wag_sep_loom;
        
    case 4
        var_cell{1}=site_data.data_dp_stat;
        var_cell{2}=site_data.data_dp_loom;
        
    case 5
        var_cell{1}=site_data.data_NCr_pre_stat;
        var_cell{2}=site_data.data_NCr_pre_loom;
        var_cell{3}=site_data.data_NCp_pre_stat;
        var_cell{4}=site_data.data_NCp_pre_loom;
        
    case 6
        var_cell{1}=site_data.data_NCr_post_stat;
        var_cell{2}=site_data.data_NCr_post_loom;
        var_cell{3}=site_data.data_NCp_post_stat;
        var_cell{4}=site_data.data_NCp_post_loom;
        
end