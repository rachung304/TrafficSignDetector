%Problem 5
%PLEASE READ before running this code
%Uncomment lines labeled depending on using stop.jpg or yield.jpg
%Correct edge detection will NOT SHOW if this is not done right
clear all
close all
%load image
%Uncomment line below for stop
%img = imread('stop.jpg');
%Uncomment line below for yield
img = imread('yield.jpg');

% separate img into its red and blue layers
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
%three differnt layers we can test out
%Uncomment one of these layers to find which one works best
layer1 = uint8(R-G);
%layer2 = uint8(R-B);
%later3 = uint8(G-B);
%Red Layer minus Blue layer works the best
%so uncomment layer1

%Step 1 find edge
%sobel to detect edge
detected_edge = edge(layer1,'sobel'); 
%uncomment line below for testing the detected edge
%imshow(detected_edge);

%Step 2 compute hough transform
[H, T, R] = hough(detected_edge); 

%Step 3 Find the peaks of the transform: houghpeaks()
%Uncomment line below for stop.jpg
%P = houghpeaks(H,12,'threshold',ceil(0.3*max(H(:))));
%Uncomment line below for yield
P = houghpeaks(H,6,'threshold',ceil(0.25*max(H(:))));
 
%Step 4 Find the lines associated with the transform: houghlines() 
%Uncomment line below for stop
%hlines = houghlines(detected_edge,T,R,P,'FillGap',15,'MinLength',60); 
%Uncomment line below for yield
hlines = houghlines(detected_edge,T,R,P,'FillGap',30,'MinLength',150); 

%Step 5 Plot the lines
%only need point1 and point2
figure
subplot(2,2,1); 
imshow(img) 
title('Original Image');
subplot(2,2,2)
imshow(detected_edge)
title('Edge Detection on Red Layer Minus Green Layer');
subplot(2,2,3)
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
    'InitialMagnification','fit'); 
xlabel('\theta (degrees)');
ylabel('\rho (pixels)');
axis on
axis normal
title('Hough Transform as Image');
colorbar;
subplot(2,2,4)
imshow(img)
title('Lines Superimposed on Original Image');
hold on;

% superimpose lines onto original image
%Reference: http://www.mathworks.com/help/images/ref/houghlines.html
max_len = 0;
for k = 1:length(hlines)
   xy = [hlines(k).point1; hlines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',3,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',3,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(hlines(k).point1 - hlines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;  
   end
end
%To highlight the longest line segment
%Uncomment line below
%Longest line will be higglighted in blue
%plot(xy_long(:,1),xy_long(:,2),'LineWidth',3,'Color','blue');
