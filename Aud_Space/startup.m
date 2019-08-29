function startup

fprintf('Welcome to OwlLand ... loading default paths\nEdit default paths by adjust startup.m in your startup folder\n')
currentdir=cd;
ASPath=strcat(currentdir,'\Aud_space_files');
addpath (ASPath);
addpath (strcat(currentdir,'\Aud_space_files\Flexible_Stim'))
addpath (strcat(currentdir,'\..\DataAnalysis'))

addpath (strcat(currentdir,'\..\Equalization'))
 
% addpath('')

