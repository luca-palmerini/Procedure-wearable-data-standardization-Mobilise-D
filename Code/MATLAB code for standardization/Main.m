clear all
close all
clc

MatlabCodeFolder=pwd;

% [1] Standardization_data_mat_1 extracts data from OPAL files and GaitRite outputs to create a standardized data.mat
Standardization_data_mat_1

% [2] Standardization_data_mat_2 merges data.mat with IMU/Walkway and data.mat with LowerShank standard outputs
Standardization_data_mat_2

% [3] Standardization_data_mat_3 changes StartDateTime format
Standardization_data_mat_3

% [4] Standardization_infoForAlgo_mat creates infoForAlgo.mat from Clinical Data 
Standardization_infoForAlgo_mat

