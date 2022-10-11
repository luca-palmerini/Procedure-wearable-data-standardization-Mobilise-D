clear all
close all


%% [1] Merge data.mat with raw signals and data.mat with standard outputs

MatlabCodeFolder = pwd;
datafold = strcat(MatlabCodeFolder,'\Standardized\Data');
SSfold = strcat(MatlabCodeFolder,'\Processed Data from IMUs Reference System');

cd(datafold)
datafoldlist = dir(datafold);
datafoldlist_isdir = ~ismember({datafoldlist.name}, {'.', '..'});
datafoldlist = datafoldlist(datafoldlist_isdir);
datafoldlistSize = size(datafoldlist,1);
alldatafold = {datafoldlist.name};

SSfoldlist = dir(SSfold);
SSfoldlist_isdir = ~ismember({SSfoldlist.name}, {'.', '..'});
SSfoldlist = SSfoldlist(SSfoldlist_isdir);
SSfoldSize = size(SSfoldlist,1);

for iSS = 1:SSfoldSize

   ID_SS = (SSfoldlist(iSS).name);
   matchFold=SSfoldlist(iSS).name;
   
   if ~isempty(matchFold)

       SS_path = fullfile(SSfold,SSfoldlist(iSS).name,'Laboratory','data.mat');

       if exist(SS_path,'file')

           SS = load(SS_path);
           TM_SS = fieldnames(SS.data);
           data_path =  fullfile(datafold,matchFold,'Laboratory','data.mat');
           DATA = load(data_path);
           TM_DATA = fieldnames(DATA.data);
    
           fprintf('Subject %s \n',matchFold)

           for iTM = 1:length(TM_SS)

               fprintf('%s \n',TM_SS{iTM})

               if isfield(SS.data.(TM_SS{iTM}),'Test1')    

                    if isfield(SS.data.(TM_SS{iTM}).Test1.Trial1.Standards,'SU_LowerShanks')
                       SU_LowerShanks =  SS.data.(TM_SS{iTM}).Test1.Trial1.Standards.SU_LowerShanks;
                       match_TM = cellfun(@(x) strcmp(TM_DATA,x),TM_SS,'UniformOutput',false);
                       match_TM = match_TM{iTM};

                       if ~isempty(find(match_TM)) 

                           if isfield(DATA.data.(TM_DATA{match_TM}),'Test1')
                               DATA.data.(TM_DATA{match_TM}).Test1.Trial1.Standards.SU_LowerShanks = SU_LowerShanks;
                               fprintf('SU_LowerShanks copied in data.mat \n')
                           else
                              fprintf('Test1 not available in %s %s of data.mat but it is available in SS \n',ID_SS,TM_SS{iTM})
                           end

                       end

                    else
                        fprintf('SS not available in %s %s\n',ID_SS,TM_SS{iTM})
                    end

               else
                   fprintf('Test4 not available in %s %s\n',ID_SS,TM_SS{iTM})
               end
               
           end

           data = DATA.data;
           save(data_path,'data')
           pause(0.1)
           clear data DATA SS

       else
           fprintf('data.mat not available for Subject %s \n',ID_SS)
       end
   else
       fprintf('Standard outputs folder not available for subject %d\n',ID_SS)
   end
   
end

cd(MatlabCodeFolder)