function makeOLED_Bar_video_fc_part(makemovie_folder, theta, direction, video_folder, videoworkspace_folder, type, seed_date, date, calibration_date, mins,  Gvalue, mean_lumin, contrast, cutOffFreq_list, part)
%% This code can produce moving bar video whose trajectory is made of HMM or OU process
%It can make kinds version of moving bar in several pattern: Bright or Dark, by HMM, OU, or smoothed_OU.
%sN means Spatial Noise.
%makemovie_folder is where you put your code
%theta means how much degree you want to rotate. 0 means RL, 1/4pi means UL_DR, 1/2pi means UD, 3/4pi means UR_DL
%video_folder is where you want to save your video
%videoworkspace_folder is where you want to save your videoworkspace
%seed_date is which seed you want to use(0421,0809,0810)
%date is which day produce video
%mins is how long your stimulus is
%calibration_date is which day you calibrate
%Gvalue is  gamma value you want to use
%cutOffFreq_list is the list of cutoff frequency you want
%mean_lumin is background luminance 
%(contrast+1)*mean_lumin is the bar luminance
%if the contrast == j (imaginary) then mean_lumin is the bar luminance, while background lunminance is zero.

%part can be 'right', 'left' or 'mid', dividing mea_reage into three parts.

%% Load boundary_set.mat and calibration.mat
load(['C:\calibration\',calibration_date,'oled_calibration\calibration.mat'])
load(['C:\calibration\',calibration_date,'oled_calibration\oled_boundary_set.mat']);
%% Setup matrix_folder and make matrix
rotation = theta*4/pi;
if contrast == 0 %2nd_Oder_Motion bar
    matrix_folder = ['C:\',calibration_date,'2ndBar_matrix_',num2str(mean_lumin),'mW\'];
    if exist([matrix_folder '\',num2str(rotation)]) == 0
        make_2ndbar_matrix(calibration_date,mean_lumin,rotation);
    else
        disp('Already have produced matrix')
    end
elseif contrast == j
    matrix_folder = ['C:\',calibration_date,'BrightBar_matrix_',num2str(mean_lumin),'mW\'];
    if exist([matrix_folder '\',num2str(rotation)]) == 0
        make_BrightBar_matrix(calibration_date,mean_lumin,rotation);
    else
        disp('Already have produced matrix')
    end
elseif isnan(interp1(real_lum,lum,(contrast+1)*mean_lumin,'linear'))
    disp('There is error about contrast')
    return
else %contrast<0:Dark bar,  contrast>0:Bright bar
    matrix_folder = ['C:\',calibration_date,'Bar_matrix_',num2str(mean_lumin),'mW_',num2str(contrast*100),'%\'];
    if exist([matrix_folder '\',num2str(rotation)]) == 0
        make_bar_matrix(calibration_date,mean_lumin,contrast,rotation);
    else
        disp('Already have produced matrix')
    end
end

%% Video parameter
list = [2.5 3 4.3 4.5 5.3 6.3 6.5 7.5 9 12 20];%Gamma value complete list
seed_directory_name = [seed_date,' new video Br50\rn_workspace'];
cd(['C:\',seed_directory_name]);%New seed for HMM movie
all_file = dir('*.mat');%Load random seed
fps =60;  %freq of the screen flipping
T=mins*60; %second
dt=1/fps;
Time=dt:dt:T;
%% Run each many cutoff frequency
for cutOffFreq = cutOffFreq_list
    %% HMM or OU parameter and video name
    %Random number files ( I specifically choose some certain random seed series)
    file = all_file(find(list==Gvalue)).name;
    [~, name, ext] = fileparts(file);
    filename = [name,ext];
    load(['C:\',seed_directory_name,'\',filename]);
    name=[name];
    if contrast == 0 %2nd_Oder_Motion bar
        name=[date,'_',type,'_2nd_Order_',direction,'_G',num2str(Gvalue) ,'_',int2str(mins),'min_Q100_',num2str(mean_lumin),'mW'];
    elseif contrast == j
        name=[date,'_',type,'_Bright_',direction,'_G',num2str(Gvalue) ,'_',int2str(mins),'min_Q100_',num2str(mean_lumin),'mW'];
    else %contrast<0:Dark bar,  contrast>0:Bright bar
        name=[date,'_',type,'_',direction,'_G',num2str(Gvalue) ,'_',int2str(mins),'min_Q100_',num2str(mean_lumin),'mW_',num2str(contrast*100)];
    end
    %% HMM trajectory
    if strcmp(type,'HMM')
        Xarray = HMM_generator(T,dt,Gvalue,rntest);
        series_type = 'HMM';
    elseif strcmp(type,'OUsmooth')%Smooth OU
        if cutOffFreq == 0
            Xarray = OU_generator(T,dt,Gvalue,rntest);
            series_type = 'OU';
        else
            Xarray = Smooth_OU_generator(T,dt,Gvalue,rntest,cutOffFreq);
            series_type = 'OUsmooth';
        end
        name = [name,'_',num2str(cutOffFreq),'Hz'];
    elseif strcmp(type,'cSTA')%cSTA %30Hz
        Xarray=randn(1,length(Time/2));%Gaussian noise with 30% std
        Xarray = imresize(Xarray, [1 length(Time)], 'nearest'); %30Hz
        name=[date,'_',type,'_',direction,'_',int2str(mins),'min_Q100_',num2str(mean_lumin),'mW_',num2str(contrast*100)];
        series_type = 'cSTA';
    end
    %% Normalize to proper moving range and video name
    if strcmp(part,'left')
        newXarray = round(rescale(Xarray, meaCenter_x-mea_size_bm*1/2+bar_wid, meaCenter_x-mea_size_bm/6-bar_wid));
        name = [name,'_left'];
    elseif strcmp(part,'right')
        newXarray = round(rescale(Xarray, meaCenter_x+mea_size_bm/6+bar_wid, meaCenter_x+mea_size_bm*1/2-bar_wid));
        name = [name,'_right'];
    elseif strcmp(part,'mid')
        newXarray = round(rescale(Xarray, meaCenter_x-mea_size_bm/6+bar_wid, meaCenter_x+mea_size_bm/6-bar_wid));
        name = [name,'_mid'];
    end
    name
    cd (video_folder)
    
    %% Video setting
    video_fps=fps;
    writerObj = VideoWriter([name,'.avi']);  %change video name here!
    writerObj.FrameRate = video_fps;
    writerObj.Quality = 100;
    open(writerObj);
    %% Start part: adaptation
    for mm=1:fps*20
        img=zeros(screen_y,screen_x);
        if contrast == 0
            load([matrix_folder,'\origin.mat']);% Load the origin noisy picture matrix
        else %Set to mean luminance
            img(lefty_bd:righty_bd,leftx_bd:rightx_bd) = interp1(real_lum,lum,mean_lumin,'linear');
        end
        writeVideo(writerObj,img);
    end
    
    %% Draw moving bar
    for kk =1:length(Time)
        load([matrix_folder,num2str(theta*4/pi),'\',num2str(newXarray(kk)),'.mat']);% Load picture matrix
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
    for mm=1:10
        img=zeros(screen_y,screen_x);
        img(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0.2; %gray
        writeVideo(writerObj,img);
    end
    img=zeros(screen_y,screen_x);
    writeVideo(writerObj,img);
    close(writerObj);
    cd(videoworkspace_folder)
    %% Save parameters needed
    stimulation_type = 'Bar';
    save([name,'.mat'],'newXarray','series_type','stimulation_type','direction', 'contrast', 'mean_lumin', 'theta', 'part')
end
cd(makemovie_folder)
end
