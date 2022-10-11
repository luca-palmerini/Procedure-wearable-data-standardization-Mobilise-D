DATA
Data provided are related to two tests 
- SC (Test1) : Single Continuous walks performed at normal pace over a circular 25m path 
- SI (Test2) : Single intermittent walks performed at normal pace in straight line
and two time measurements
- F3 (TimeMeasure2) : measurements performed 36 months after baseline assessment
- F4 (TimeMeasure3) : measurements performed 54 months after baseline assessment


CONTENTS
The folder 'MATLAB code' contains: 

- The folder 'Original' which contains folders with the existing (not standardized) IMU raw data. Each folder name refers to specific TimeMeasurement (F3,F4), Test (SC,SI) and Group (Control).
Furthermore, two Excel files are provided: 'Clinical Data.xlsx' with the Clinical info of the subject (Age, Height, Weight, WalkingAid etc. for each time measurament) and
'GaitRite_Complete.xlsx' with the GaitRite outputs such as step velocity, step length, step time etc. 

- The folder 'Processed Data from IMUs reference system' contains a data.mat with the standards outputs calculated using an algorithm processing data from two IMUs on the left and right lower parts of the shank (Ref. 27-28 in the paper). For this subject the standard outputs are provided only for Test1 in TimeMeasure2.

- Main.m to standardize the raw data using the following Matlab code:
1) Standardization_data_mat_1.m to standardize the IMU and GAITRite raw data
2) Standardization_data_mat_2.m to merge the data.mat obtained in the previous step (2) and the data.mat with Lower Shanks standard outputs (contained in the folder 'Processed Data from IMUs reference system')
3) Standardization_data_mat_3.m to update the StartDateTime field in the data.mat obtained in the previous step (3) to save it using the Unix format.
4) Standardization_infoForAlgo_mat.m to create the infoForAlgo.mat from the Clinical info of the subject.
5) StandardOutput_Walkway_Pass.mat is a Matlab structure which lists the possible standard outputs related to the GAITRite.


STANDARDIZATION
To standardize the raw data of the ICICLE dataset copy the subfolders contained in the ..\Data\ICICLE\Raw data to the 'Matlab code for standardization' folder and run the Main.m.
The standardized data.mat and infoForAlgo.mat will be saved in a new directory '.\Matlab code\Standardized\Data\0001\Laboratory'.