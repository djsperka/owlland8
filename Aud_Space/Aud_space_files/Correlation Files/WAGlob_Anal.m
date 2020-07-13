function waglob=WAGlob_Anal(VarArray,disp_collapse)
%Calculate the global weighted average

norm=disp_collapse/sum(disp_collapse);
weights=norm.*VarArray;
waglob=sum(weights);