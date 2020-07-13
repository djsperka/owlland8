  function heat_handles=Matrix_Graph(snd,chans)
  %Modified from set_matrix_graph.m in Aud_Space_files, with figure
  %initiation and spacing from Raster.m in my DataAnalysis folder
  %DJT 1/14/2013
  
  currentrep=snd.reps;
  MyScreen=get(0,'ScreenSize');
  
  counter=0;
  heat_handles=[];
  for chancount=chans %run through your matrix of channels
      %from original set_matrix_graph, replaced all rec.dispch w/
      %chancount
      counter=counter+1;
      p1=(counter-1)*MyScreen(3)/length(chans); %Save room for correlograms!
      p2=(MyScreen(4)/2); %Put it Halfway up
      p3=MyScreen(3)/length(chans);
      p4=MyScreen(4)/2-85;
      hand=figure ('position', [p1 p2 p3 p4]);
      heat_handles=[heat_handles,hand];
      
      if size(snd.datamat_pre,1)>1 && size(snd.datamat_pre,2)>1                  %%  display a contour plot if possible
          
          dispmat=(snd.datamat_post(:,:,chancount)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,chancount))))/currentrep;   %%  subtract the average pre and devide by reps
          
          contourf(snd.Var1array,snd.Var2array,dispmat,100);       %%show contour plot of one Channel
          colorbar;       %%show a reference bar for the contour plot
          h=get(gca,'children');
          set(h,'linestyle','none');
          xlabel(snd.Var1_choices(snd.Var1));
          ylabel(snd.Var2_choices(snd.Var2));
          set(get(gca,'xlabel'),'fontsize',14);
          set(get(gca,'ylabel'),'fontsize',14);
          title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(chancount)]);
          
      end;
  end
  
  return;