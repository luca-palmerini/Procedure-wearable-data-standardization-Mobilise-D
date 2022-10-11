%% [0] Initialization
clc
clear all
close all
warning off
format compact;

data = struct;                                                              
%% [1] Info extraction

% 1.1 Directories and folders definition
MatlabCodeFolder = pwd;
DirectoryPath_Project = strcat(MatlabCodeFolder,'\Original');
cd(DirectoryPath_Project)
FileProtocols = dir(DirectoryPath_Project);     
FileProtocols_isdir = ~ismember({FileProtocols.name}, {'.', '..','Clinical Data.xlsx','~$Clinical Data.xlsx','GaitRite_Complete.xlsx','~$GaitRite_Complete.xlsx'});
FileProtocols = FileProtocols(FileProtocols_isdir);
FileProtocolsSize = size(FileProtocols,1);
DirectoryPath_Standardized = strcat(MatlabCodeFolder,'\Standardized\Data');

% 1.2 GaitRite data extraction 
[~,~,GaitRiteData] = xlsread('GaitRite_Complete.xlsx','Outputs'); 
GaitRiteData=GaitRiteData(2:end,:);

GaitRite_Info=zeros(size(GaitRiteData,1),5);
for iSub_GR = 1:size(GaitRiteData,1)

    SubjectCode_GR = char(GaitRiteData(iSub_GR,1));

    % Group : HC (0) / PD (1)
    if strcmp(GaitRiteData{iSub_GR,3},'Control')
        GaitRite_Info(iSub_GR,1) = 0;
    elseif strcmp(GaitRiteData{iSub_GR,3},'PD')
        GaitRite_Info(iSub_GR,1) = 1;
    else
        GaitRite_Info(iSub_GR,1) = NaN;
    end

    % Subject ID Num
    GaitRite_Info(iSub_GR,2) = str2num(SubjectCode_GR);

    % Cognitive Task : Single (1) / Double (2)
    CogTest_GR = char(GaitRiteData(iSub_GR,9));
    if strcmp(CogTest_GR,'Single')                                          
        GaitRite_Info(iSub_GR,3) = 1;
    else % Double
        GaitRite_Info(iSub_GR,3) = 2;
    end

    % Walking Task: Continous (1) / Intermittent (2)
    WalkTest_GR = char(GaitRiteData(iSub_GR,10));
    if strcmp(WalkTest_GR(1:4),'Cont')                                        
        GaitRite_Info(iSub_GR,4) = 1;
    else % Intermittent
        GaitRite_Info(iSub_GR,4) = 2;
    end

    % TimeMeasure: F2 (1) , F3 (2) , F4 (3)
    TimeMeasure_GR = GaitRiteData{iSub_GR,2};
    if strcmp(TimeMeasure_GR,'F2')                                             
        GaitRite_Info(iSub_GR,5) = 1;
    elseif strcmp(TimeMeasure_GR,'F3')    
        GaitRite_Info(iSub_GR,5) = 2;
    elseif strcmp(TimeMeasure_GR,'F4')    
        GaitRite_Info(iSub_GR,5) = 3;
    else
        GaitRite_Info(iSub_GR,5) = NaN;
    end

end

GaitRite_Numeric = [GaitRite_Info, cell2mat(GaitRiteData(:,[7 8 11:20 6]))];

% 1.3 Clinical data extraction
[~,~,ClinicalData] = xlsread('Clinical Data','Dataset');
ClinicalData=ClinicalData(2:end,:);

%% [2] Data arrangement

% 2.1 Loop over all protocols
for iTest = 1:FileProtocolsSize

    FileProtocols(iTest,1).name;
    DirectoryPath_Protocol = [DirectoryPath_Project '\' FileProtocols(iTest,1).name];
    FileGroups = dir(DirectoryPath_Protocol);
    FileGroups_isdir = ~ismember({FileGroups.name}, {'.', '..'}); 
    FileGroups = FileGroups(FileGroups_isdir);
    FileGroupsSize = size(FileGroups,1);
    
    % 2.2 Loop over all groups 
    for iGroup = 1:FileGroupsSize

        GroupsName = FileGroups(iGroup,1).name;
        DirectoryPath_Group = [DirectoryPath_Protocol '\' GroupsName];
        cd(DirectoryPath_Group)
        FileSubjects = dir(DirectoryPath_Group);
        FileSubjects_isdir = ~ismember({FileSubjects.name}, {'.', '..'});    
        FileSubjects = FileSubjects(FileSubjects_isdir);
        FileSubjectsSize = size(FileSubjects,1);
           
        % 2.3 Loop over all subjects
        for iSubject = 1:FileSubjectsSize

            FileName = FileSubjects(iSubject,1).name;
            INGCode = FileName(end-11:end-8);
            SubjectID = FileName(end-11:end-8);
            SubjectIDNum = str2num(SubjectID);
            SubjectAsignedNum = cell2mat(ClinicalData(find(strcmp(ClinicalData(:,2), INGCode)),1)); 
 
            fprintf('Subject %s \n',INGCode)
            if strcmp(GaitRiteData{find(strcmp(GaitRiteData(:,1),INGCode),1),3},'PD')
                GroupNum = 1;
            elseif strcmp(GaitRiteData{find(strcmp(GaitRiteData(:,1),INGCode),1),3},'Control')
                GroupNum = 0;
            end            
            
            % 2.4 TimeMeasureNum & TestNum extraction
            TimeMeasureNum = str2num(FileName(end-6:end-6))-1;              % F2 = 1, F3 = 2, F4 = 3
            TimeMeasure = ['TimeMeasure' num2str(TimeMeasureNum)];
            TestName = FileName(end-4:end-3);

            if strcmp(TestName,'SC')                                        % Single continous (SC)
                TestNum = 1;
            else %SI                                                        % Single intermittent (SI)
                TestNum = 2;
            end

            Test = ['Test' num2str(TestNum)];
            fprintf('%s %s standardization \n',TimeMeasure,Test)
            
            % 2.5  Check if the directory exists (and load data) or create a new one
            CurrDir = [DirectoryPath_Standardized '\' INGCode '\' 'Laboratory'];
            if exist(CurrDir,'dir')
                cd(CurrDir)
                load('data','data');
                cd(DirectoryPath_Group) 
                DirectoryPath_Subject = [DirectoryPath_Standardized '\' INGCode]; 
                DirectoryProject_Subject_Lab = [DirectoryPath_Subject '\' 'Laboratory']; 
            else
               mkdir(CurrDir)                     
               DirectoryPath_Subject = [DirectoryPath_Standardized '\' INGCode];
               DirectoryProject_Subject_Lab = [DirectoryPath_Subject '\' 'Laboratory'];
            end
            
            % 2.6 GaitRite info extraction                
            GaitRite_Sub = GaitRite_Numeric(find(GaitRite_Numeric(:,2) == SubjectIDNum),:); % Selection based on correct Subjects Code
            GaitRite_Group = GaitRite_Sub(find(GaitRite_Sub(:,1) == GroupNum),:); % Selection based on correct Group(P/C), because in some cases there was the same code assigned to P and to C
            GaitRite_TimeMeasure = GaitRite_Group(find(GaitRite_Group(:,5) == TimeMeasureNum),:); % Select data for corresponding TimeMeasurement
            GaitRite_CogTest = GaitRite_TimeMeasure(find(GaitRite_TimeMeasure(:,3) == 1),:); %1 = Single, 2 = Double
            GaitRite_WalkTest = GaitRite_CogTest(find(GaitRite_CogTest(:,4) == TestNum),:); %1 = Continous, 2 = Intermittent
            GaitRite__Selected = GaitRite_WalkTest;
            
            % 2.7 OPAL data extraction
            OPALinfo = h5info(FileName);
            try
                vers = hdf5read(FileName, '/FileFormatVersion');
            catch
                error('Could not determine file format');
            end
            if vers< 2
                error('This example only works with version 2 or later of the data file')
            end
            OPALread = hdf5read(FileName,'/CaseIdList');

            for iLocSensor = 1:length(OPALinfo.Groups)

                SensorLocID = OPALinfo.Attributes(1).Value{iLocSensor,1};  
                SensorLocID = SensorLocID(1:2);
                OPALdata = OPALread(iLocSensor).data;
                accPath = [OPALdata '/Calibrated/Accelerometers'];
                gyroPath = [OPALdata '/Calibrated/Gyroscopes'];
                StartDateTime = [FileName(1:4) '-' FileName(5:6) '-' FileName(7:8) ' ' FileName(10:11) ':' FileName(12:13) ':' FileName(14:15)];
                fs = hdf5read(FileName, [OPALdata '/SampleRate']); 
                fs = double(fs);
                acc_m_s2 = hdf5read(FileName, accPath)'; 
                gyr_rad_s = hdf5read(FileName, gyroPath)';
                % Units transformation (m/sec^2 to g, rad/sec to deg/s)
                acc = acc_m_s2./9.81;                                           
                gyr = gyr_rad_s.*(180/pi);                    

                % 2.8 Loop over all acc data (for different locations)
                if strcmp(SensorLocID,'WT') == 1 % WT = waist, lower back
                    LocSensorPos = 'LowerBack';
                    acc_std(:,1) = -acc(:,1);
                    acc_std(:,2) = acc(:,2);
                    acc_std(:,3) = -acc(:,3);
                    gyr_std(:,1) = -gyr(:,1);
                    gyr_std(:,2) = gyr(:,2);
                    gyr_std(:,3) = -gyr(:,3);
                    if mean(acc_std(:,1)) < 0
                        acc_std(:,1) = -acc_std(:,1);
                        gyr_std(:,1) = -gyr_std(:,1);
                    end
                elseif strcmp(SensorLocID,'LA') == 1 % LA = left ankle 
                    LocSensorPos = 'LeftLowerShank';
                    acc_std(:,1) = -acc(:,1);
                    acc_std(:,2) = -acc(:,3);
                    acc_std(:,3) = -acc(:,2);
                    gyr_std(:,1) = -gyr(:,1);
                    gyr_std(:,2) = -gyr(:,3);
                    gyr_std(:,3) = -gyr(:,2);
                    if mean(acc_std(:,1)) < 0
                        acc_std(:,1) = -acc_std(:,1);
                        gyr_std(:,1) = -gyr_std(:,1);
                    end
                elseif strcmp(SensorLocID,'C7') == 1 % C7 = head (7th cervical) below the neck
                    LocSensorPos = 'NeckFixed';
                    acc_std(:,1) = -acc(:,1);
                    acc_std(:,2) = acc(:,2);
                    acc_std(:,3) = -acc(:,3);
                    gyr_std(:,1) = -gyr(:,1);
                    gyr_std(:,2) = gyr(:,2);
                    gyr_std(:,3) = -gyr(:,3);
                    if mean(acc_std(:,1)) < 0
                        acc_std(:,1) = -acc_std(:,1);
                        gyr_std(:,1) = -gyr_std(:,1);
                    end
                elseif strcmp(SensorLocID,'RA') == 1 % RA = right ankle 
                    LocSensorPos = 'RightLowerShank';
                    acc_std(:,1) = -acc(:,1);
                    acc_std(:,2) = acc(:,3);
                    acc_std(:,3) = acc(:,2);
                    gyr_std(:,1) = -gyr(:,1);
                    gyr_std(:,2) = gyr(:,3);
                    gyr_std(:,3) = gyr(:,2);
                    if mean(acc_std(:,1)) < 0
                        acc_std(:,1) = -acc_std(:,1);
                        gyr_std(:,1) = -gyr_std(:,1);
                    end
                elseif strcmp(SensorLocID,'HD') == 1 % HD = back of head
                    LocSensorPos = 'Head';
                    acc_std(:,1) = -acc(:,1);
                    acc_std(:,2) = acc(:,2);
                    acc_std(:,3) = -acc(:,3);
                    gyr_std(:,1) = -gyr(:,1);
                    gyr_std(:,2) = gyr(:,2);
                    gyr_std(:,3) = -gyr(:,3);
                    if mean(acc_std(:,1)) < 0
                        acc_std(:,1) = -acc_std(:,1);
                        gyr_std(:,1) = -gyr_std(:,1);
                    end
                end

            % 2.9 Data for SU 
            data.(TimeMeasure).(Test).Trial1.SU.(LocSensorPos).Fs.Acc = fs;    
            data.(TimeMeasure).(Test).Trial1.SU.(LocSensorPos).Fs.Gyr = fs;
            data.(TimeMeasure).(Test).Trial1.SU.(LocSensorPos).Acc = acc_std; % [g]
            data.(TimeMeasure).(Test).Trial1.SU.(LocSensorPos).Gyr = gyr_std; % [rad/sec]
            sizeSU = size(data.(TimeMeasure).(Test).Trial1.SU.(LocSensorPos).Acc,1);

            clearvars acc_std gyr_std
            
            end
            
            % 2.10 Flag for annotations field
            Flag = zeros(1,sizeSU); 
            t = 0:(1/fs):(1/fs)*(sizeSU-1);

            %% Template with all the variables 

            % List of standard outputs for GaitRite
            StandardOutput_Walkway_Pass_file=strcat(MatlabCodeFolder,'\StandardOutput_Walkway_Pass.mat');
            load(StandardOutput_Walkway_Pass_file)
            allVar = Walkway_Pass;

            for i = 1:length(allVar)
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass.(allVar{i}) = [];
            end
            data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Fs = 200;

            % 2.11 Data selection based on Passes from Gaitrite: first and last contacts
            GaitIDSize = unique(GaitRite__Selected(:,6));
            for iPass = 1:size(GaitIDSize,1) 

                nPass = ['WB' num2str(iPass)];
                GaitID = GaitIDSize(iPass);
                GaitID_Data_unsorted = GaitRite__Selected(find(GaitRite__Selected(:,6) == GaitID),:);
                GaitID_Data = sortrows(GaitID_Data_unsorted,7);  

                % * Correction of Gaitrite provided with duplicates
                if length(GaitID_Data(:,7)) ~= length(unique(GaitID_Data(:,7)))
                    [~,GaitID_Data_StepIDNonRepeated,~] = unique(GaitID_Data(:,7));
                    GaitID_Data = GaitID_Data(GaitID_Data_StepIDNonRepeated,:);
                    % fprintf('Double data eliminated from %s %s %s %s \n',INGCode,TimeMeasure,Test,nPass)
                end              

                if strcmp(StartDateTime,'0000-00-00 00:00:00') ~= 1
                    data.(TimeMeasure).(Test).Trial1.StartDateTime = StartDateTime;
                end

                % 2.12 Data for Gaitrite 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).InitialContact_Event = GaitID_Data(:,16); % dimension N
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Start = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).InitialContact_Event(1); %from the 1st IC to the last IC
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).End = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).InitialContact_Event(end);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Duration = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).End-data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Start;
                
                for iGaitID = 1:size(GaitID_Data(:,18),1)
                    LR = GaitID_Data(iGaitID,18);
                    if LR == 0
                        LeftRight{iGaitID,1} = 'Left'; 
                    else
                        LeftRight{iGaitID,1} = 'Right'; 
                    end                    
                end
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).InitialContact_LeftRight = LeftRight; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).FinalContact_Event = GaitID_Data(:,17);
                
                startMAT = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).InitialContact_Event(1);
                endMAT = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).FinalContact_Event(end);
                [~,istartMAT] = min(abs(t-startMAT));
                [~,iendMAT] = min(abs(t-endMAT));
                Flag(istartMAT:iendMAT) = 1;
                
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).FinalContact_Event = GaitID_Data(1:end-2,17); 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).FinalContact_LeftRight = LeftRight(1:end-2); 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Duration = GaitID_Data(2:end,10)/1000; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Swing_Duration = GaitID_Data(3:end,14)/1000; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stance_Duration = GaitID_Data(1:end-2,15)/1000; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).SingleSupport_Duration = GaitID_Data(1:end-2,12)/1000; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).DoubleSupport_Duration = GaitID_Data(1:end-2,11)/1000; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Length = GaitID_Data(2:end,9); 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Speed = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Length./data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Duration; 
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Length = sum(data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Length,'omitnan');
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Length = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Length(1:end-1)+data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Length(2:end);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Duration = data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Duration(1:end-1)+data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Step_Duration(2:end);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Speed= data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Length./data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Duration;
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).NumberStrides = length(data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Length);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).StrideFrequency = nanmean(60./data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Duration);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Cadence = (data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).StrideFrequency)*2;
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).WalkingSpeed = nanmean(data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Speed);
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).AverageStrideLength = nanmean(data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass).Stride_Length);

                clearvars LeftRight

            end %iWB   
            
            % Annotations Flag field
            data.(TimeMeasure).(Test).Trial1.Standards.Annotations.Walkway.Flag = Flag;
            
            % Duration controls (IMU + Walkway)
            SU_dur = length(data.(TimeMeasure).(Test).Trial1.SU.LowerBack.Acc)/data.(TimeMeasure).(Test).Trial1.SU.LowerBack.Fs.Acc;
            Pass_Ends = [data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass.End];
            iPass = size(Pass_Ends,2);
            while SU_dur<Pass_Ends(iPass)
                data.(TimeMeasure).(Test).Trial1.Standards.Walkway.Pass(iPass) = [];
                fprintf(2,'Pass %d of %s %s deleted \n',iPass,Test,TimeMeasure)
                iPass = iPass-1;
            end

            %% [3] Loading data.mat in "Standardized" --> "Data" --> "IDsubject" ---> "Laboratory"
            cd(DirectoryProject_Subject_Lab) 
            if exist('data','var') == 1
                save('data','data');
                fprintf('%s %s saved in data.mat \n',TimeMeasure,Test)
            else
                fprintf('No data for %s \n',INGCode)
                if exist(fullfile(CurrDir,'data.mat'),'file') == 0
                    cd(DirectoryPath_Standardized)
                    rmdir(INGCode,'s')
                end
            end
            cd(DirectoryPath_Group)
            clear data 
            close all
            
        end %iSubject
    end %iGroup
end %iTest

cd(MatlabCodeFolder)