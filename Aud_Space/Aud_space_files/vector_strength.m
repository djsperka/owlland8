function R=vector_strength(datatime,period)
	mods=mod(datatime,ones(1,length(datatime))*period); 
	phase=(mods/period)*2*pi;
	R=(((sum(cos(phase)))^2+(sum(sin(phase)))^2))^.5/length(phase);
return;