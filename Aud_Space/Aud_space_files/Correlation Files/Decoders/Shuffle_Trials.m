function shuffled=Shuffle_Trials(data)
%data is a m x n matrix, where m is the number of trials and n is the
%number of neurons

[m, n]=size (data);
shuffled=nan(size(data));
for i=1:n
    shuffled(:,i)=data(randperm(m),i);
end