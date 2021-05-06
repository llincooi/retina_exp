clear all;
%% Things barely change
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
sti_time = 5;

G_HMM = [4.5];
G_OU =[4.5];
%%
% lumin = [6.5 0];
% load('C:\retina_makemovie\GratingMatrix\grating_3to1_OUsmooth_1_Hz.mat')
% for theta = pi/3
%     makeOLED_video_from_matrix(WherenWhen, theta, lumin, sti_matrix, matrix_properties, newXarray)
% end
%%
lumin = [6.5 0];
for sigma = [6.8, 20, 40, 60]
    for Fc = [1 4]
        load(['C:\retina_makemovie\GPMatrix\GP_s=', num2str(sigma),'_OUsmooth_', num2str(Fc),'Hz.mat'])
        for theta = [0,pi/2,pi/4, pi*3/4]
            makeOLED_video_from_matrix(WherenWhen, theta, lumin, sti_matrix, matrix_properties, newXarray)
        end
    end
end