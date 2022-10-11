Run main_python.py to open Matlab structure related to the shared datasets. 
Remember to check if paths written in the code are consistent with your local path (otherwise update them).

If YAR dataset is selected (lines 24-28, 213-214), three figures are plotted:
1) Acceleration [g] and angular velocity [deg/s] related to TUG test performed in Laboratory, with annotations on start [s], end [s], 
stride frequency [strides/min], cadence [steps/min], duration [s], length [m], walking speed [m/s], avarage stride length [m], 
number of strides, initial/final contact events.
2) Acceleration [g] and angular velocity [deg/s] related to Straight Walking, with annotations on start [s], end [s], 
stride frequency [strides/min], cadence [steps/min], duration [s], length [m], walking speed [m/s], avarage stride length [m], 
number of strides, initial/final contact events.
3) Acceleration [g] and angular velocity [deg/s] related to Free Living, with annotations on 
stride frequency [strides/min], cadence [steps/min], walking speed [m/s], avarage stride length [m], number of strides.

Python requirements:
- numpy
- h5py
- scipy


