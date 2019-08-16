%% This code calculate relative bar position by substracting RF center and bin_pos
% It add two new variables absolute_pos and relative_pos to original data
% It add them by overwriting them
% relative_pos is a 60*length(bin_pos) matrix
% It stores relative distance between bar and RF center
%absolute_pos is abosolute distance of relative_pos
close all;
clear all;
code_folder = pwd;
load('calibrate_pt.mat')%Load dotPositionMatrix
load('screen_brightness.mat')%Load screen_brightness
load('boundary_set.mat')
exp_folder = 'E:\20190719';
cd(exp_folder)
load('data\RFcenter.mat')%Needed to run Receptive field.m first
cd sort_merge_spike\MI%Go the directory that stores HMM or OU spikes data
all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;
Y =meaCenter_y;
for z =1:n_file %choose file
    xarray = [];%Store bar center x position
    yarray = [];%Store bar center y position
    
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([filename]);
    relative_pos = zeros(60,length(bin_pos));
    name=[name];
    z
    name
    
    %% Recognize HMM or OU, also directions
     if strcmp(name(17),'H')
        type = 'HMM';
        if strcmp(name(24),'D')
            direction = name(21:25);
        elseif strcmp(name(21),'D')
            direction = name(26:27);
        else
            direction = name(21:22);
        end
    elseif strcmp(name(17),'O')
        type = 'OU';
        if strcmp(name(23),'D')
            direction = name(20:24);
        elseif strcmp(name(20),'D')
            direction = name(25:26);    
        else
            direction = name(20:21);
        end
    else
        disp('Not MI')
        continue
     end
     
     for k = 1:60
        if sum(RFcenter(k,:)) <= 0%If no RF center, it will pass
            continue
        end
        if strcmp(direction,'UD')
            relative_pos(k,:) = (RFcenter(k,2)-meaCenter_y) - (bin_pos(:)-meaCenter_x);
        elseif  strcmp(direction,'RL')
            relative_pos(k,:)= (RFcenter(k,1)-meaCenter_x) - (bin_pos(:)-meaCenter_x);
        elseif  strcmp(direction,'UR_DL')
            relative_pos(k,:)= (-RFcenter(k,1)+ RFcenter(k,2)+meaCenter_x-meaCenter_y)/sqrt(2) - (bin_pos(:)- meaCenter_x);
        elseif  strcmp(direction,'UL_DR')
           relative_pos(k,:) = (RFcenter(k,1)+RFcenter(k,2)-meaCenter_x-meaCenter_y)/sqrt(2) - (bin_pos(:)- meaCenter_x);
        else
            disp('strange direction')
        end
    end
    
     %% Just for check
%       for i = 1:60
%             if sum(RFcenter(i,:)) > 0
%                 figure(i)
%                 plot(relative_pos(i,:))
%             end
%        end
       absolute_pos = abs(relative_pos);%It stores abosulute distance between bars
       save([exp_folder,'\sort_merge_spike\MI\',name,'.mat'],'sorted_spikes','bin_pos','TimeStamps','reconstruct_spikes','diode_BT','BinningInterval','absolute_pos','relative_pos');
end
