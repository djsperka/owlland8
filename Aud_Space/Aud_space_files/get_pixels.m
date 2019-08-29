function    get_pixels()
        myscreen=get(0,'screensize');
        window=SCREEN(0,'OpenWindow',0);
        hidecursor;                         %%  Hide the cursor
        black=BlackIndex(window);       %%  Find the value of black for the monitor
        white=WhiteIndex(window);       %%
        
        
        
        while 1
            
            SCREEN(window,'WaitBlanking',1);
            screen(window,'fillRect',black);       %%  Blank the Screen with the background color
            
            
            [x,y,buttons] = GetMouse;
            SCREEN(window,'WaitBlanking',1);
            SCREEN(window,'DrawLine',white,myscreen(1),y,myscreen(3),y,[1])
            SCREEN(window,'DrawLine',white,x,myscreen(2),x,myscreen(4),[1])
            
            [x,y,buttons] = GetMouse;
            
            if charavail
                [x,y]
                break
            end
            
        end;
                    screen(window,'fillRect',black);       %%  Blank the Screen with the background color

% % % %         SCREEN(window,'DrawLine',white,19,1013,19,26,[1])
% % % %         SCREEN(window,'DrawLine',white,19,1013,1271,1013,[1])
% % % %         SCREEN(window,'DrawLine',white,1271,1013,1271,26,[1])
% % % %         SCREEN(window,'DrawLine',white,19,26,1271,26,[1])
        
        
            SCREEN(window,'DrawLine',white,myscreen(1),y,myscreen(3),y,[1])
            SCREEN(window,'DrawLine',white,x,myscreen(2),x,myscreen(4),[1])

        pause
        pause
        SCREEN('CloseAll');                 %%  Close the Screen
     return;
     
