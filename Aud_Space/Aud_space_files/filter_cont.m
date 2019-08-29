function filtcont=filter_cont(savecont,vs_cutoff)
    global cont
    maxtrace=length(savecont);
    trace=1;
    filtcont={};
    for i=[1:maxtrace]      
        cont=savecont{i};
        params=cont_V_strength;
        vs_min=params(3);
        if cont.noise_hz>1
            vs_min=min([params(3),params(4)]);
        end  
        
        if vs_min>vs_cutoff
            filtcont{trace}=cont;
            filtcont{trace}.oldtrace=i;
            filtcont{trace}.trace=trace;
            trace=trace+1;
        end
    end

    
    
    
return


