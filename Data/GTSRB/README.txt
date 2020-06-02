1. GO TO the link https://sid.erda.dk/public/archives/daaeac0d7ce1152aea9b61d9f1e19370/published-archive.html and download the HOG data i.e. GTSRB_Final_Training_HOG.zip

2. For this paper we used the HOG 1 Features. Go to that folder which contains the HOG files for each classes in different folders. The Folders are named as 0000 -> sign '20', 0001 -> sign '30' so on. See the website for more details.

3. Read all the files in each folder in MATLAB and save them as a structure. i.e. 
a. For the "sign 20": Go to the folder 0000 and load all the files in the folder to MATLAB as data20.X .The data20.X should be a matrix of dimension 210 x 1568.
b. For "sign30" : Go to the folder 0001 and load all the files to MATLAB as data30.X. The data30.X should be a matrix of dimension 2220 x 1568

do this for all the signs ... 

4. Once all the data is loaded in the MATLAB workspace as data20.X, data30.X, so on... save the workspace as :- save raw_dataALL

For any questions regarding the data pertaining to the paper " Multiclass Learning from Contradictions" please contact sauptik.dhar@lge.com
