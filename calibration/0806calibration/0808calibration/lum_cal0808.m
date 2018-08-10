%%Open phychotoolbox
Screen('Preference', 'SkipSyncTests', 1)
global rect w
[w, rect] = Screen('OpenWindow',1, [0 0 0]); %black background
[oldmaximumvalue, oldclampcolors, oldapplyToDoubleInputMakeTexture] = Screen('ColorRange', w);
width = 541;
baseRect = [0 0 width width]; %use odd number %for bigger mea region % I just think 541 is appropriate
meaCenter_x=630; 
meaCenter_y=605;  %%%%%%%%%%%%%%%%Remember to check
LED_based_color=180;%Luminance 50
centeredRect = CenterRectOnPointd(baseRect, meaCenter_x, meaCenter_y);
Screen('FillRect', w, LED_based_color,centeredRect); 
Screen('Flip', w);


%% select the calibration region from ccd image
%because from the ccd image, only part of the region correspond to the bigger mea region. Therefore, we just need to calibrate that region
%choose that region in this section
A= imread('/Users/nghdavid/Desktop/00Calibration/Lum_cal/dirty spots in mea region.tif'); %read in the ccd imgae
figure; imshow(A);

Igray = rgb2gray(A);
BW1 = edge(img,'Canny');

BW2 = edge(Igray,'Prewitt');

imshow(BW2);


[x,y] = ginput(1); %catch the edge coordinate
x1=717; %top left x
x2=1425; %bottom right x
y1=669;  %top left y
y2=1377;  %bottom right y


figure; imshow(A(y1:y2,x1:x2));
colorbar
%% start 1st calibration
%take an ccd image first
% A = imread('C:\Users\Hydrolab320\Desktop\Oct2017_calibration\Lum_1st_gain0_expT800000.tif');
A = imread('/Users/nghdavid/Desktop/00Calibration/Lum_cal/Lum_1st_gain0_expT800000.tif'); %read in the ccd image
selected_img_1st=A(y1:y2,x1:x2);
figure; imshow(selected_img_1st);
%check distortion level
figure; histogram(selected_img_1st)  % see the histogram of the luminance value
%determine the center lum from the histogram


center_color=98; % most dominant lum = 98; so choose the center to be 98
%center_color is still uint8 class
%center_color=selected_img_1st(round(length(selected_img_1st)/2),round(length(selected_img_1st)/2))


%% generate LCD point
%lcd_pt store the coordinations of the points in the bigger mea region on monitor
%can simply use leftx=1, lefty=1, x_diff_lcd=10 to try these code, and you can understand the function of these parts
lcd_pt=[];  
x_diff_lcd=541; %the length of the bigger mea region on LED 
lcd_pt(1,1)=meaCenter_x-(x_diff_lcd-1)/2; %the top left corner position x on LED screen 
for i=1:x_diff_lcd
    lcd_pt(1,i)=lcd_pt(1,1)+(i-1)*1;
    dump_x(1,i)=lcd_pt(1,1)+(i-1)*1;
end
q=1;  turn=1;
for i=1:x_diff_lcd^2
    lcd_pt(1,i)= dump_x(1,turn);
    if q==x_diff_lcd
       turn=turn+1; q=1;
    else q=q+1;
    end
end
% lcd_pt = sort(lcd_pt,'descend'); %exchange left to right, due to the orentation difference of ccd and LCD
%compute position y
top_left_y=meaCenter_y-(x_diff_lcd-1)/2; %the top left corner position y on LED screen 
for i=1:x_diff_lcd  
     lcd_pt(2,i)=top_left_y+(i-1)*1;  %LED and ccd 's top and down are in the same orientation 
end
%exchange up and down coordinates, due to the orentation difference of ccd and LCD screen
lcd_pt(2,1:max(find(lcd_pt(2,:)~=0))) = sort(lcd_pt(2,1:max(find(lcd_pt(2,:)~=0))),'descend'); 
lcd_pt(2,1:x_diff_lcd^2)=repmat(lcd_pt(2,1:x_diff_lcd),1,x_diff_lcd);  %copy the y array

%make positions into a cell matrix
for i=1:x_diff_lcd^2  
      matrix_lcd_pt{i}=[lcd_pt(1,i),lcd_pt(2,i)];
end



%% Open camera and camera object for it

g = gigecam('169.254.0.1');
preview(g)
g.ExposureTime = 800000;
g.Resolution = '2048x2048';


closePreview(g)
img = snapshot(g);
imshow(img)

x0=ones(x_diff_lcd,x_diff_lcd)*LED_based_color;
x = fminsearch(@errorMeasure,x0);



%%
%take another ccd image after using this calibrated image shown on moitor
% A2= imread('C:\Users\Hydrolab320\Desktop\Oct2017_calibration\Lum_2nd_gain0_expT800000.tif');
A2= imread('/Users/nghdavid/Desktop/00Calibration/Lum_cal/Lum_2nd_gain0_expT800000.tif');
% figure; imshow(A2);
figure; imshow(A2(y1:y2,x1:x2));
%test whether it's correct on figure
selected_img_2nd=A2(y1:y2,x1:x2);
%check distortion level
figure; histogram(selected_img_2nd)
figure; histogram(selected_img_1st)
