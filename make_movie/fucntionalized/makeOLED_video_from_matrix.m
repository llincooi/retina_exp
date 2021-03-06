function makeOLED_video_from_matrix(WherenWhen, theta, lumin, sti_matrix, matrix_properties, newXarray)
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\calibration.mat'])
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\oled_boundary_set.mat']);
fps=60;  %freq of the screen flipping
dt=1/fps; %second
Time = (1:size(sti_matrix, 1))*dt;
thetaD = -theta*180/pi;
%% Video setting
if theta == 0
    name = [WherenWhen.date, '_', matrix_properties.VideoName, '_RL_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi/2
    name = [WherenWhen.date, '_', matrix_properties.VideoName, '_UD_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi/4
    name = [WherenWhen.date, '_', matrix_properties.VideoName, '_UL_DR_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi*3/4
    name = [WherenWhen.date, '_', matrix_properties.VideoName, '_UR_DL_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
else
    name = [WherenWhen.date, '_', matrix_properties.VideoName, '_d', num2str(thetaD), '_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
end
video_fps=fps;
writerObj = VideoWriter([WherenWhen.video_folder,name,'.avi']);  %change video name here!
writerObj.FrameRate = video_fps;
writerObj.Quality = 100;
open(writerObj);

bar_lumin = interp1(real_lum,lum, lumin(1),'linear');
if lumin(2) == 0
    background_lumin = 0;
elseif lumin(2) >= 0.2
    background_lumin = interp1(real_lum,lum,lumin(2),'linear');
else
    lowestbackground_lumin = interp1(real_lum,lum,0.2,'linear');
    ditherratio = 1 - lumin(2)/0.2;
    background_lumin = [lowestbackground_lumin, ditherratio];
end
%% Start part: adaptation
img=zeros(screen_y,screen_x);
for mm=1:fps*20
    writeVideo(writerObj,img);
end
%% Draw matrix
for kk =1:length(Time)
    a = transform_matrix_bm(WherenWhen.calibration_date,sti_matrix(kk,:),thetaD, bar_lumin, background_lumin); 
    %% Square_flicker
    if mod(kk,3)==1 %odd number
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=1; % white square
    elseif mod(kk,3)==2
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0.2; %gray
    else
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0; % dark
    end
    writeVideo(writerObj,a);
end
%% End part video for detection of ending
img=zeros(screen_y,screen_x);
img(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0.2; %gray
for mm=1:10
    writeVideo(writerObj,img);
end
img=zeros(screen_y,screen_x);
writeVideo(writerObj,img);
close(writerObj);

% [WherenWhen.videoworkspace_folder, name,'.mat']
save([WherenWhen.videoworkspace_folder, name,'.mat'],'newXarray','matrix_properties')
end