function vs_mat=get_VS_all()
    global savecont cont
    
    vs_mat=zeros(length(savecont),4);
    
    for i=[1:length(savecont)]
        cont=savecont{i};
        vs_mat(i,:)=cont_V_strength;
    end
    return