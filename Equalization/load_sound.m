function load_sound

global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus right_fig left_fig menu_fig;


if cal.earphone==0 % left earphone
    eq=cal.invIR_L;   
elseif cal.earphone==1 % right earphone
    eq=cal.invIR_R;
end

% put the filter on the RP1
if invoke(RP_1,'WriteTagV','equalization',0,eq')
    fprintf(1,'\n%s\n',['Equalization filter successfully loaded'])
else
    e='ERROR: Equalization filter incorrectly loaded'
    return;
end


% Play the sound to test filters
play_sound;

return
