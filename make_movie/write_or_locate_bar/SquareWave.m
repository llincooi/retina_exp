clear all;
load('oled_channel_pos.mat')
load('oled_boundary_set.mat')
load('C:\retina_makemovie\0421 new video Br50\rn_workspace\o_rntestG045.mat')

dt = 1/60;
for hw = [8];
    for Fc = [1,4]
        Xarray = Smooth_OU_generator(300,dt,4.5,rntest,Fc);
        
        newXarray = round(rescale(Xarray, leftx_bar+bar_wid, rightx_bar-bar_wid))-meaCenter_x; %% center of a bar
        sti_matrix = zeros(length(Xarray), mea_size_bm);
        
        for kk = 1:length(newXarray)
            brightIndex = (mea_size_bm+1)/2+newXarray(kk) + (-hw:hw);
            sti_matrix(kk, brightIndex) = 1;
        end
        
        matrix_properties.VideoName = ['SW_hw=', num2str(hw),'_OUsmooth_', num2str(Fc),'Hz'];
        matrix_properties.CenterBarPos = newXarray+meaCenter_x;
        mkdir 'C:\retina_makemovie\SWMatrix'
        save(['C:\retina_makemovie\SWMatrix\SW_hw=', num2str(hw),'_OUsmooth_', num2str(Fc),'Hz.mat'],'sti_matrix', 'matrix_properties', 'newXarray')
    end
end