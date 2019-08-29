function user_analysis(user_dir,filename);
% 	function user_analysis(user_dir,filename);
% 	user_dir=> sub-directory to find the function 'filename'.
% 	this function moves out of the current directory permanently.

	global snd rec
	cd(user_dir)
	eval(filename)
return;
