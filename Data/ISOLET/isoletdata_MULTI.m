function [trndata,valdata,tstdata,univdata]=isoletdata_MULTI(trncls,ntrn,nval,ntst,univcls,nuniv)
% semeiondata(trnsize,valsize,univtype,univsize)
% This function is used to process the isolet data in the reqd format
% cls1/clas2= albhabet no.s


load isolet1+2+3+4.data; %To get this data read the README.TXT in this folder.
load isolet5.data;

trn=isolet1_2_3_4;
tst=isolet5;
data=[trn;tst];

trndata.X=[]; trndata.y=[];
valdata.X=[]; valdata.y=[];
tstdata.X=[]; tstdata.y=[];

i = 0;
for cls = trncls
    i=i+1;
    ind=find(data(:,end)==cls);
    dataTrnX = data(ind,1:end-1);
    ind = randperm(size(dataTrnX,1));
    
    trndata.X =[trndata.X;dataTrnX(ind(1:ntrn),:)]; 
    trndata.y =[trndata.y;i*ones(ntrn,1)];
    
    valdata.X =[valdata.X;dataTrnX(ind(ntrn+1:ntrn+nval),:)];
    valdata.y =[valdata.y;i*ones(nval,1)];

    if(isempty(ntst)),
        tstdata.X = [tstdata.X;dataTrnX(ind(ntrn+nval+1:end),:)];
        ntst = length(ind(ntrn+nval+1:end));
        tstdata.y = [tstdata.y;i*ones(ntst,1)];
    else,
        tstdata.X = [tstdata.X;dataTrnX(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
        tstdata.y = [tstdata.y;i*ones(ntst,1)];
    end
    
end

univdata.X =[];
for cls = univcls
    ind=find(data(:,end)==cls);
    dataUX = data(ind,1:end-1);
    M=size(dataUX,1);
    ind = randperm(M);
    if(nuniv<=M)
        univdata.X =[univdata.X;dataUX(ind(1:nuniv),:)];
    else
        univdata.X =[univdata.X;dataUX(ind(1:M),:)];
    end
end
    
    
end




