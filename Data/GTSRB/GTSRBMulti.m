function [trndata,valdata,tstdata,univdata]=GTSRBMulti(ntrn,nval,ntst,trnID,nuniv,uID)
% Copyright (c) 2019 LG Electronics Inc.
% SPDX-License-Identifier: Apache-2.0

load raw_dataALL  %To get this data read the README.TXT in this folder.
trndata.X=[]; trndata.y=[];
valdata.X=[]; valdata.y=[];
tstdata.X=[]; tstdata.y=[];

i = 0;
for id = trnID
    i= i+1;
    switch(id)
            case 20,
                ind = randperm(size(data20.X,1));
                trndata.X =[trndata.X;data20.X(ind(1:ntrn))];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data20.X(ind(ntrn+1:ntrn+nval))];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data20.X(ind(ntrn+nval+1:ntrn+nval+ntst))];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
            case 30,
                ind = randperm(size(data30.X,1));
                trndata.X =[trndata.X;data30.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data30.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data30.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
            case 50,
                ind = randperm(size(data50.X,1));
                trndata.X =[trndata.X;data50.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data50.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data50.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
             case 60,
                ind = randperm(size(data60.X,1));
                trndata.X =[trndata.X;data60.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data60.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data60.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
             case 70,
                ind = randperm(size(data70.X,1));
                trndata.X =[trndata.X;data70.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data70.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data70.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
             case 80,
                ind = randperm(size(data80.X,1));
                trndata.X =[trndata.X;data80.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data80.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data80.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
             case 100,
                ind = randperm(size(data100.X,1));
                trndata.X =[trndata.X;data100.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data100.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data100.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
                
             case 120,
                ind = randperm(size(data120.X,1));
                trndata.X =[trndata.X;data120.X(ind(1:ntrn),:)];
                trndata.y =[trndata.y;i*ones(ntrn,1)];

                valdata.X =[valdata.X;data120.X(ind(ntrn+1:ntrn+nval),:)];
                valdata.y =[valdata.y;i*ones(nval,1)];
                
                tstdata.X =[tstdata.X;data120.X(ind(ntrn+nval+1:ntrn+nval+ntst),:)];
                tstdata.y =[tstdata.y;i*ones(ntst,1)];
    end
end

univdata.X=[];
i = 0;
for id = uID;
    i= i+1;
    switch(id)
            case 1,
                ind = randperm(size(dataU1.X,1));
                univdata.X =[univdata.X;dataU1.X(ind(1:nuniv),:)];
                
            case 2,
                ind = randperm(size(dataU2.X,1));
                univdata.X =[univdata.X;dataU2.X(ind(1:nuniv),:)];
                
            case 3,
                ind = randperm(size(dataU3.X,1));
                univdata.X =[univdata.X;dataU3.X(ind(1:nuniv),:)];
                
             case 4,
               ind = randperm(size(dataU4.X,1));
                univdata.X =[univdata.X;dataU4.X(ind(1:nuniv),:)];
                
             case 5,
                ind = randperm(size(dataU5.X,1));
                univdata.X =[univdata.X;dataU5.X(ind(1:nuniv),:)];
                
             case 6,
                ind = randperm(size(dataU6.X,1));
                univdata.X =[univdata.X;dataU6.X(ind(1:nuniv),:)];
                
             case 7,
                ind = randperm(size(dataU7.X,1));
                univdata.X =[univdata.X;dataU7.X(ind(1:nuniv),:)];
                
             case 8,
               ind = randperm(size(dataU8.X,1));
                univdata.X =[univdata.X;dataU8.X(ind(1:nuniv),:)];
                
             case 9,
               ind = randperm(size(dataU9.X,1));
                univdata.X =[univdata.X;dataU9.X(ind(1:nuniv),:)];
                
             case 10,
               ind = randperm(size(dataU10.X,1));
               univdata.X =[univdata.X;dataU10.X(ind(1:nuniv),:)]; 
               
             case 11,
                ind = randperm(size(dataU11.X,1));
                univdata.X =[univdata.X;dataU11.X(ind(1:nuniv),:)]; 
                
             case 12,
                ind = randperm(size(dataU12.X,1));
                univdata.X =[univdata.X;dataU12.X(ind(1:nuniv),:)]; 
                
              case 13,
               ind = randperm(size(dataU13.X,1));
                univdata.X =[univdata.X;dataU13.X(ind(1:nuniv),:)];
           
             case 14,
               ind = randperm(size(dataU14.X,1));
               univdata.X =[univdata.X;dataU14.X(ind(1:nuniv),:)]; 
               
             case 15,
                ind = randperm(size(dataU15.X,1));
                univdata.X =[univdata.X;dataU15.X(ind(1:nuniv),:)]; 
                
             case 16,
                ind = randperm(size(dataU16.X,1));
                univdata.X =[univdata.X;dataU16.X(ind(1:nuniv),:)];  
                
             case 17,
               ind = randperm(size(dataU17.X,1));
               univdata.X =[univdata.X;dataU17.X(ind(1:nuniv),:)]; 
               
             case 18,
                ind = randperm(size(dataU18.X,1));
                univdata.X =[univdata.X;dataU18.X(ind(1:nuniv),:)]; 
                
             case 19,
                ind = randperm(size(dataU19.X,1));
                univdata.X =[univdata.X;dataU19.X(ind(1:nuniv),:)];
                
             case 20,
                ind = randperm(size(dataU20.X,1));
                univdata.X =[univdata.X;dataU20.X(ind(1:nuniv),:)];  
                
            case 21,
               ind = randperm(size(dataU21.X,1));
               univdata.X =[univdata.X;dataU21.X(ind(1:nuniv),:)];
           
             case 22,
               ind = randperm(size(dataU22.X,1));
               univdata.X =[univdata.X;dataU22.X(ind(1:nuniv),:)]; 
        
    end
end
    

end