clear all
close all


%% [1] Change StartDateTime field

MatlabCodeFolder = pwd;
folder = strcat(MatlabCodeFolder,'\Standardized\Data');
list = dir(folder);
list(1:2) = [];

for i = 1:length(list)

   path = fullfile(folder,list(i).name,'Laboratory','data.mat');

   fprintf('Subject %s\n',list(i).name);
   load(path)
   TM = fieldnames(data);

   for tm = 1:length(TM)

      Test = fieldnames(data.(TM{tm}));

      for test = 1:length(Test)

         if isfield(data.(TM{tm}).(Test{test}).Trial1,'StartDateTime')
            StartDateTime = datetime(data.(TM{tm}).(Test{test}).Trial1.StartDateTime,'InputFormat','yyyy-MM-dd HH:mm:ss','Format','yyyy-MM-dd''T''HH:mm:ss');
            data.(TM{tm}).(Test{test}).Trial1.StartDateTime = char(StartDateTime); 
         end

         clearvars StartDateTime

      end

   end

   save(path,'data')
   fprintf('data.mat updated\n')
   pause(0.1)
   clear data
   
end

cd(MatlabCodeFolder)