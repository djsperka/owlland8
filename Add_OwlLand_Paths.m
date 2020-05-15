function Add_OwlLand_Paths()


fullpath=mfilename ('fullpath');
fprintf ('\nUsing Doug''s custom matlab startup located in %s\n\n',fullpath)

fname=mfilename;
fpath=fullpath(1:(findstr(fullpath,fname)-1));

addpath (strcat(fpath,'DownloadedTools'))
addpath (strcat(fpath,'Aud_Space'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files\Correlation Files'))
addpath (strcat(fpath,'DataAnalysis'))
addpath (strcat(fpath,'DataAnalysis\Manual_Analysis_Tools'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files\Other Analyses'))
addpath(strcat(fpath,'Aud_Space\manual_tools'))
addpath(strcat(fpath,'Aud_Space\Aud_space_files\Correlation Files\Decoders'))
addpath(strcat(fpath,'Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition\saliency\new simulation correlation code'))

addpath (strcat(fpath,'Aud_Space\Aud_space_files\Summary_Workspaces'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files\Summary_Workspaces\analysis_scripts'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files\Summary_Workspaces\other_scripts'))
addpath (strcat(fpath,'Aud_Space\Aud_space_files\Summary_Workspaces\plotting_scipts'))

addpath (strcat(fpath,'Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition\saliency'))

fprintf('\nWelcome to OwlLand. \n')
fprintf ('   _ \n (o,o)\n<  .  >\n--"-"---\n')
fprintf('\nYour paths have been added. To modify, Add_OwlLand_Paths.m in Aud_Space folder\n\n')




