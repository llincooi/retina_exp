clear all;
load('oled_channel_pos.mat')
load('oled_boundary_set.mat')
load('C:\retina_makemovie\0421 new video Br50\rn_workspace\o_rntestG045.mat')

dt = 1/60;
for Fc = [1,4]
    Xarray = Smooth_OU_generator(300,dt,4.5,rntest,Fc);
    
    newXarray = round(rescale(Xarray, leftx_bar+bar_wid, rightx_bar-bar_wid))-meaCenter_x; %% center of a bar
    sti_matrix = zeros(length(Xarray), mea_size_bm);
    
    matrix_properties.D2BR=3; %width of dark part of Grating to bright part
    cycle = ceil(mea_size_bm/((matrix_properties.D2BR+1)*(1+2*bar_wid)));
    cycle_len = (matrix_properties.D2BR+1)*(1+2*bar_wid)*cycle;
    
    for kk = 1:length(newXarray)
        brightIndex = (mea_size_bm+1)/2+newXarray(kk) + (-bar_wid:bar_wid);
        for c = 1:cycle-1
            brightIndex = [brightIndex, (mea_size_bm+1)/2+newXarray(kk)+(-bar_wid:bar_wid)+c*(matrix_properties.D2BR+1)*(1+2*bar_wid)];
        end
        brightIndex(brightIndex>cycle_len) = brightIndex(brightIndex>cycle_len)-cycle_len;
        brightIndex(brightIndex>mea_size_bm) =[];
        sti_matrix(kk, brightIndex) = 1;
    end
    
    matrix_properties.VideoName = ['grating_3to1_OUsmooth_', num2str(Fc),'_Hz'];
    matrix_properties.CenterBarPos = newXarray+meaCenter_x;
    save(['C:\retina_makemovie\GratingMatrix\grating_3to1_OUsmooth_', num2str(Fc),'_Hz.mat'],'sti_matrix', 'matrix_properties', 'newXarray')
end