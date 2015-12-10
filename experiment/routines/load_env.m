load('filters/laplace.mat');
load('filters/roberts.mat');
load('filters/sobel.mat');

% Load true edge images
x9343AMtrue = read_image('images/9343 AM Edges.bmp', 0);
x10905JLtrue = read_image('images/10905 JL Edges.bmp', 0);
x43590AMtrue = read_image('images/43590 AM Edges.bmp', 0);

x9343AMg = read_image('images/9343 AM.bmp', 1);
%x9343AMg = imadjust(x9343AMg);
level = graythresh(x9343AMg);
x9343AMbw = single(im2bw(x9343AMg, level));

x10905JLg = read_image('images/10905 JL.bmp', 1);
level = graythresh(x10905JLg);
x10905JLbw = double(im2bw(x10905JLg, level));

x43590AMg = read_image('images/43590 AM.bmp', 1);
level = graythresh(x43590AMg);
x43590AMbw = double(im2bw(x43590AMg, level));

% ===============
% === 9343 AM ===
% ===============

% Show background graphs
% ----------------------

%show_background(x9343AMg);
%show_background(x10905JLg);
%show_background(x43590AMg);

% First order methods
% -------------------

% Otsu
x9343AMbwOtsu = detect_edges(x9343AMbw, sobelX, sobelY) >= 1;
x9343AMbwOtsuROC = compute_roc(x9343AMbwOtsu, x9343AMtrue);

% Sobel without imadjust
x9343AMgSobel = detect_edges(x9343AMg, sobelX, sobelY);
x9343AMbwSobel65 = x9343AMgSobel > 65;

% Sobel with imadjust
x9343AMgaSobel = detect_edges(imadjust(x9343AMg), sobelX, sobelY);
x9343AMbwaSobel65 = x9343AMgaSobel > 65;

% Roberts without imadjust
x9343AMgRoberts = detect_edges(x9343AMbw, robertsA, robertsB);

% Roberts with imadjust

% Canny without imadjust
%x9343AMgCanny = canny(x9343AMg);
x9343AMgCanny = edge(x9343AMg, 'Canny');

% Canny with imadjust

% Edge detection using dilate-erode method
% Dilate mask size 3
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
x9343AMgSobelDilate = imdilate(x9343AMgSobel, [se90, se0]);

x9343AMgSobelFilled = imfill(x9343AMgSobelDilate, 'holes');

seD = strel('diamond', 1);
x9343AMgSobelEroded = imerode(x9343AMgSobelFilled, seD);
x9343AMgSobelEroded = imerode(x9343AMgSobelEroded, seD);
%x9343AMgSobelEroded = imerode(x9343AMgSobelEroded, seD);
x9343AMgSobelFinal = detect_edges(x9343AMgSobelEroded, sobelX, sobelY) > 60; % Threshold

% Histogram based edge detection


% Second order methods
% --------------------

% LoG
x9343AMgSmooth = gaussian_smoothing(x9343AMg, 2);
x9343AMgLoG = conv2(x9343AMgSmooth, laplace);
x9343AMgLoG = edge(x9343AMgLoG, 'zerocross');

% DoG
x9343AMgSmooth1 = gaussian_smoothing(x9343AMg, 1);
x9343AMgSmooth2 = gaussian_smoothing(x9343AMg, 5);
x9343AMgDoG = x9343AMgSmooth2 - x9343AMgSmooth1;
x9343AMgDoG = edge(x9343AMgDoG, 'zerocross');

% ================
% === 10905 JL ===
% ================

% =================
% === ROC space ===
% =================

x9343AMsens = x9343AMbwOtsuROC(1);
x9343AMnspec = 1 - x9343AMbwOtsuROC(2);

