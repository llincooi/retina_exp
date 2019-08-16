%% This code calculate HMM and OU bar position STA
close all;
clear all;
code_folder = pwd;
exp_folder = 'E:\20190719';
cd(exp_folder);
mkdir STA
cd sort_merge_spike\MI
all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;

forward = 90;%90 bins before spikes for calculating STA
backward = 90;%90 bins after spikes for calculating STA

for z =1:n_file %choose file
    
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load(filename);
    name=[name];
    z
    name
    
     % put your stimulus here!!
    TheStimuli=relative_pos;  %recalculated bar position
    time=[-forward :backward]*BinningInterval;
    % Binning
    bin=BinningInterval*10^3; %ms
    BinningTime =diode_BT;
    
    %% BinningSpike and calculate STA
    BinningSpike = zeros(60,length(BinningTime));
    sum_n = zeros(1,60);
    dis_STA = zeros(60,forward+backward+1);
    for i = 1:60  % i is the channel number
        if sum(abs(TheStimuli(i,:))) <= 0
            disp(['channel ',int2str(i),'does not have RF center'])
            continue
        end
        [n,~] = hist(sorted_spikes{i},BinningTime) ;  
        BinningSpike(i,:) = n ;
        sum_n(i) = sum_n(i)+ sum(BinningSpike(i,forward+1:length(BinningTime)-backward));
        for time_shift = forward+1:length(BinningTime)-backward
            dis_STA(i,:) = dis_STA(i,:) + BinningSpike(i,time_shift)*TheStimuli(i,time_shift-forward:time_shift+backward);
        end
        dis_STA(i,:) = dis_STA(i,:)/sum_n(i);
    end
    save([exp_folder,'\STA\',name(17:end),'.mat'],'time','dis_STA')
end
