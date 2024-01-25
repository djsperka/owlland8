function startup

fprintf('Welcome to OwlLand ... loading default paths\nEdit default paths by adjust startup.m in your startup folder\n')
addpath(cd);
addpath(fullfile(cd, 'Aud_space_files'));
addpath(fullfile(cd, 'Aud_space_files', 'Flexible_Stim'))
addpath(fullfile(cd, '..', 'Equalization'));
%addpath(fullfile(cd, '..', 'DataAnalysis'));

