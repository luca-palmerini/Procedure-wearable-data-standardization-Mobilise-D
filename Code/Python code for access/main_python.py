# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
#%load_ext autoreload
#%autoreload 2

from pathlib import Path
import os
import numpy as np
from matplotlib import pyplot as plt

# Add path to utils folder
project_path = Path(os.getcwd())
os.chdir('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Code/utils')
import matlab_loader as matlab_loader

###############################################################################
############################### LABORATORY ####################################
###############################################################################
# Load data.mat
folder_path = Path('C:/Users/Utente/Documents/Example Subjects Mobilise-D/data/YAR/0001/Laboratory') # YAR 
# folder_path = Path('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/UNISS-UNIGE/S023/Laboratory') # UNISS UNIGE
# folder_path = Path('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data\MS Project/MS001/Laboratory') # MS PROJECT
# folder_path = Path('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/ICICLE/0001/Laboratory') # ICICLE
# folder_path = Path('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Laboratory') # Gait in Lab and real-life settings
file_path = folder_path / "data.mat"
data_Lab = matlab_loader.load_matlab(file_path , "data")

# Load infoForAlgo.mat
file_path = folder_path / "infoForAlgo.mat"
data_Lab_info = matlab_loader.load_matlab(file_path , "infoForAlgo")

# Plot TUG & Walking Test (if YAR dataset is selected)
if folder_path.parts[6]=='YAR':
    ###########################################################################
    # 1) Plot TUG Test (Test 4, Trial 1)
    
    # List Stereophoto Reference Data 
    data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod'].keys()
    
    # Save IMU variable to plot
    fs_SU=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Fs']['Acc']
    aV=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Acc'][:,0]
    aML=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Acc'][:,1]
    aAP=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Acc'][:,2]
    gV=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Gyr'][:,0]
    gML=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Gyr'][:,1]
    gAP=data_Lab['TimeMeasure1']['Test4']['Trial1']['SU']['LowerBack']['Gyr'][:,2]
    t=np.arange(0,(np.shape(aV)[0])/fs_SU,1/fs_SU)
    
    # Save Reference Data to plot
    start_tug=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Start']
    end_tug=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['End']
    stride_frequency=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['StrideFrequency']
    cadence=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Cadence']
    duration=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Duration']
    length_v=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Length']
    WalkingSpeed=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['WalkingSpeed']
    AverageStrideLength=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['AverageStrideLength']
    NumberStrides=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['NumberStrides']
    initial_contacts=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['InitialContact_Event']
    final_contacts=data_Lab['TimeMeasure1']['Test4']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['FinalContact_Event']
    
    # Plot
    fig, axs = plt.subplots(2, 1, figsize=(18,9))
    axs[0].plot(t, aV,'g-',label='V')
    axs[0].plot(t, aML,'r-',label='ML')
    axs[0].plot(t, aAP,'b-',label='AP')
    axs[0].set_xlabel('Time [s]')
    axs[0].set_ylabel('Acceleration [g]')
    axs[0].set_title('LABORATORY\n'+'Time Up and Go Test\n' +
          "Age:" + str(int(data_Lab_info['TimeMeasure1']['Age']))+
          ", Height:" + str(int(data_Lab_info['TimeMeasure1']['Height']))+
          ", Weight:" + str(int(data_Lab_info['TimeMeasure1']['Weight']))+
          ", Gender:" + str(data_Lab_info['TimeMeasure1']['Gender']),
          fontweight ="bold",fontsize = 16)
    axs[1].plot(t, gV,'g-',label='V')
    axs[1].plot(t, gML,'r-',label='ML')
    axs[1].plot(t, gAP,'b-',label='AP')
    axs[1].set_xlabel('Time [s]')
    axs[1].set_ylabel('Angular velocity [deg/s]')
    min_A=min([min(aV),min(aML),min(aAP)])
    max_A=max([max(aV),max(aML),max(aAP)])
    axs[0].set_xlim(0, max(t))
    axs[0].set_ylim(min_A-0.1, max_A+0.7)
    min_G=min([min(gV),min(gML),min(gAP)])
    max_G=max([max(gV),max(gML),max(gAP)])
    axs[1].set_xlim(0, max(t))
    axs[1].set_ylim(min_G-10, max_G+10)
    count=0
    for tmp_initial in initial_contacts:
        count=count+1
        if count==1:
            axs[0].plot(tmp_initial, aV[int(np.round_(tmp_initial*fs_SU))], 'gv',label='IC')  
        else:
            axs[0].plot(tmp_initial, aV[int(np.round_(tmp_initial*fs_SU))], 'gv')   
    count=0
    for tmp_final in final_contacts:
       count=count+1
       if count==1:
           axs[0].plot(tmp_final, aV[int(np.round_(tmp_final*fs_SU))], 'r^',label='FC')  
       else: 
           axs[0].plot(tmp_final, aV[int(np.round_(tmp_final*fs_SU))], 'r^') 
    legend = axs[0].legend(loc='upper right')
    legend = axs[1].legend(loc='upper right')
    stats = (f'Start = {start_tug:.2f} [s]    '
         f'End = {end_tug:.2f} [s]    '
         f'StrideFrequency = {stride_frequency:.2f} [strides/min]    '
         f'Cadence = {cadence:.2f} [steps/min]    '
         f'Duration = {duration:.2f} [s]\n    '
         f'Length = {length_v:.2f} [m]    '
         f'WalkingSpeed = {WalkingSpeed:.2f} [m/s]    '
         f'AverageStrideLength = {AverageStrideLength:.2f} [m]   '
         f'NumberStrides = {NumberStrides:.0f}\n' 
          )
    bbox = dict(boxstyle='round', fc='blanchedalmond', ec='orange', alpha=0.5)
    axs[0].text(0.30, 0.83, stats, fontsize=9, bbox=bbox,
            transform=axs[0].transAxes, horizontalalignment='left')
    fig.tight_layout()
    plt.show()
    
    ###############################################################################
    # 2) Plot Straight Walking Test SU Data - SLOW (Test 6, Trial 1)
    
    # Save IMU variable to plot
    fs_SU=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Fs']['Acc']
    aV=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Acc'][:,0]
    aML=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Acc'][:,1]
    aAP=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Acc'][:,2]
    gV=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Gyr'][:,0]
    gML=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Gyr'][:,1]
    gAP=data_Lab['TimeMeasure1']['Test6']['Trial1']['SU']['LowerBack']['Gyr'][:,2]
    t=np.arange(0,(np.shape(aV)[0])/fs_SU,1/fs_SU)
    
    # Save Reference Data to plot
    start_wp=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Start']
    end_wp=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['End']
    stride_frequency=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['StrideFrequency']
    cadence=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Cadence']
    duration=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Duration']
    length=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['Length']
    WalkingSpeed=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['WalkingSpeed']
    AverageStrideLength=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['AverageStrideLength']
    NumberStrides=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['NumberStrides']
    
    # Plot
    fig, axs = plt.subplots(2, 1, figsize=(18,9))
    axs[0].plot(t, aV,'g-',label='V')
    axs[0].plot(t, aML,'r-',label='ML')
    axs[0].plot(t, aAP,'b-',label='AP')
    axs[0].set_xlabel('Time [s]')
    axs[0].set_ylabel('Acceleration [g]')
    axs[0].set_title('LABORATORY\n'+'Straight Walking Test (slow)\n' +
          "Age:" + str(int(data_Lab_info['TimeMeasure1']['Age']))+
          ", Height:" + str(int(data_Lab_info['TimeMeasure1']['Height']))+
          ", Weight:" + str(int(data_Lab_info['TimeMeasure1']['Weight']))+
          ", Gender:" + str(data_Lab_info['TimeMeasure1']['Gender']),
          fontweight ="bold",fontsize = 16)
    axs[1].plot(t, gV,'g-',label='V')
    axs[1].plot(t, gML,'r-',label='ML')
    axs[1].plot(t, gAP,'b-',label='AP')
    axs[1].set_xlabel('Time [s]')
    axs[1].set_ylabel('Angular velocity [deg/s]')
    min_A=min([min(aV),min(aML),min(aAP)])
    max_A=max([max(aV),max(aML),max(aAP)])
    axs[0].set_xlim(0, max(t))
    axs[0].set_ylim(min_A-0.1, max_A+0.6)
    min_G=min([min(gV),min(gML),min(gAP)])
    max_G=max([max(gV),max(gML),max(gAP)])
    axs[1].set_xlim(0, max(t))
    axs[1].set_ylim(min_G-10, max_G+10)
    initial_contacts=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['InitialContact_Event']
    final_contacts=data_Lab['TimeMeasure1']['Test6']['Trial1']['Standards']['Stereophoto']['ContinuousWalkingPeriod']['FinalContact_Event']
    count=0
    for tmp_initial in initial_contacts:
       count=count+1
       if count==1:
           axs[0].plot(tmp_initial, aV[int(np.round_(tmp_initial*fs_SU))], 'gv',label='IC')  
       else:
           axs[0].plot(tmp_initial, aV[int(np.round_(tmp_initial*fs_SU))], 'gv') 
    count=0
    for tmp_final in final_contacts:
       count=count+1
       if count==1:
           axs[0].plot(tmp_final, aV[int(np.round_(tmp_final*fs_SU))], 'r^',label='FC')  
       else: 
           axs[0].plot(tmp_final, aV[int(np.round_(tmp_final*fs_SU))], 'r^') 
    legend = axs[0].legend(loc='upper right')
    legend = axs[1].legend(loc='upper right')
    stats = (f'Start = {start_tug:.2f} [s]    '
         f'End = {end_tug:.2f} [s]    '
         f'StrideFrequency = {stride_frequency:.2f} [strides/min]    '
         f'Cadence = {cadence:.2f} [steps/min]    '
         f'Duration = {duration:.2f} [s]\n    '
         f'Length = {length_v:.2f} [m]    '
         f'WalkingSpeed = {WalkingSpeed:.2f} [m/s]    '
         f'AverageStrideLength = {AverageStrideLength:.2f} [m]   '
         f'NumberStrides = {NumberStrides:.0f}\n'    
          )
    bbox = dict(boxstyle='round', fc='blanchedalmond', ec='orange', alpha=0.5)
    axs[0].text(0.25, 0.83, stats, fontsize=9, bbox=bbox,
            transform=axs[0].transAxes, horizontalalignment='left')
    fig.tight_layout()
    plt.show()
    
###############################################################################
############################### FREE LIVING ###################################
###############################################################################
# Load data.mat
folder_path = Path('C:/Users/Utente/Documents/Example Subjects Mobilise-D/data/YAR/0001/Free-living')  # YAR
# folder_path = Path('C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Free-living') # Gait in Lab and real-life settings
file_path = folder_path / "data.mat"
data_FreeLiving = matlab_loader.load_matlab(file_path , "data")

# Load infoForAlgo.mat
file_path = folder_path / "infoForAlgo.mat"
data_FreeLiving_info = matlab_loader.load_matlab(file_path , "infoForAlgo")
    
# Plot Free Living recording (if YAR dataset is selected)
if folder_path.parts[6]=='YAR':
    # Save IMU variable to plot
    fs_SU=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Fs']['Acc']
    aV=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Acc'][:,0]
    aML=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Acc'][:,1]
    aAP=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Acc'][:,2]
    gV=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Gyr'][:,0]
    gML=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Gyr'][:,1]
    gAP=data_FreeLiving['TimeMeasure1']['Recording4']['SU']['LowerBack']['Gyr'][:,2]
    t=np.arange(0,(np.shape(aV)[0])/fs_SU,1/fs_SU)
    
    # Save Reference Data to plot
    list_tot=data_FreeLiving['TimeMeasure1']['Recording4']['Standards']['INDIP']['ContinuousWalkingPeriod']
    res = np.empty(shape=1)
    for entry in list_tot:
        res = np.append(res, entry['StrideFrequency'])
    res_strideFrequency=res[1:len(res)];
    res = np.empty(shape=1)
    for entry in list_tot:
        res = np.append(res, entry['Cadence'])
    res_cadence=res[1:len(res)];
    res = np.empty(shape=1)
    for entry in list_tot:
        res = np.append(res, entry['WalkingSpeed'])
    res_walkingSpeed=res[1:len(res)];
    res = np.empty(shape=1)
    for entry in list_tot:
        res = np.append(res, entry['AverageStrideLength'])
    res_averageStrideLen=res[1:len(res)];
    res = np.empty(shape=1)
    for entry in list_tot:
        res = np.append(res, entry['NumberStrides'])
    res_numberStrides=res[1:len(res)];
    t=np.arange(0,(np.shape(aV)[0])/fs_SU,1/fs_SU)
    
    # Plot
    fig, axs = plt.subplots(2, 1, figsize=(18,9))
    axs[0].plot(t, aV,'g-',label='V')
    axs[0].plot(t, aML,'r-',label='ML')
    axs[0].plot(t, aAP,'b-',label='AP')
    axs[0].set_xlabel('Time [s]')
    axs[0].set_ylabel('Acceleration [g]')
    axs[0].set_title('FREE LIVING\n' +
          "Age:" + str(int(data_Lab_info['TimeMeasure1']['Age']))+
          ", Height:" + str(int(data_Lab_info['TimeMeasure1']['Height']))+
          ", Weight:" + str(int(data_Lab_info['TimeMeasure1']['Weight']))+
          ", Gender:" + str(data_Lab_info['TimeMeasure1']['Gender']),
          fontweight ="bold",fontsize = 16)
    axs[1].plot(t, gV,'g-',label='V')
    axs[1].plot(t, gML,'r-',label='ML')
    axs[1].plot(t, gAP,'b-',label='AP')
    axs[1].set_xlabel('Time [s]')
    axs[1].set_ylabel('Angular velocity [deg/s]')
    min_A=min([min(aV),min(aML),min(aAP)])
    max_A=max([max(aV),max(aML),max(aAP)])
    axs[0].set_xlim(0, max(t))
    axs[0].set_ylim(min_A-0.1, max_A+0.6)
    min_G=min([min(gV),min(gML),min(gAP)])
    max_G=max([max(gV),max(gML),max(gAP)])
    axs[1].set_xlim(0, max(t))
    axs[1].set_ylim(min_G-10, max_G+10)
    legend = axs[0].legend(loc='upper right')
    legend = axs[1].legend(loc='upper right')
    stats = (f'StrideFrequency = {np.mean(res_strideFrequency):.2f} [strides/min]    '
          f'Cadence = {np.mean(res_cadence):.2f} [steps/min]    '
          f'WalkingSpeed = {np.mean(res_walkingSpeed):.2f} [m/s]    '
          f'AverageStrideLength = {np.mean(res_averageStrideLen):.2f} [m]    '
          f'NumberStrides = {np.sum(res_numberStrides):.0f}')
    bbox = dict(boxstyle='round', fc='blanchedalmond', ec='orange', alpha=0.5)
    axs[0].text(0.20, 0.94, stats, fontsize=9, bbox=bbox,
            transform=axs[0].transAxes, horizontalalignment='left')
    fig.tight_layout()
    plt.show()












