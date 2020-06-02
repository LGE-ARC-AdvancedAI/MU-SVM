function [dataset]= libsvm2mat(filename)
%AUTHOR:- SAUPTIK DHAR
%This will convert the LIBSVM format to the .mat file.
dataset=struct;
%INITIALIZE
for i=1:78
    dataset.class(i).data=[];
end

[fid]=fopen(filename);
j=0;
    while 1
        j=j+1;
        tline = fgetl(fid);
        if ~ischar(tline), 
            break, 
        end
        temp = strread(tline,'%d','delimiter',':');
        nfeat=(length(temp)-3)/2;
        dat=zeros(1,10000);
        index=[];
        for i=1:nfeat 
            index=[index,temp(2*i)];
        end
        dat(index+1)=1;
        %dataset.class(temp(1)+1).data(temp(end)+1,:)=dat;
        dataset.class(temp(1)+1).data=[dataset.class(temp(1)+1).data;dat];
        %display(j);
    end
fclose(fid);

%Check
% len=0;
% for i=1:78
%     len=len+size(dataset.class(i).data,1);
% end
% len 