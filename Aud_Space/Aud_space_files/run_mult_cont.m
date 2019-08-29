function run_mult_cont()
	global cont rec multcont;
	save_mult_cont_dialog
	
    pres_order=[randperm(length(multcont));
	for i=[1:length(multcont)]
        cont=multcont(pres_order(i));
        continuous_move;
        save_file_bin_cont;
	end
return;