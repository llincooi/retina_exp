clear all;
load('oled_channel_pos.mat')
load('oled_boundary_set.mat')
load('C:\retina_makemovie\0421 new video Br50\rn_workspace\o_rntestG045.mat')

dt = 1/60;
for sigma = [6.8, 20, 40, 60];
    
    for Fc = [1,4]
        Xarray = Smooth_OU_generator(300,dt,4.5,rntest,Fc);
        
        newXarray = round(rescale(Xarray, leftx_bar+bar_wid, rightx_bar-bar_wid))-meaCenter_x; %% center of a bar
        sti_matrix = zeros(length(Xarray), mea_size_bm);
        
        for kk = 1:length(newXarray)
            x0 = newXarray(kk);
            xaxis = -(mea_size_bm-1)/2 : (mea_size_bm-1)/2;
            GF = (exp(-((xaxis-x0)/sigma).^2/2));
            sti_matrix(kk, :) = GF;
        end
        
        matrix_properties.VideoName = ['GP_s=', num2str(sigma),'_OUsmooth_', num2str(Fc),'Hz'];
        matrix_properties.CenterBarPos = newXarray+meaCenter_x;
        save(['C:\retina_makemovie\GPMatrix\GP_s=', num2str(sigma),'_OUsmooth_', num2str(Fc),'Hz.mat'],'sti_matrix', 'matrix_properties', 'newXarray')
    end
end