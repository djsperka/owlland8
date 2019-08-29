function remove_cont_cb()
global cont multcont list;

total=length(multcont)-1;
clear global list;
global list;

if total>=0
	for i=1:total
	    list{i}= ['Interleaved trace #' num2str(i)];
	end
else
    list=[];    
end

remove = get(findobj('tag','inter_cont_tag'),'value');

if get(findobj('tag','inter_cont_tag'),'value') > length(list)
    set( findobj('tag','inter_cont_tag'),'value', length(list) );
end

set( findobj('tag','inter_cont_tag'),'string', list );


j=1;
temp=multcont;
clear global multcont;
global multcont;

if remove~=1
for i=1:remove-1
    multcont{j}=temp{i};
    j=j+1;
end
end
if remove~=total+1
for i=remove+1:total+1
    multcont{j}=temp{i};
    j=j+1;
end
end

return