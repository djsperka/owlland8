function remove_inter_cb()
global snd multsnd list;

total=length(multsnd)-1;
clear global list;
global list;

if total>=0
	for i=1:total
	    list{i}= ['Interleaved trace #' num2str(i)];
	end
else
    list=[];    
end

remove = get(findobj('tag','inter_tag'),'value');

if get(findobj('tag','inter_tag'),'value') > length(list)
    set( findobj('tag','inter_tag'),'value', length(list) );
end

set( findobj('tag','inter_tag'),'string', list );


j=1;
temp=multsnd;
clear global multsnd;
global multsnd;

if remove~=1
for i=1:remove-1
    multsnd{j}=temp{i};
    j=j+1;
end
end
if remove~=total+1
for i=remove+1:total+1
    multsnd{j}=temp{i};
    j=j+1;
end
end

return