function img = transform_matrix_bm(calibration_date,all_bar,degree)
%    length(all_bar) should eqauls to diaganol of diplaying region 
   
    load(['C:\calibration\',calibration_date,'oled_calibration\calibration.mat'])
    load(['C:\calibration\',calibration_date,'oled_calibration\oled_boundary_set.mat']);
    
    region_bm = length(all_bar);
    
    region = ceil(region_bm/sqrt(2));
    
    all_bars = repmat(all_bar,region_bm,1);

    index = (ceil(region_bm/2)-(region-1)/2):(ceil(region_bm/2)+(region-1)/2);
    rotate_all_bars = imrotate(all_bars,degree,'nearest','crop');
%     imagesc(rotate_all_bars(index, index));
    
    img=zeros(screen_y,screen_x);%full screen pixel matrix %it's the LED screen size
    img((meaCenter_y-(region-1)/2):(meaCenter_y+(region-1)/2),(meaCenter_x-(region-1)/2):(meaCenter_x+(region-1)/2)) = rotate_all_bars(index, index);
end