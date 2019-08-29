function [smooth_line,liner]=WaveStretcher(vect)
%%Function written to stretch out waves as they are detected, and them
%%smooth them and display them.  This will help with single unit isolation
%%during recording sessions.
%%Added by DJT 12/11/2012

stretcher=20;
liner=zeros(1,(length(vect)-1)*stretcher);
liner(1)=vect(1);
for i=1:(length(vect)-1)
    slope=(vect(i+1)-vect(i))/stretcher;
    for j=0:(stretcher-2)
        liner(stretcher*i-j)=vect(i)+slope*(stretcher-1-j);
    end
    liner (stretcher*i+1)=vect(i+1);
end

    smooth_line=smooth(liner,stretcher*1/2);
    smooth_line=smooth_line';

return

