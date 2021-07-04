clear all;
%% Things barely change
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\oled_boundary_set.mat']);
WherenWhen =struct();
% WherenWhen.makemovie_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
WherenWhen.makemovie_folder = 'C:\Users\llinc\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
WherenWhen.makemovie_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
WherenWhen.date = datestr(datetime('now'), 'mmdd');
WherenWhen.video_folder = '\\192.168.0.100\Public\2021videos\';
cd(WherenWhen.video_folder)
mkdir HMM
mkdir OU
WherenWhen.videoworkspace_folder = '\\192.168.0.100\Public\2021videos\newvideoworkspace\';
WherenWhen.calibration_date = '20200219';
cd(WherenWhen.makemovie_folder);

WherenWhen.productfolder = 'C:\retina_makemovie\';
%%
series = struct();
series.type = 'LPOU';
series.Fc = 1;
series.G = 4.5;
series.seeddate = '0421'; %where to import random seed ('mmdd')
series.length = 5; %(min)

sti_matrix = struct();
sti_matrix.type = 'SW' %'SW':square wave; 'GP': Gaussian pulse; 'Grating'
sti_matrix.width = 8; %half width of 'SW' and 'Grating'; sigma for 'GP'. Addtional term for dark spation period of 'Grating'
sti_matrix.length = 'short'; %'long': 1-D matrix repeated to 2-D; short: 2-D matrix
sti_matrix.dynamical_range = [leftx_bar, rightx_bar];

for minlum = [0.04, 0.025]
    lumin = [6.5 minlum];
    for series.Fc = [1 4]
        for theta = [0,pi/2,pi/4, pi*3/4]
            makeOLED_video_rot(WherenWhen, theta, lumin, sti_matrix, series)
        end
    end
end


