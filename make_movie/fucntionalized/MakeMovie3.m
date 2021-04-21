clear all;
%% Things barely change
WherenWhen =struct();
% WherenWhen.makemovie_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
WherenWhen.makemovie_folder = 'C:\Users\llinc\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
WherenWhen.date = datestr(datetime('now'), 'mmdd');
WherenWhen.video_folder = 'C:\Users\llinc\GitHub\retina_personal\Movie_temp\videos\';
cd(WherenWhen.video_folder)
mkdir HMM
mkdir OU
WherenWhen.videoworkspace_folder = 'C:\Users\llinc\GitHub\retina_personal\Movie_temp\videoworkspace\';
WherenWhen.calibration_date = '20200219';
cd(WherenWhen.makemovie_folder);
sti_time = 5;

G_HMM = [4.5];
G_OU =[4.5];
%%
theta = pi/4;
lumin = [6.5 0];
load('C:\Users\llinc\GitHub\retina_personal\Movie_temp\grating_matrix\grating_3to1_OUsmooth_1_Hz.mat')
makeOLED_video_from_matrix(WherenWhen, theta, lumin, sti_matrix, matrix_properties)
      