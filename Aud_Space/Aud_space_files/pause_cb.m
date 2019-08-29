global runf snd;

if runf==1
    
    if snd.pause_flag==0
       snd.pause_flag=1;
       
       tic
       while 1  %%wait until the pause button is pressed again 
            drawnow;
            if snd.pause_flag==0
                break
            end
            if mod(toc,1)<0.5
                set(findobj(gcf,'tag','pause_indicator'),'visible','off');
                screen('closeall')
              else
                set(findobj(gcf,'tag','pause_indicator'),'visible','on');
            end
        end
    end   
    
    
    
    if snd.pause_flag==1
       set(findobj(gcf,'tag','pause_indicator'),'visible','on');
       snd.pause_flag=0;  
       
        if or(or(snd.Var1>7,snd.Var2>7),snd.screenblank==1)    %%%if there is a visual stimulus or the screen was blanked
            snd.window=SCREEN(0,'OpenWindow',0);
            hidecursor;                         %%  Hide the cursor
            screen(snd.window,'fillRect',snd.background*snd.white);       %%  Blank the Screen with the background color
            waitsecs(snd.pause_return);

        end

    end    
        
end
