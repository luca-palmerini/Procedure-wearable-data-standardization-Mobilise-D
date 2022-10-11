clear all
close all


%% [1] Create infoForAlgo.mat
MatlabCodeFolder = pwd;
% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 34);
opts.Sheet = "Dataset";
opts.DataRange = "A2:AH2";
opts.VariableNames = ["Number", "First_name", "Gender", "Age_t1", "Age_t2", "Age_t3", "Height_t1", "Height_t2", "Height_t3", "Weight_t1", "Weight_t2", "Weight_t3", "Falls_Retrospective_t0", "Falls_t1_Anyfall", "Falls_t2_Anyfall", "Falls_t3_Anyfall", "UPDRS_III_t1", "UPDRS_III_t2", "UPDRS_III_t3", "HY_t1", "HY_t2", "HY_t3", "PDQ_Mobility_t1", "PDQ_Stigma_t1", "PDQ_t1", "WalkingAid_01_t1", "WalkingAid_Side_t1", "WalkingAid_Description_t1", "WalkingAid_01_t2", "WalkingAid_Side_t2", "WalkingAid_Description_t2", "WalkingAid_01_t3", "WalkingAid_Side_t3", "WalkingAid_Description_t3"];
opts.VariableTypes = ["double", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "double", "string", "string", "double", "string", "string"];
opts = setvaropts(opts, ["First_name", "Falls_Retrospective_t0", "Falls_t1_Anyfall", "Falls_t2_Anyfall", "Falls_t3_Anyfall", "UPDRS_III_t1", "UPDRS_III_t2", "UPDRS_III_t3", "HY_t1", "HY_t2", "HY_t3", "PDQ_Mobility_t1", "PDQ_Stigma_t1", "PDQ_t1", "WalkingAid_Side_t1", "WalkingAid_Description_t1", "WalkingAid_Side_t2", "WalkingAid_Description_t2", "WalkingAid_Side_t3", "WalkingAid_Description_t3"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["First_name", "Falls_Retrospective_t0", "Falls_t1_Anyfall", "Falls_t2_Anyfall", "Falls_t3_Anyfall", "UPDRS_III_t1", "UPDRS_III_t2", "UPDRS_III_t3", "HY_t1", "HY_t2", "HY_t3", "PDQ_Mobility_t1", "PDQ_Stigma_t1", "PDQ_t1", "WalkingAid_Side_t1", "WalkingAid_Description_t1", "WalkingAid_Side_t2", "WalkingAid_Description_t2", "WalkingAid_Side_t3", "WalkingAid_Description_t3"], "EmptyFieldRule", "auto");
infoForAlgo_tot_path = strcat(MatlabCodeFolder,'\Original\Clinical Data.xlsx');
infoForAlgo_tot = readtable(infoForAlgo_tot_path, opts, "UseExcel", false);
clear opts

MatlabCodeFolder = pwd;
subjectsPath=strcat(MatlabCodeFolder,'\Standardized\Data');
cd(subjectsPath)
subjectsList = dir(subjectsPath);
subjectsList_isdir = ~ismember({subjectsList.name}, {'.', '..'});
subjectsList = subjectsList(subjectsList_isdir);
subjectsListSize = size(subjectsList,1);

for iSbj = 1:subjectsListSize
    ID_sbjFold = subjectsList(iSbj).name;
    fprintf('Subject %s \n',ID_sbjFold)
    dataPath = fullfile(subjectsPath,subjectsList(iSbj).name,'Laboratory');
    load(fullfile(dataPath,'data.mat'))
    TM = fieldnames(data);
    line = find(strcmp(infoForAlgo_tot.First_name,ID_sbjFold));
    for iTM = 1:length(TM)
       nTM = TM{iTM}(end); 
       if strcmp(infoForAlgo_tot.Gender(line),'')==0
           if infoForAlgo_tot.Gender(line)==0
               infoForAlgo.(TM{iTM}).Gender(line) = 'M';
           elseif infoForAlgo_tot.Gender(line)==1
               infoForAlgo.(TM{iTM}).Gender(line) = 'F';
           end
           
           % TimeMeasure1
           if strcmp(nTM,'1') == 1
               infoForAlgo.(TM{iTM}).Age = infoForAlgo_tot.Age_t1(line);
               infoForAlgo.(TM{iTM}).Weight = infoForAlgo_tot.Weight_t1(line);
               infoForAlgo.(TM{iTM}).Height = infoForAlgo_tot.Height_t1(line)*100;
               infoForAlgo.(TM{iTM}).WalkingAid_01 = infoForAlgo_tot.WalkingAid_01_t1(line);
               if infoForAlgo.(TM{iTM}).WalkingAid_01 == 1
                   infoForAlgo.(TM{iTM}).WalkingAid_Side = char(infoForAlgo_tot.WalkingAid_Side_t1(line));
                   infoForAlgo.(TM{iTM}).WalkingAid_Description = char(infoForAlgo_tot.WalkingAid_Description_t1(line));
               end
           end
           % TimeMeasure2
           if strcmp(nTM,'2') == 1
               infoForAlgo.(TM{iTM}).Age = infoForAlgo_tot.Age_t2(line);
               infoForAlgo.(TM{iTM}).Weight = infoForAlgo_tot.Weight_t2(line);
               infoForAlgo.(TM{iTM}).Height = infoForAlgo_tot.Height_t2(line)*100;
               infoForAlgo.(TM{iTM}).WalkingAid_01 = infoForAlgo_tot.WalkingAid_01_t2(line);
               if infoForAlgo.(TM{iTM}).WalkingAid_01 == 1
                   infoForAlgo.(TM{iTM}).WalkingAid_Side = char(infoForAlgo_tot.WalkingAid_Side_t2(line));
                   infoForAlgo.(TM{iTM}).WalkingAid_Description = char(infoForAlgo_tot.WalkingAid_Description_t2(line));
               end
           end
           % TimeMeasure3
           if strcmp(nTM,'3') == 1
               infoForAlgo.(TM{iTM}).Age = infoForAlgo_tot.Age_t3(line);
               infoForAlgo.(TM{iTM}).Weight = infoForAlgo_tot.Weight_t3(line);
               infoForAlgo.(TM{iTM}).Height = infoForAlgo_tot.Height_t3(line)*100;
               infoForAlgo.(TM{iTM}).WalkingAid_01 = infoForAlgo_tot.WalkingAid_01_t3(line);
               if infoForAlgo.(TM{iTM}).WalkingAid_01 == 1
                   infoForAlgo.(TM{iTM}).WalkingAid_Side = char(infoForAlgo_tot.WalkingAid_Side_t3(line));
                   infoForAlgo.(TM{iTM}).WalkingAid_Description = char(infoForAlgo_tot.WalkingAid_Description_t3(line));
               end
           end
           infoForAlgo.(TM{iTM}).SensorType_SU = 'OPAL';
           infoForAlgo.(TM{iTM}).SensorAttachment_SU = 'Body-Worn';
       end
    end

    if exist('infoForAlgo','var')
        save(fullfile(dataPath,'infoForAlgo.mat'),'infoForAlgo')
        pause(0.1)
        fprintf('infoForAlgo.mat saved\n')
        clear infoForAlgo
    else
        fprintf('infoForAlgo missing \n')
    end
    
    
end

cd(MatlabCodeFolder)