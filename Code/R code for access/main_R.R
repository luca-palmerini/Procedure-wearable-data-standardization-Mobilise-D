rm(list=ls(all=TRUE))

## Library 
library(reticulate)
library(stringr)

# Create virtualenv
reticulate::virtualenv_create('mobilised-env')
reticulate::virtualenv_install('mobilised-env', c('numpy', 'h5py', 'scipy' ))
reticulate::use_virtualenv('mobilised-env')

# Load module
lib_utils <- 'C:/Users/Utente/Documents/Example Subjects Mobilise-D/utils'
mobilised_matlab_loader <- reticulate::import_from_path('matlab_loader', lib_utils)


# Load data.mat 
file_path_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/YAR/0001/Laboratory/data.mat'  #YAR
#file_path_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/UNISS-UNIGE/S023/Laboratory/data.mat'  # UNISS UNIGE
#file_path_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data\MS Project/MS001/Laboratory/data.mat' # MS PROJECT
#file_path_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/ICICLE/0001/Laboratory/data.mat' # ICICLE
#file_path_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Laboratory/data.mat' # Gait in Lab and real-life settings 
system.time(data_Laboratory <- mobilised_matlab_loader$load_matlab(file_path_Laboratory , "data"))

# Load infoForAlgo.mat 
file_path_Info_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/YAR/0001/Laboratory/infoForAlgo.mat'
#file_path_Info_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/UNISS-UNIGE/S023/Laboratory/infoForAlgo.mat'  # UNISS UNIGE
#file_path_Info_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data\MS Project/MS001/Laboratory/infoForAlgo.mat' # MS PROJECT
#file_path_Info_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/ICICLE/0001/Laboratory/infoForAlgo.mat' # ICICLE
#file_path_Info_Laboratory <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Laboratory/infoForAlgo.mat' # Gait in Lab and real-life settings 
system.time(info_Laboratory <- mobilised_matlab_loader$load_matlab(file_path_Info_Laboratory , "infoForAlgo"))

## Load YAR / FREE LIVING
file_path_FreeLiving <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/YAR/0001/Free-living/data.mat'
# file_path_FreeLiving <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Free-living/data.mat' # Gait in Lab and real-life settings
system.time(data_FreeLiving <- mobilised_matlab_loader$load_matlab(file_path_FreeLiving , "data"))

file_path_Info_FreeLiving <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/YAR/0001/Free-living/infoForAlgo.mat'
# file_path_Info_FreeLiving <- 'C:/Users/Utente/Downloads/Example Subjects Mobilise-D/Data/Gait in Lab and real-life settings/S01/Free-living/infoForAlgo.mat' # Gait in Lab and real-life settings

system.time(info_FreeLiving <- mobilised_matlab_loader$load_matlab(file_path_Info_FreeLiving , "infoForAlgo"))


if (str_detect(file_path_Laboratory, "YAR")==TRUE){
  
  ###################################################### LABORATORY - Time Up end Go ######################################################################
  # 1) Plot TUG Test (Test 4, Trial 1)
  
  # Save IMU variable to plot
  fs_SU=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['SU']][['LowerBack']][['Fs']][['Acc']];
  a_tot=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['SU']][['LowerBack']][['Acc']];
  g_tot=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['SU']][['LowerBack']][['Gyr']];
  t=seq(from = 0,to = (dim(a_tot)[1]-1)/fs_SU, by = 1/fs_SU);
  
  # Save Reference Data to plot
  start_tug=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Start']];
  end_tug=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['End']];
  initial_contacts=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['InitialContact_Event']];
  final_contacts=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['FinalContact_Event']];
  stride_frequency=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['StrideFrequency']];
  cadence=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Cadence']];
  duration=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Duration']];
  length_v=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Length']];
  WalkingSpeed=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['WalkingSpeed']];
  AverageStrideLength=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['AverageStrideLength']];
  NumberStrides=data_Laboratory[['TimeMeasure1']][['Test4']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['NumberStrides']];
  
  #Plot
  dev.new(width=400,height=200)
  plot.new()  
  par(mfrow=c(2,1))
  plot_title=paste("LABORATORY\n Time Up and Go\nAge:", info_Laboratory[['TimeMeasure1']][['Age']], ", Height: ", info_Laboratory[['TimeMeasure1']][['Height']], "cm, Weight: ", info_Laboratory[['TimeMeasure1']][['Weight']], "kg, Gender: ", info_Laboratory[['TimeMeasure1']][['Gender']] )
  matplot(t,(a_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Acceleration [m/s]",xlab="Time [s]",xlim=(c(0, dim(a_tot)[1]/fs_SU)),ylim=(c(min(a_tot),max(a_tot)+0.8)),main=plot_title)
  for (tmp_initial in initial_contacts){
    lines(tmp_initial, a_tot[(tmp_initial*fs_SU),1], 'o',pch = 25, col="green", bg="green")
  }
  for (tmp_final in final_contacts){
    lines(tmp_final, a_tot[(tmp_final*fs_SU),1], 'o',pch = 24, col="red", bg="red")
  }
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)
  text(max(t)/4 , max(a_tot)+0.5 , cex=0.8 , adj=0, labels = paste("Start: ", round(start_tug, digits=2), "[s]     End: ", round(end_tug, digits=2), "[s]     StrideFrequency: ", round(stride_frequency, digits=2), "[strides/min]   Cadence,", round(cadence, digits=2), "[steps/min]   Duration:", round(duration, digits=2), "[s]\n   Length: ", round(length_v, digits=2), "[m]     WalkingSpeed:", round(WalkingSpeed, digits=2), "[m/s]   AvarageStrideLength", round(AverageStrideLength, digits=2), "[m]   NumberStrides:", round(NumberStrides, digits=2)))
  matplot(t,(g_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Angular velocity [deg/s]",xlab="Time [s]",xlim=c(0,dim(g_tot)[1]/fs_SU),ylim=c(min(g_tot),max(g_tot)))
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)
  
  ############################################### LABORATORY - Straight Walking Test (slow) ################################################################
  # 2) Plot Straight Walking Test SU Data - SLOW (Test 6, Trial 1)
  
  # Save IMU variable to plot
  fs_SU=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['SU']][['LowerBack']][['Fs']][['Acc']];
  a_tot=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['SU']][['LowerBack']][['Acc']];
  g_tot=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['SU']][['LowerBack']][['Gyr']];
  t=seq(from = 0,to = (dim(a_tot)[1]-1)/fs_SU, by = 1/fs_SU);
  
  # Save Reference Data to plot
  initial_contacts=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['InitialContact_Event']];
  final_contacts=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['FinalContact_Event']];
  stride_frequency=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['StrideFrequency']];
  cadence=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Cadence']];
  duration=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Duration']];
  length_v=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Length']];
  WalkingSpeed=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['WalkingSpeed']];
  AverageStrideLength=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['AverageStrideLength']];
  NumberStrides=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['NumberStrides']];
  
  # Plot
  dev.new(width=400,height=200)
  plot.new() 
  par(mfrow=c(2,1))
  plot_title=paste("LABORATORY\n Straight Walking Test (slow)\nAge:", info_Laboratory[['TimeMeasure1']][['Age']], ", Height: ", info_Laboratory[['TimeMeasure1']][['Height']], "cm, Weight: ", info_Laboratory[['TimeMeasure1']][['Weight']], "kg, Gender: ", info_Laboratory[['TimeMeasure1']][['Gender']] )
  matplot(t,(a_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Acceleration [m/s]",xlab="Time [s]",xlim=(c(0, dim(a_tot)[1]/fs_SU)),ylim=(c(min(a_tot),max(a_tot)+0.8)),main=plot_title)
  for (tmp_initial in initial_contacts){
    lines(tmp_initial, a_tot[(tmp_initial*fs_SU),1], 'o',pch = 25, col="green", bg="green")
  }
  for (tmp_final in final_contacts){
    lines(tmp_final, a_tot[(tmp_final*fs_SU),1], 'o',pch = 24, col="red", bg="red")
  }
  text(max(t)/4 , max(a_tot)+0.5 , cex=0.8 , adj=0, labels = paste("Start: ", round(start_tug, digits=2), "[s]     End: ", round(end_tug, digits=2), "[s]     StrideFrequency: ", round(stride_frequency, digits=2), "[strides/min]   Cadence,", round(cadence, digits=2), "[steps/min]   Duration:", round(duration, digits=2), "[s]\n   Length: ", round(length_v, digits=2), "[m]     WalkingSpeed:", round(WalkingSpeed, digits=2), "[m/s]   AvarageStrideLength", round(AverageStrideLength, digits=2), "[m]   NumberStrides:", round(NumberStrides, digits=2)))
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)
  matplot(t,(g_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Angular velocity [deg/s]",xlab="Time [s]",xlim=c(0,dim(g_tot)[1]/fs_SU),ylim=c(min(g_tot),max(g_tot)))
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)
  
  ##################################################### FREE LIVING ###############################################################
  
  # Save IMU variable to plot
  fs_SU=data_FreeLiving[['TimeMeasure1']][['Recording4']][['SU']][['LowerBack']][['Fs']][['Acc']];
  a_tot=data_FreeLiving[['TimeMeasure1']][['Recording4']][['SU']][['LowerBack']][['Acc']];
  g_tot=data_FreeLiving[['TimeMeasure1']][['Recording4']][['SU']][['LowerBack']][['Gyr']];
  t=seq(from = 0,to = (dim(a_tot)[1]-1)/fs_SU, by = 1/fs_SU);
  
  stride_frequency=data_FreeLiving[['TimeMeasure1']][['Recording4']][['SU']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][[1]]
  cadence=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Cadence']];
  duration=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Duration']];
  length_v=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['Length']];
  WalkingSpeed=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['WalkingSpeed']];
  AverageStrideLength=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['AverageStrideLength']];
  NumberStrides=data_Laboratory[['TimeMeasure1']][['Test6']][['Trial1']][['Standards']][['Stereophoto']][['ContinuousWalkingPeriod']][['NumberStrides']];
  
  # Save Reference Data to plot
  list_tot=data_FreeLiving[['TimeMeasure1']][['Recording4']][['Standards']][['INDIP']][['ContinuousWalkingPeriod']]
  res_strideFrequency = numeric(0)
  tmp_v=seq(from = 1, to = length(list_tot), by=1)
  for (entry in tmp_v){
    res_strideFrequency <- c(res_strideFrequency,  list_tot[[entry]][['StrideFrequency']])}
  res_cadence = numeric(0)
  for (entry in tmp_v){
    res_cadence <- c(res_cadence,  list_tot[[entry]][['Cadence']])}
  res_walkingSpeed = numeric(0)
  for (entry in tmp_v){
    res_walkingSpeed <- c(res_walkingSpeed,  list_tot[[entry]][['WalkingSpeed']])}
  res_averageStrideLen = numeric(0)
  for (entry in tmp_v){
    res_averageStrideLen <- c(res_averageStrideLen,  list_tot[[entry]][['AverageStrideLength']])}
  res_numberStrides = numeric(0)
  for (entry in tmp_v){
    res_numberStrides <- c(res_numberStrides,  list_tot[[entry]][['NumberStrides']])}
  
  # Plot
  dev.new(width=400,height=200)
  plot.new()
  par(mfrow=c(2,1))
  plot_title=paste("FREE LIVING\nAge:", info_Laboratory[['TimeMeasure1']][['Age']], ", Height: ", info_Laboratory[['TimeMeasure1']][['Height']], "cm, Weight: ", info_Laboratory[['TimeMeasure1']][['Weight']], "kg, Gender: ", info_Laboratory[['TimeMeasure1']][['Gender']] )
  matplot(t,(a_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Acceleration [m/s]",xlab="Time [s]",xlim=(c(0, dim(a_tot)[1]/fs_SU)),ylim=(c(min(a_tot),max(a_tot)+0.8)),main=plot_title)
  text(max(t)/5 , max(a_tot)+0.3 , cex=0.8 , adj=0, labels = paste("StrideFrequency: ", round(mean(res_strideFrequency), digits=2), "[strides/min],   Cadence,", round(mean(res_cadence), digits=2), "[steps/min],    WalkingSpeed:", round(mean(res_walkingSpeed), digits=2), "[m/s],   AvarageStrideLength", round(mean(res_averageStrideLen), digits=2), "[m],   NumberStrides:", round(sum(res_numberStrides))))
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)
  matplot(t,(g_tot), type = "l",col = c("green", "red", "blue"),lty = 1, lwd = 1, lend = 1, ylab="Angular velocity [deg/s]",xlab="Time [s]",xlim=c(0,dim(g_tot)[1]/fs_SU),ylim=c(min(g_tot),max(g_tot)))
  legend("topright",legend = c("V", "ML", "AP"),col = c("green", "red", "blue"),lty = 1,cex=0.6)

}

