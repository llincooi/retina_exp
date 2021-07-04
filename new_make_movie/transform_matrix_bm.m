function img = transform_matrix_bm(calibration_date,frame,degree, maxlum, minlum)
% length(frame) should eqauls to diaganol of diplaying region
% dithering are carried out by minlum=[lowestlum ditherratio]
load(['C:\retina_makemovie\calibration\',calibration_date,'oled_calibration\calibration.mat'])
load(['C:\retina_makemovie\calibration\',calibration_date,'oled_calibration\oled_boundary_set.mat']);
if length(size(frame)) == 1
    region_bm = length(frame);
    region = ceil(region_bm/sqrt(2));
    all_bars = repmat(frame,region_bm,1);
elseif length(size(frame)) == 2
    region_bm = szdim(frame, 1);
    region = ceil(region_bm/sqrt(2));
    all_bars = frame;
end
    index = (ceil(region_bm/2)-(region-1)/2):(ceil(region_bm/2)+(region-1)/2);
    rotate_all_bars = imrotate(all_bars,degree,'nearest','crop');
    if length(minlum) ==1
        rotate_all_bars = rotate_all_bars*(maxlum-minlum)+minlum;
    else
        ditherratio= minlum(2);
        background = rand(size(rotate_all_bars));
        background(background>=ditherratio) = 1;
        background(background<ditherratio) = 0;
        rotate_all_bars = rotate_all_bars*maxlum+(1-rotate_all_bars).*background*minlum(1);
    end
    
    img=zeros(screen_y,screen_x);%full screen pixel matrix %it's the LED screen size
    img((meaCenter_y-(region-1)/2):(meaCenter_y+(region-1)/2),(meaCenter_x-(region-1)/2):(meaCenter_x+(region-1)/2)) = rotate_all_bars(index, index);
end