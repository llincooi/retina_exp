function makeOLED_video_rot(WherenWhen, theta, lumin, sti_matrix, series)
%%
% WherenWhen
    % date: today
    % video_folder: where to export video
    % videoworkspace_folder: where to export video details
    % calibration_date: when is the setup calibrated
    % productfolder: where keep series and sti_matirx ('C:\retina_makemovie\')
% theta: rotation of the stimulus (rad)
% lum: [maxlum minlum] maxlum<minlum means a inverse stimulus
% sti_matrix: load or create sti_matrix
    % type: 'SW':square wave; 'GP': Gaussian pulse; 'Grating'
    % width: half width of 'SW' and 'Grating'; sigma for 'GP';
    %addtional term for dark spation period of 'Grating'
    % length: 'long': 1-D matrix repeated to 2-D; short: 2-D matrix
    % dynamical range
% series:
    % type: 'HMM', 'OU', 'LPOU'
    % Fc: cutoff_frequency for 'LPOU'
    % G: Gamma in HMM and tau in OU
    % seeddate: where to import random seed ('mmdd')
    % length: (min)


%% basic setting
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\calibration.mat'])
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\oled_boundary_set.mat']);
fps=60;  %
dt=1/fps; %s
Time = series.length*60; %s
thetaD = -theta*180/pi; %rad to degree
%% load or create series
if strcmp(series.type, 'HMM') || strcmp(series.type, 'OU')
    VideoName_A = [series.type,'_G',num2str(series.G), '_'];
    try
        load([WherenWhen.productfolder, 'series_folder\',series.seeddate,'_', VideoName_A ,num2str(series.length),'min.mat']);
    catch
        Xarray = series_generator(series.type, series.length, Gvalue, series.seeddate, 0, WherenWhen.productfolder);
    end
else
    VideoName_A = [series.type,'_G',num2str(series.G), '_',num2str(series.Fc),'Hz_'];
    try
        load([WherenWhen.productfolder, 'series_folder\', series.seeddate,'_', VideoName_A ,num2str(series.length),'min.mat']);
    catch
        Xarray = series_generator(series.type, series.length, Gvalue, series.seeddate, series.F_c, WherenWhen.productfolder);
    end
end
%% sti_matrix
if strcmp(sti_matrix.type, 'SW')
    VideoName_B = [sti_matrix.type,'\_hw',num2str(sti_matrix.width),'_',sti_matrix.length];
    try
        load([WherenWhen.productfolder, 'sti_matrix_folder\',VideoName_B,...
            '_',num2str(sti_matrix.dynamical_range(1)),'to',num2str(sti_matrix.dynamical_range(2)),'.mat']);
    catch
        sti_matrix = sti_matrix_generator(sti_matrix.type, sti_matrix.width, sti_matrix.length,...
            sti_matrix.dynamical_range, WherenWhen.productfolder);
    end
elseif strcmp(sti_matrix.type, 'GP')
    VideoName_B = [sti_matrix.type,'\_sigma',num2str(sti_matrix.width),'_',sti_matrix.length];
    try
        load([WherenWhen.productfolder, 'sti_matrix_folder\',VideoName_B,...
            '_',num2str(sti_matrix.dynamical_range(1)),'to',num2str(sti_matrix.dynamical_range(2)),'.mat']);
    catch
        sti_matrix = sti_matrix_generator(sti_matrix.type, sti_matrix.width, sti_matrix.length,...
            sti_matrix.dynamical_range, WherenWhen.productfolder);
    end
elseif strcmp(sti_matrix.type, 'Grating')
    VideoName_B = [sti_matrix.type,'\_hw',num2str(sti_matrix.width(1)),'_DBrR',num2str(sti_matrix.width(2)), '_' ,sti_matrix.length];
    try
        load([WherenWhen.productfolder, 'sti_matrix_folder\', VideoName_B, '_',num2str(sti_matrix.dynamical_range(1)),...
            'to',num2str(sti_matrix.dynamical_range(2)),'.mat']);
    catch
        sti_matrix = sti_matrix_generator(sti_matrix.type, sti_matrix.width, sti_matrix.length,...
            sti_matrix.dynamical_range, WherenWhen.productfolder);
    end
end
%% rescale series to fit in stimulus dynamical_range
newXarray = round(rescale(Xarray, sti_matrix.dynamical_range(1), sti_matrix.dynamical_range(2));
S2SIndex = newXarray - sti_matrix.dynamical_range(1); %index from series to sti_matrix
%% lumin setting
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
%% Video setting
VideoName = [VideoName_A, VideoName_B];
if theta == 0
    name = [WherenWhen.date, '_', VideoName, '_RL_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi/2
    name = [WherenWhen.date, '_', VideoName, '_UD_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi/4
    name = [WherenWhen.date, '_', VideoName, '_UL_DR_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
elseif theta == pi*3/4
    name = [WherenWhen.date, '_', VideoName, '_UR_DL_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
else
    name = [WherenWhen.date, '_', VideoName, '_d', num2str(thetaD), '_', num2str(lumin(1)), 'v', num2str(lumin(2)), 'mW']
end
video_fps = fps;
writerObj = VideoWriter([WherenWhen.video_folder,name,'.avi']);  %change video name here!
writerObj.FrameRate = video_fps;
writerObj.Quality = 100;
open(writerObj);


%% Start part: adaptation
img=zeros(screen_y,screen_x);
for mm=1:fps*20
    writeVideo(writerObj,img);
end
%% Draw matrix
for kk =1:length(Time)
    a = transform_matrix_bm(WherenWhen.calibration_date,sti_matrix(S2SIndex(kk),:),thetaD, bar_lumin, background_lumin);
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
save([WherenWhen.videoworkspace_folder, name,'.mat'],'newXarray')
end