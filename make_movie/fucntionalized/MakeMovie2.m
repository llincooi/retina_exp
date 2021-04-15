clear all;
G_HMM = [4.5];
G_OU =[4.5];%list of Gamma value
cutOffFreq_list = [0.5 1 2 4 8 0];
calibration_date = '20200219';
HMM_time =5;%Time length of HMM of movie
OU_time = 5;%Time length of OU of movie
makemovie_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_exp\make_movie\fucntionalized'; %this approach sucks.
date = '1006';
seed_date = '0421';
mean_lumin =6.5;
movie_folder = '\\192.168.0.100\Experiment\Retina\2020Videos\0609v\videos\';
cd(movie_folder)
mkdir HMM
mkdir OU
videoworkspace_folder = '\\192.168.0.100\Experiment\Retina\2020Videos\0609v\videoworkspace\';
cd(makemovie_folder);

plot(rntest(1:1000))

% G_HMM = [4.3];
% G_OU = [4.3];
% movie_folder = 'Z:\';
% videoworkspace_folder = 'Z:\';
% HMM_time = 5;%Time length of HMM of movie
% OU_time = 1;%Time length of OU of movie
%% Bar cSTA
% makeOLED_Bar_video2(makemovie_folder, 0, 'RL', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5]',mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,1,1);
% 
% makeOLED_Bar_video2(makemovie_folder, 0, 'RL', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5]',mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', movie_folder, videoworkspace_folder,'cSTA', seed_date,date,calibration_date,5,[2.5],mean_lumin,-1,1);

%% Smooth OU Bright
makeOLED_Bar_video2(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);

%% Smooth OU Dark
makeOLED_Bar_video2(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);

%% Smooth OU Bright bar added Spatial Noise 
%contrast set to be 100%, cutoff frequence set to be 1
%makeOLED_Bar_video_sN(makemovie_folder, theta, direction, video_folder, videoworkspace_folder, type, seed_date, date, calibration_date, mins, G_list, mean_lumin, contrast, cutOffFreq, num_dot, SNrefresh)
makeOLED_Bar_video_sN(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,15,1);
% makeOLED_Bar_video_sN(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,15,0);
makeOLED_Bar_video_sN(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,5,0);
% makeOLED_Bar_video_sN(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,5,1);

makeOLED_Bar_video_sN(makemovie_folder,  pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,15,1);
% makeOLED_Bar_video_sN(makemovie_folder,  pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,15,0);
makeOLED_Bar_video_sN(makemovie_folder,  pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,5,0);
% makeOLED_Bar_video_sN(makemovie_folder,  pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,5,1);

makeOLED_Bar_video_sN(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,15,1);
% makeOLED_Bar_video_sN(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,15,0);
makeOLED_Bar_video_sN(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,5,0);
% makeOLED_Bar_video_sN(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,5,1);

% makeOLED_Bar_video_sN(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,15,0);
makeOLED_Bar_video_sN(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,15,1);
% makeOLED_Bar_video_sN(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,5,1);
makeOLED_Bar_video_sN(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,5,0);

%% OU Bright part
% makeOLED_Bar_video2(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);
% makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1);

%% OU Dark part
% makeOLED_Bar_video2(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);
% makeOLED_Bar_video2(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OU', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1);

%% Smooth OU Bright Part part
% makeOLED_Bar_video_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,1,1,'right')

%% Smooth OU Dark Part part
% makeOLED_Bar_video_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'left');
% makeOLED_Bar_video_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'right')
% makeOLED_Bar_video_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,-1,1,'right')

%% OLD Smooth OU Bright Part part (background = 0; bar = mean_lumin )
%makeOLED_Bar_video_fc_part(makemovie_folder, theta, direction, video_folder, videoworkspace_folder, type, seed_date, date, calibration_date, mins,  Gvalue, mean_lumin, contrast, cutOffFreq_list, part)
makeOLED_Bar_video_fc_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'left');
makeOLED_Bar_video_fc_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'left');
makeOLED_Bar_video_fc_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'left');
makeOLED_Bar_video_fc_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'left');
makeOLED_Bar_video_fc_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'right')
makeOLED_Bar_video_fc_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'right')
makeOLED_Bar_video_fc_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'right')
makeOLED_Bar_video_fc_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'right')
makeOLED_Bar_video_fc_part(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'mid')
makeOLED_Bar_video_fc_part(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'mid')
makeOLED_Bar_video_fc_part(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'mid')
makeOLED_Bar_video_fc_part(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,1,'mid')

%% Grating
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0618',calibration_date, 6.5, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0618',calibration_date, 0, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0618',calibration_date, 0, 6.5)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0617',calibration_date, 6.5, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0617',calibration_date, 0, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0617',calibration_date, 0, 6.5)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0619',calibration_date, 6.5, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0619',calibration_date, 0, 13)
makeGrating_shuffledvideo(makemovie_folder,movie_folder, videoworkspace_folder, '0619',calibration_date, 0, 6.5)

%% OnOff
Oled_Drinnenberg_OnOff_movie(makemovie_folder,movie_folder,date,calibration_date,6.5)

%% OLD Smooth OU Bright Fc
%makeOLED_Bar_video_fc(makemovie_folder, theta, direction, video_folder, videoworkspace_folder, type, seed_date, date, calibration_date, mins, Gvalue, mean_lumin, contrast, cutOffFreq_list)
for G_OU = [2.5 4.3 4.5 7.5 20]
    makeOLED_Bar_video_fc(makemovie_folder, 0, 'RL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,cutOffFreq_list);
    makeOLED_Bar_video_fc(makemovie_folder, pi/2, 'UD', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,cutOffFreq_list);
    makeOLED_Bar_video_fc(makemovie_folder, pi/4, 'UL_DR', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,cutOffFreq_list);
    makeOLED_Bar_video_fc(makemovie_folder, 3*pi/4, 'UR_DL', [movie_folder,'OU'], videoworkspace_folder,'OUsmooth', seed_date,date,calibration_date,OU_time,G_OU,mean_lumin,j,cutOffFreq_list);
end