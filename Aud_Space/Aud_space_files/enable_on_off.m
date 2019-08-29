function enable_on_off()
    global rec snd
    %% this function disables sound/vis tags that aren't being used, and vice versa
        if snd.play_sound2 == 0
            set(findobj(gcf,'tag','itd2'),'enable','off');    
            set(findobj(gcf,'tag','ild2'),'enable','off'); 
            set(findobj(gcf,'tag','abi2'),'enable','off'); 
            set(findobj(gcf,'tag','freqlo2'),'enable','off'); 
            set(findobj(gcf,'tag','freqhi2'),'enable','off'); 
            set(findobj(gcf,'tag','ITD2text'),'enable','off');    
            set(findobj(gcf,'tag','ILD2text'),'enable','off'); 
            set(findobj(gcf,'tag','ABI2text'),'enable','off'); 
            set(findobj(gcf,'tag','lofreqtext2'),'enable','off'); 
            set(findobj(gcf,'tag','hifreqtext2'),'enable','off'); 
        else
            set(findobj(gcf,'tag','itd2'),'enable','on');    
            set(findobj(gcf,'tag','ild2'),'enable','on'); 
            set(findobj(gcf,'tag','abi2'),'enable','on'); 
            set(findobj(gcf,'tag','freqlo2'),'enable','on'); 
            set(findobj(gcf,'tag','freqhi2'),'enable','on');   
            set(findobj(gcf,'tag','ITD2text'),'enable','on');    
            set(findobj(gcf,'tag','ILD2text'),'enable','on'); 
            set(findobj(gcf,'tag','ABI2text'),'enable','on'); 
            set(findobj(gcf,'tag','lofreqtext2'),'enable','on'); 
            set(findobj(gcf,'tag','hifreqtext2'),'enable','on'); 
        end
        
        if snd.play_sound1 == 0
            set(findobj(gcf,'tag','itd1'),'enable','off');    
            set(findobj(gcf,'tag','ild1'),'enable','off'); 
            set(findobj(gcf,'tag','abi1'),'enable','off'); 
            set(findobj(gcf,'tag','freqlo1'),'enable','off'); 
            set(findobj(gcf,'tag','freqhi1'),'enable','off'); 
            set(findobj(gcf,'tag','ITDtext'),'enable','off');    
            set(findobj(gcf,'tag','ILDtext'),'enable','off'); 
            set(findobj(gcf,'tag','ABItext'),'enable','off'); 
            set(findobj(gcf,'tag','lofreqtext'),'enable','off'); 
            set(findobj(gcf,'tag','hifreqtext'),'enable','off'); 
        else
            set(findobj(gcf,'tag','itd1'),'enable','on');    
            set(findobj(gcf,'tag','ild1'),'enable','on'); 
            set(findobj(gcf,'tag','abi1'),'enable','on'); 
            set(findobj(gcf,'tag','freqlo1'),'enable','on'); 
            set(findobj(gcf,'tag','freqhi1'),'enable','on');   
            set(findobj(gcf,'tag','ITDtext'),'enable','on');    
            set(findobj(gcf,'tag','ILDtext'),'enable','on'); 
            set(findobj(gcf,'tag','ABItext'),'enable','on'); 
            set(findobj(gcf,'tag','lofreqtext'),'enable','on'); 
            set(findobj(gcf,'tag','hifreqtext'),'enable','on'); 
        end
        
           if snd.play_vis1 == 0
            set(findobj(gcf,'tag','vis_offset'),'enable','off');    
            set(findobj(gcf,'tag','el'),'enable','off'); 
            set(findobj(gcf,'tag','az'),'enable','off'); 
            set(findobj(gcf,'tag','angle'),'enable','off'); 
            set(findobj(gcf,'tag','distance'),'enable','off'); 
            set(findobj(gcf,'tag','dotsize'),'enable','off');    
            set(findobj(gcf,'tag','foreground'),'enable','off'); 
            set(findobj(gcf,'tag','vis_offsettext'),'enable','off');    
            set(findobj(gcf,'tag','eltext'),'enable','off'); 
            set(findobj(gcf,'tag','aztext'),'enable','off'); 
            set(findobj(gcf,'tag','angletext'),'enable','off'); 
            set(findobj(gcf,'tag','distancetext'),'enable','off'); 
            set(findobj(gcf,'tag','dotsizetext'),'enable','off');    
            set(findobj(gcf,'tag','foregroundtext'),'enable','off'); 
            set(findobj(gcf,'tag','size_change_text'),'enable','off');    
            set(findobj(gcf,'tag','size_change'),'enable','off');    
     
        else
            set(findobj(gcf,'tag','vis_offset'),'enable','on');    
            set(findobj(gcf,'tag','el'),'enable','on'); 
            set(findobj(gcf,'tag','az'),'enable','on'); 
            set(findobj(gcf,'tag','angle'),'enable','on'); 
            set(findobj(gcf,'tag','distance'),'enable','on'); 
            set(findobj(gcf,'tag','dotsize'),'enable','on');    
            set(findobj(gcf,'tag','size_change'),'enable','on');    
            set(findobj(gcf,'tag','foreground'),'enable','on');  
            set(findobj(gcf,'tag','vis_offsettext'),'enable','on');    
            set(findobj(gcf,'tag','eltext'),'enable','on'); 
            set(findobj(gcf,'tag','aztext'),'enable','on'); 
            set(findobj(gcf,'tag','angletext'),'enable','on'); 
            set(findobj(gcf,'tag','distancetext'),'enable','on'); 
            set(findobj(gcf,'tag','dotsizetext'),'enable','on');    
            set(findobj(gcf,'tag','size_change_text'),'enable','on');    
            set(findobj(gcf,'tag','foregroundtext'),'enable','on');  
        end
        
        if snd.play_vis2 == 0
%             set(findobj(gcf,'tag','vis_offset2'),'enable','off');    
            set(findobj(gcf,'tag','el2'),'enable','off'); 
            set(findobj(gcf,'tag','az2'),'enable','off'); 
            set(findobj(gcf,'tag','angle2'),'enable','off'); 
            set(findobj(gcf,'tag','distance2'),'enable','off'); 
            set(findobj(gcf,'tag','dotsize2'),'enable','off');    
            set(findobj(gcf,'tag','foreground2'),'enable','off'); 
%             set(findobj(gcf,'tag','vis_offset2text'),'enable','off');    
            set(findobj(gcf,'tag','el2text'),'enable','off'); 
            set(findobj(gcf,'tag','az2text'),'enable','off'); 
            set(findobj(gcf,'tag','angle2text'),'enable','off'); 
            set(findobj(gcf,'tag','distance2text'),'enable','off'); 
            set(findobj(gcf,'tag','dotsize2text'),'enable','off');    
            set(findobj(gcf,'tag','foreground2text'),'enable','off');
            set(findobj(gcf,'tag','size_change2_text'),'enable','off');
            set(findobj(gcf,'tag','size_change2'),'enable','off'); 
        else
%             set(findobj(gcf,'tag','vis_offset2'),'enable','on');    
            set(findobj(gcf,'tag','el2'),'enable','on'); 
            set(findobj(gcf,'tag','az2'),'enable','on'); 
            set(findobj(gcf,'tag','angle2'),'enable','on'); 
            set(findobj(gcf,'tag','distance2'),'enable','on'); 
            set(findobj(gcf,'tag','dotsize2'),'enable','on');    
            set(findobj(gcf,'tag','foreground2'),'enable','on');  
%             set(findobj(gcf,'tag','vis_offset2text'),'enable','on');    
            set(findobj(gcf,'tag','el2text'),'enable','on'); 
            set(findobj(gcf,'tag','az2text'),'enable','on'); 
            set(findobj(gcf,'tag','angle2text'),'enable','on'); 
            set(findobj(gcf,'tag','distance2text'),'enable','on'); 
            set(findobj(gcf,'tag','dotsize2text'),'enable','on');    
            set(findobj(gcf,'tag','foreground2text'),'enable','on');    
            set(findobj(gcf,'tag','size_change2'),'enable','on');  
            set(findobj(gcf,'tag','size_change2_text'),'enable','on');
        end
        
 