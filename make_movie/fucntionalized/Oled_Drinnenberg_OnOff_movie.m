function Oled_Drinnenberg_OnOff_movie(makemovie_folder,video_folder,date,calibration_date,mean_brightness)
%% It is adopted from STAR-METHODS of Activity Correlations between Direction-Selective Retinal Ganglion Cells Synergistically Enhance Motion Decoding from Complex Visual Scenes
%{
It used flashes of 500 ms of increased or decreased light level at 40% from mean luminance alternately, interleaved by 1.5 s of mean luminance. 

To assess the degree of ON versus OFF responses, an ON-OFF index was
calculated from the spike countsfonandfoff, measured in a time window of 50
to 550 ms after the onset of the ON- and OFF-flash, respectively, such that
the Flashes ON-OFF Index is (f_on-f_off)/(f_on+f_off)
%}
%average_brightness is mean luminance of OnOFF
%% Load boundary_set.mat and calibration.mat
load(['C:\calibration\',calibration_date,'oled_calibration\calibration.mat'])
load(['C:\calibration\',calibration_date,'oled_calibration\oled_boundary_set.mat']);
%% Parameter
rest_brightness = interp1(real_lum,lum,mean_brightness,'linear');
brightness_series = [0.65, 0.375, 0.75, 0.25, 0.875, 0.125, 1, 0];
OLED_brightness_series = interp1(real_lum,lum,mean_brightness*2*brightness_series,'linear');
sti_time = 2; %s
rest_time = 5; %s
flicker_on_brightness =0.9116;
flicker_off_brightness = 0.6006;
flicker_rest_brightness = 0.8;
num_cycle = 10;
fps =60;  %freq of the screen flipping
Xarray = [];
for b = OLED_brightness_series
    Xarray = [Xarray b*ones(1, sti_time*fps)];
end
flicker_trial = repmat([ones(1, sti_time/2*fps), zeros(1, sti_time/2*fps)], 1, length(OLED_brightness_series));
%rest
Xarray = [Xarray rest_brightness*ones(1, rest_time*fps)];
flicker_trial = [flicker_trial, ones(1, sti_time/2*fps), zeros(1, (rest_time-sti_time/2)*fps)];
Xarray = repmat(Xarray, 1, num_cycle);
flicker_trial = repmat(flicker_trial, 1, num_cycle);

cd(makemovie_folder);
all_file = dir('*.mat');
cd (video_folder);
%video frame file
name=[date,'_Drinnenberg_OnOff_movie_5min_Br50_Q100_',num2str(mean_brightness),'mW'];
name
%video setting
video_fps=fps;
writerObj = VideoWriter([name,'.avi']);  %change video name here!
writerObj.FrameRate = video_fps;
writerObj.Quality = 100;
open(writerObj);
%start part: dark adaptation
for mm=1:fps*20
    img=zeros(screen_y,screen_x);
    img(lefty_bd:righty_bd,leftx_bd:rightx_bd) = rest_brightness;
    img(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4)) = 0;
    writeVideo(writerObj,img);
end
for kk =1:length(Xarray)
    a=zeros(screen_y,screen_x);%full screen pixel matrix %it's the LED screen size
    a(lefty_bd:righty_bd,leftx_bd:rightx_bd) = Xarray(kk);
    a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4)) = flicker_trial(kk);
    writeVideo(writerObj,a);
end

%end part video
for mm=1:10
    img=zeros(screen_y,screen_x);
    writeVideo(writerObj,img);
end
close(writerObj);
cd(makemovie_folder);
end
