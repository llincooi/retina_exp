clear all;
load('calibrate_pt.mat')%Load dotPositionMatrix
load('screen_brightness.mat')%Load screen_brightness
load('boundary_set.mat')
screen_brightness=screen_brightness./255; %make it to 0-1 range for double (due to imwrite format)
screen_brightness(screen_brightness>1)=1;
screen_brightness(screen_brightness<0)=0;

% %             width   interval
% % grating     300     300
% % jittering   150     150



parameter1 = [376,94,1,800];%1199um
parameter2 = [152 ,38,3,400];%485um
parameter3 = [90,22,8,400];%287um
parameters = [parameter1;parameter2;parameter3];
bar_real_width = 300;
%bar_len = (mea_size_bm-1)/2;

video_fps=60;
writerObj = VideoWriter('0527_grating_300micro.avi');%change video name here!
writerObj.FrameRate = video_fps;
writerObj.Quality = 80;
open(writerObj);
Y =meaCenter_y;
for l = 1:60*5
    a = ones(1024,1280);%Gray frame
    a = a.*0.2;
    writeVideo(writerObj,a);
end
%start part: dark adaptation
% for mm=1:video_fps*20
%     img=zeros(1024,1280);
%     writeVideo(writerObj,img);
% end


for k = 3
    for reversal = [0 1]
        for theta = [0 pi/4 pi/2 pi*3/4]%Direction of moving bar
            for coherent = 0 %grating set 0, coherent set 1
                if pi/4 <= theta && pi*3/4 >= theta
                    longest_dis = mea_size_bm/sin(theta);
                else
                    longest_dis = abs(mea_size_bm/cos(theta));
                end
                
                bar_wid = bar_real_width/ micro_per_pixel/2;;%The bar width is 2*bar_wid+1
                bar_interval = bar_wid*4;%The distance between bar and bar
                bar_len = longest_dis/2;
                num_bar = ceil((longest_dis+2*bar_wid/bar_interval));%number of bar in movie
                num_move = parameters(k,4);%Number of steps that move
                
                
                R_matrix = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
                
                xarray = zeros(num_bar,num_move);%Array that store each bar postion(each row store each bar postions)
                xarray(1,1) = 1;%leftx_bd+bar_wid+1;%Left bar first position
                
                
                if coherent %grating set 0, coherent set 1
                    for i = 2:length(xarray)%Initialize left bar
                        if xarray(1,i-1) <= xarray(1,1)
                            xarray(1,i) = xarray(1,i-1)+2*randsample([1,0],1);
                        else
                            xarray(1,i) = xarray(1,i-1)+2*randsample([1,-1],1);
                        end
                        
                    end
                else
                    for i = 2:length(xarray)
                        xarray(1,i) = xarray(1,i-1)+2;
                    end
                end
                
                if num_bar > 1
                    for i = 2:size(xarray,1)%Calculate other bar
                        xarray(i,:) = xarray(i-1,:)+bar_interval;
                    end
                end
                xarray = mod(xarray-1 , num_bar*bar_interval) +1;
                
                
                if reversal
                    xarray = fliplr(xarray);%For reverse direction
                end
                
                %video setting
                % Time=T; %sec
                
                for kk =1:length(xarray)
                    if xarray(1,kk) > 0%Grating frame
                        
                        a = zeros(1024,1280);%Initialize each frame
                        
                        for i = 1:num_bar%Plot each bar
                            [kk i]
                            X=xarray(i,kk);
                            
                            barX=X+(mea_size_bm-1)/2-(longest_dis/2)+bar_wid;
                            barY=Y-lefty_bd;
                            Vertex = cell(4);
                            Vertex{1} = [barX-bar_wid  barY-bar_le];  %V1  V4
                            Vertex{2} = [barX-bar_wid  barY+bar_le];  %V2  V3
                            Vertex{3} = [barX+bar_wid  barY+bar_le];
                            Vertex{4} = [barX+bar_wid  barY-bar_le];
                            %rotation
                            for i = 1:4
                                Vertex{i} = R_matrix*(Vertex{i}-[(mea_size_bm+1)/2  (mea_size_bm+1)/2])'+[(mea_size_bm+1)/2  (mea_size_bm+1)/2]';
                            end
                            
                            a = write_CalBar(a,Vertex, theta,  mea_size_bm); %a = the bar
                            
                        end
                        %                         a(:,leftx_bd+11)=1;
                        %                         a(:,leftx_bd+471)=1;
                        a(500-35:500+35,1230:1280)=1;
                        writeVideo(writerObj,a);
                        
                        
                    end
                end
                %Interval frame
                for l = 1:100
                    a = ones(1024,1280);%Gray frame
                    a = a.*0.2;
                    writeVideo(writerObj,a);
                end
            end
        end
    end
end

for mm=1:10
    img=zeros(1024,1280);
    
    writeVideo(writerObj,img);
end
close(writerObj);

